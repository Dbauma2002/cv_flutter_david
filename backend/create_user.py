from contextlib import closing
from getpass import getpass
import re

import bcrypt
import psycopg2
from psycopg2.extras import RealDictCursor

try:
    from backend.config import DATABASE_URL
except ModuleNotFoundError:
    from config import DATABASE_URL


def main() -> None:
    email = input("Adresse e-mail du compte : ").strip().lower()
    if re.fullmatch(r"[^@\s]+@[^@\s]+\.[^@\s]+", email) is None:
        raise SystemExit("Adresse e-mail invalide.")

    password = getpass("Nouveau mot de passe (8 à 72 octets) : ")
    confirmation = getpass("Confirmer le mot de passe : ")
    if password != confirmation:
        raise SystemExit("Les mots de passe ne correspondent pas.")
    if not 8 <= len(password.encode("utf-8")) <= 72:
        raise SystemExit("Le mot de passe doit contenir de 8 à 72 octets.")

    password_hash = bcrypt.hashpw(
        password.encode("utf-8"), bcrypt.gensalt()
    ).decode("ascii")
    full_name = email.split("@", 1)[0][:120]
    try:
        with closing(psycopg2.connect(DATABASE_URL)) as connection:
            with connection:
                with connection.cursor(cursor_factory=RealDictCursor) as cursor:
                    cursor.execute(
                        """
                        INSERT INTO users (full_name, email, password_hash)
                        VALUES (%s, %s, %s)
                        ON CONFLICT (email)
                        DO UPDATE SET password_hash = EXCLUDED.password_hash
                        RETURNING id, email
                        """,
                        (full_name, email, password_hash),
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
        print(f"Compte prêt : {user['email']}")
    except psycopg2.Error as error:
        raise SystemExit(f"Échec de l’accès à PostgreSQL : {error}") from error


if __name__ == "__main__":
    main()
