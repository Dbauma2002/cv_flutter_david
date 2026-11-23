import os
from pathlib import Path

from dotenv import load_dotenv

load_dotenv(Path(__file__).with_name(".env"))

DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql://postgres.xrzcygzzhklygdmydolh:Davidsecure2026Goma85@aws-0-eu-west-2.pooler.supabase.com:5432/postgres",
).replace("postgresql+psycopg://", "postgresql://", 1)
SECRET_KEY = os.getenv("SECRET_KEY") or os.getenv("JWT_SECRET", "")
TOKEN_EXPIRATION_HOURS = 24
