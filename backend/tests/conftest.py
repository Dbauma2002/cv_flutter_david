import pytest

from backend.app import create_app


@pytest.fixture
def client():
    app = create_app(
        {
            "TESTING": True,
            "DATABASE_URL": "postgresql://unused:test@localhost/unused",
            "SECRET_KEY": "test-secret-key-with-at-least-32-characters",
            "TOKEN_EXPIRATION_HOURS": 24,
        }
    )
    return app.test_client()
