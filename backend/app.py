from contextlib import contextmanager
from datetime import datetime, timedelta, timezone
import re
from typing import Any
from uuid import UUID

import bcrypt
from flask import Flask, current_app, g, jsonify, request
from flask_cors import CORS
import jwt
import psycopg2
from psycopg2 import errors
from psycopg2.extras import RealDictCursor
from pwdlib import PasswordHash

try:
    from backend import config
except ModuleNotFoundError:
    import config

legacy_password_hasher = PasswordHash.recommended()


def create_app(test_config: dict[str, Any] | None = None) -> Flask:
    app = Flask(__name__)
    app.config.from_object(config)
    if test_config:
        app.config.update(test_config)
    CORS(app)

    @app.errorhandler(psycopg2.Error)
    def handle_database_error(error: psycopg2.Error):
        app.logger.exception("Database request failed")
        return jsonify(error="La base de données est indisponible."), 503

    @app.get("/api/health")
    def health():
        with db_connection() as connection:
            with connection.cursor() as cursor:
                cursor.execute("SELECT 1")
        return jsonify(status="ok", database="connected")

    @app.post("/api/auth/register")
    def register():
        payload = request.get_json(silent=True) or {}
        email = payload.get("email")
        password = payload.get("password")
        if not isinstance(email, str) or not _is_valid_email(email.strip()):
            return jsonify(error="Saisissez une adresse e-mail valide."), 400
        if not isinstance(password, str) or not 8 <= len(password.encode("utf-8")) <= 72:
            return jsonify(error="Le mot de passe doit contenir de 8 à 72 octets."), 400

        normalized_email = email.strip().lower()
        full_name = payload.get("full_name")
        if full_name is None:
            full_name = normalized_email.split("@", 1)[0]
        if not isinstance(full_name, str) or not full_name.strip():
            return jsonify(error="Le nom complet est obligatoire."), 400
        if len(full_name.strip()) > 120:
            return jsonify(error="Le nom complet dépasse 120 caractères."), 400
        password_hash = bcrypt.hashpw(
            password.encode("utf-8"), bcrypt.gensalt()
        ).decode("ascii")
        try:
            with db_connection() as connection:
                with connection.cursor(cursor_factory=RealDictCursor) as cursor:
                    cursor.execute(
                        """
                        INSERT INTO users (full_name, email, password_hash)
                        VALUES (%s, %s, %s)
                        RETURNING id, full_name, email
                        """,
                        (full_name.strip(), normalized_email, password_hash),
                    )
                    user = cursor.fetchone()
                    user_id = str(user["id"])
                    cursor.execute(
                        """
                        INSERT INTO family_members
                            (user_id, nom, lien, profession, photo_url)
                        SELECT %s, legacy.nom, legacy.lien,
                               legacy.profession, legacy.photo_url
                        FROM family_members AS legacy
                        WHERE legacy.user_id IS NULL
                          AND NOT EXISTS (
                              SELECT 1
                              FROM family_members AS owned
                              WHERE owned.user_id = %s
                                AND owned.nom = legacy.nom
                          )
                        """,
                        (user_id, user_id),
                    )
                    cursor.execute(
                        """
                        INSERT INTO family_members
                            (user_id, nom, lien, profession, photo_url)
                        SELECT %s, template.nom, template.lien,
                               template.profession, template.photo_url
                        FROM family_templates AS template
                        WHERE NOT EXISTS (
                            SELECT 1
                            FROM family_members AS member
                            WHERE member.user_id = %s
                              AND member.nom = template.nom
                        )
                        """,
                        (user_id, user_id),
                    )
        except errors.UniqueViolation:
            return jsonify(error="Cette adresse e-mail est déjà inscrite."), 409

        return jsonify(
            user={
                "id": str(user["id"]),
                "full_name": user["full_name"],
                "email": user["email"],
            }
        ), 201

    @app.post("/api/auth/login")
    def login():
        payload = request.get_json(silent=True) or {}
        email = payload.get("email")
        password = payload.get("password")
        if not isinstance(email, str) or not isinstance(password, str):
            return jsonify(error="Adresse e-mail ou mot de passe incorrect."), 401

        with db_connection() as connection:
            with connection.cursor(cursor_factory=RealDictCursor) as cursor:
                cursor.execute(
                    """
                    SELECT id, full_name, email, password_hash
                    FROM users
                    WHERE email = %s
                    """,
                    (email.strip().lower(),),
                )
                user = cursor.fetchone()
                password_matches = user is not None and _verify_password(
                    password, user["password_hash"]
                )
                if password_matches and not _is_bcrypt_hash(user["password_hash"]):
                    upgraded_hash = bcrypt.hashpw(
                        password.encode("utf-8"), bcrypt.gensalt()
                    ).decode("ascii")
                    cursor.execute(
                        "UPDATE users SET password_hash = %s WHERE id = %s",
                        (upgraded_hash, user["id"]),
                    )

        if not password_matches:
            return jsonify(
                error="Identifiants incorrects - Vérifiés par le serveur."
            ), 401

        token = _create_token(user["id"])
        return jsonify(
            token=token,
            user={
                "id": str(user["id"]),
                "full_name": user["full_name"],
                "email": user["email"],
            },
        )

    @app.get("/api/famille")
    @token_required
    def get_famille():
        with db_connection() as connection:
            with connection.cursor(cursor_factory=RealDictCursor) as cursor:
                cursor.execute(
                    """
                    SELECT id, nom, lien, profession, photo_url
                    FROM family_members
                    WHERE user_id = %s
                    ORDER BY id
                    """,
                    (g.user_id,),
                )
                members = cursor.fetchall()
        return jsonify([_serialize_member(member) for member in members])

    @app.post("/api/famille")
    @token_required
    def add_famille():
        payload, error = _validate_family_payload(request.get_json(silent=True))
        if error:
            return jsonify(error=error), 400
        with db_connection() as connection:
            with connection.cursor(cursor_factory=RealDictCursor) as cursor:
                cursor.execute(
                    """
                    INSERT INTO family_members
                        (user_id, nom, lien, profession, photo_url)
                    VALUES (%s, %s, %s, %s, %s)
                    RETURNING id, nom, lien, profession, photo_url
                    """,
                    (
                        g.user_id,
                        payload["nom"],
                        payload["lien"],
                        payload["profession"],
                        payload["photo_url"],
                    ),
                )
                member = cursor.fetchone()
        return jsonify(_serialize_member(member)), 201

    @app.put("/api/famille/<uuid:member_id>")
    @token_required
    def update_famille(member_id: UUID):
        payload, error = _validate_family_payload(request.get_json(silent=True))
        if error:
            return jsonify(error=error), 400
        with db_connection() as connection:
            with connection.cursor(cursor_factory=RealDictCursor) as cursor:
                cursor.execute(
                    """
                    UPDATE family_members
                    SET nom = %s, lien = %s, profession = %s, photo_url = %s
                    WHERE id = %s AND user_id = %s
                    RETURNING id, nom, lien, profession, photo_url
                    """,
                    (
                        payload["nom"],
                        payload["lien"],
                        payload["profession"],
                        payload["photo_url"],
                        str(member_id),
                        g.user_id,
                    ),
                )
                member = cursor.fetchone()
        if member is None:
            return jsonify(error="Membre de famille introuvable."), 404
        return jsonify(_serialize_member(member))

    @app.delete("/api/famille/<uuid:member_id>")
    @token_required
    def delete_famille(member_id: UUID):
        with db_connection() as connection:
            with connection.cursor() as cursor:
                cursor.execute(
                    "DELETE FROM family_members WHERE id = %s AND user_id = %s",
                    (str(member_id), g.user_id),
                )
                deleted = cursor.rowcount
        if deleted == 0:
            return jsonify(error="Membre de famille introuvable."), 404
        return "", 204

    return app


