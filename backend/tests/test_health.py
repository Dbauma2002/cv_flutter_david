from contextlib import contextmanager
from unittest.mock import MagicMock


def test_health_checks_database(client, monkeypatch):
    cursor = MagicMock()
    cursor.__enter__.return_value = cursor
    connection = MagicMock()
    connection.cursor.return_value = cursor

    @contextmanager
    def fake_connection():
        yield connection

    monkeypatch.setattr("backend.app.db_connection", fake_connection)

    response = client.get("/api/health")

    assert response.status_code == 200
    assert response.json == {"status": "ok", "database": "connected"}
    cursor.execute.assert_called_once_with("SELECT 1")
