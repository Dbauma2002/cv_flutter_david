from contextlib import contextmanager
from unittest.mock import MagicMock

import bcrypt
import jwt
from pwdlib import PasswordHash


def _mock_database(monkeypatch, user=None, members=None):
    cursor = MagicMock()
    cursor.__enter__.return_value = cursor
    cursor.fetchone.return_value = user
    cursor.fetchall.return_value = members or []
    connection = MagicMock()
    connection.cursor.return_value = cursor

    @contextmanager
    def fake_connection():
        yield connection

    monkeypatch.setattr("backend.app.db_connection", fake_connection)
    return cursor


def _token(client, user_id="f44ad4de-9a9f-45ef-96d2-48f2fd6aa845"):
    return jwt.encode(
        {"sub": str(user_id)},
        client.application.config["SECRET_KEY"],
        algorithm="HS256",
    )


def test_registration_hashes_password_and_seeds_family_templates(client, monkeypatch):
    cursor = _mock_database(
        monkeypatch,
        user={
            "id": "ef83ff71-3c4b-4aa3-8ef2-cc7b1d011925",
            "full_name": "new",
            "email": "new@example.com",
        },
    )

    response = client.post(
        "/api/auth/register",
        json={"email": "New@example.com", "password": "mot-de-passe-test"},
    )

    assert response.status_code == 201
    user_id = "ef83ff71-3c4b-4aa3-8ef2-cc7b1d011925"
    assert response.json == {
        "user": {
            "id": user_id,
            "full_name": "new",
            "email": "new@example.com",
        }
    }
    insert_sql, insert_values = cursor.execute.call_args_list[0].args
    assert "INSERT INTO users" in insert_sql
    assert bcrypt.checkpw(
        b"mot-de-passe-test",
        insert_values[2].encode("ascii"),
    )
    assert cursor.execute.call_args_list[1].args[1] == (user_id, user_id)
    assert cursor.execute.call_args_list[2].args[1] == (user_id, user_id)


def test_login_verifies_bcrypt_password_and_returns_jwt(client, monkeypatch):
    stored_hash = bcrypt.hashpw(
        b"mot-de-passe-test", bcrypt.gensalt()
    ).decode("ascii")
    cursor = _mock_database(
        monkeypatch,
        user={
            "id": "77305070-e31a-4b54-bd06-e82a4c938e04",
            "full_name": "David",
            "email": "david@example.com",
            "password_hash": stored_hash,
        },
    )

    response = client.post(
        "/api/auth/login",
        json={"email": "DAVID@example.com", "password": "mot-de-passe-test"},
    )

    assert response.status_code == 200
    user_id = "77305070-e31a-4b54-bd06-e82a4c938e04"
    assert response.json["user"] == {
        "id": user_id,
        "full_name": "David",
        "email": "david@example.com",
    }
    assert jwt.decode(
        response.json["token"],
        client.application.config["SECRET_KEY"],
        algorithms=["HS256"],
    )["sub"] == user_id
    cursor.execute.assert_called_once()


def test_login_rejects_wrong_password(client, monkeypatch):
    stored_hash = bcrypt.hashpw(
        b"mot-de-passe-test", bcrypt.gensalt()
    ).decode("ascii")
    _mock_database(
        monkeypatch,
        user={
            "id": "77305070-e31a-4b54-bd06-e82a4c938e04",
            "full_name": "David",
            "email": "david@example.com",
            "password_hash": stored_hash,
        },
    )

    response = client.post(
        "/api/auth/login",
        json={"email": "david@example.com", "password": "mauvais-mot-de-passe"},
    )

    assert response.status_code == 401


def test_login_upgrades_legacy_argon2_hash_to_bcrypt(client, monkeypatch):
    stored_hash = PasswordHash.recommended().hash("ancien-mot-de-passe")
    cursor = _mock_database(
        monkeypatch,
        user={
            "id": "fedcba98-7654-4321-8765-123456789abc",
            "full_name": "Legacy",
            "email": "legacy@example.com",
            "password_hash": stored_hash,
        },
    )

    response = client.post(
        "/api/auth/login",
        json={"email": "legacy@example.com", "password": "ancien-mot-de-passe"},
    )

    assert response.status_code == 200
    update_sql, update_values = cursor.execute.call_args_list[-1].args
    assert update_sql.startswith("UPDATE users SET password_hash")
    assert update_values[1] == "fedcba98-7654-4321-8765-123456789abc"
    assert update_values[0].startswith("$2b$")
    assert bcrypt.checkpw(
        b"ancien-mot-de-passe",
        update_values[0].encode("ascii"),
    )


def test_protected_family_routes_reject_missing_and_invalid_tokens(client):
    missing = client.get("/api/famille")
    invalid = client.get(
        "/api/famille",
        headers={"Authorization": "Bearer token-invalide"},
    )

    assert missing.status_code == 401
    assert invalid.status_code == 403


def test_family_list_is_scoped_to_the_authenticated_user(client, monkeypatch):
    member = {
        "id": "00000000-0000-4000-8000-000000000007",
        "nom": "Joseph Bauma",
        "lien": "Père",
        "profession": "Commerçant",
        "photo_url": "assets/images/pere.jpg",
    }
    _mock_database(monkeypatch, members=[member])

    response = client.get(
        "/api/famille",
        headers={"Authorization": f"Bearer {_token(client)}"},
    )

    assert response.status_code == 200
    assert response.json == [member]


def test_family_update_accepts_uuid_member_and_user_ids(client, monkeypatch):
    member_id = "00000000-0000-4000-8000-000000000007"
    user_id = "f44ad4de-9a9f-45ef-96d2-48f2fd6aa845"
    cursor = _mock_database(
        monkeypatch,
        user={
            "id": member_id,
            "nom": "Joseph Bauma",
            "lien": "Père",
            "profession": "Commerçant",
            "photo_url": None,
        },
    )

    response = client.put(
        f"/api/famille/{member_id}",
        headers={"Authorization": f"Bearer {_token(client, user_id)}"},
        json={
            "nom": "Joseph Bauma",
            "lien": "Père",
            "profession": "Entrepreneur",
            "photo_url": None,
        },
    )

    assert response.status_code == 200
    assert response.json["id"] == member_id
    assert cursor.execute.call_args.args[1][-2:] == (member_id, user_id)


def test_family_delete_accepts_uuid_member_id(client, monkeypatch):
    member_id = "00000000-0000-4000-8000-000000000007"
    user_id = "f44ad4de-9a9f-45ef-96d2-48f2fd6aa845"
    cursor = _mock_database(monkeypatch)
    cursor.rowcount = 1

    response = client.delete(
        f"/api/famille/{member_id}",
        headers={"Authorization": f"Bearer {_token(client, user_id)}"},
    )

    assert response.status_code == 204
    assert cursor.execute.call_args.args[1] == (member_id, user_id)


def test_registration_rejects_malformed_email_without_database_access(client):
    response = client.post(
        "/api/auth/register",
        json={"email": "adresse-invalide", "password": "mot-de-passe-test"},
    )

    assert response.status_code == 400