@contextmanager
def db_connection():
    connection = psycopg2.connect(current_app.config["DATABASE_URL"])
    try:
        yield connection
        connection.commit()
    except Exception:
        connection.rollback()
        raise
    finally:
        connection.close()


def token_required(function):
    from functools import wraps

    @wraps(function)
    def decorated(*args, **kwargs):
        authorization = request.headers.get("Authorization", "")
        scheme, separator, token = authorization.partition(" ")
        if scheme.lower() != "bearer" or not separator or not token.strip():
            return jsonify(error="Jeton d’authentification manquant."), 401
        try:
            payload = jwt.decode(
                token.strip(),
                _secret_key(),
                algorithms=["HS256"],
            )
            subject = payload.get("sub")
            if not isinstance(subject, str):
                raise ValueError("Invalid user id")
            user_id = str(UUID(subject))
        except (jwt.InvalidTokenError, KeyError, TypeError, ValueError):
            return jsonify(error="Jeton d’authentification invalide."), 403
        g.user_id = user_id
        return function(*args, **kwargs)

    return decorated


def _create_token(user_id: UUID | str) -> str:
    expires_at = datetime.now(timezone.utc) + timedelta(
        hours=current_app.config["TOKEN_EXPIRATION_HOURS"]
    )
    return jwt.encode(
        {"sub": str(user_id), "exp": expires_at},
        _secret_key(),
        algorithm="HS256",
    )


def _secret_key() -> str:
    secret = current_app.config.get("SECRET_KEY")
    if not isinstance(secret, str) or len(secret) < 32:
        raise RuntimeError("SECRET_KEY doit contenir au moins 32 caractères.")
    return secret


def _verify_password(password: str, password_hash: str) -> bool:
    try:
        if _is_bcrypt_hash(password_hash):
            return bcrypt.checkpw(
                password.encode("utf-8"),
                password_hash.encode("ascii"),
            )
        if password_hash.startswith("$argon2"):
            return legacy_password_hasher.verify(password, password_hash)
    except (ValueError, UnicodeEncodeError):
        return False
    return False


def _is_bcrypt_hash(password_hash: str) -> bool:
    return password_hash.startswith(("$2a$", "$2b$", "$2y$"))


def _serialize_member(member: dict[str, Any]) -> dict[str, Any]:
    result = dict(member)
    result["id"] = str(result["id"])
    return result


def _is_valid_email(email: str) -> bool:
    return re.fullmatch(r"[^@\s]+@[^@\s]+\.[^@\s]+", email) is not None


def _validate_family_payload(payload: Any) -> tuple[dict[str, Any] | None, str | None]:
    if not isinstance(payload, dict):
        return None, "Le corps de la requête doit être un objet JSON."
    fields = {
        "nom": 100,
        "lien": 80,
        "profession": 120,
    }
    cleaned: dict[str, Any] = {}
    for field, max_length in fields.items():
        value = payload.get(field)
        if not isinstance(value, str) or not value.strip():
            return None, f"Le champ {field} est obligatoire."
        if len(value.strip()) > max_length:
            return None, f"Le champ {field} dépasse {max_length} caractères."
        cleaned[field] = value.strip()

    photo_url = payload.get("photo_url")
    if photo_url is not None and not isinstance(photo_url, str):
        return None, "Le champ photo_url doit être une chaîne ou null."
    if isinstance(photo_url, str) and len(photo_url) > 2048:
        return None, "Le champ photo_url dépasse 2048 caractères."
    cleaned["photo_url"] = photo_url.strip() if photo_url else None
    return cleaned, None


app = create_app()


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000, debug=False)
