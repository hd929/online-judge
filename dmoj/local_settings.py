
# dmoj/local_settings.py
import os
import dj_database_url
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent

DEBUG = os.getenv("DJANGO_DEBUG", "False") == "True"
SECRET_KEY = os.environ["DJANGO_SECRET_KEY"]
ALLOWED_HOSTS = os.getenv("ALLOWED_HOSTS", "*").split(",")
USE_X_FORWARDED_HOST = True
CSRF_TRUSTED_ORIGINS = [o for o in os.getenv("CSRF_TRUSTED_ORIGINS", "").split(",") if o]

# ---- Database (Railway sẽ cấp DATABASE_URL) ----
DATABASES = {
    "default": dj_database_url.config(default=os.environ["DATABASE_URL"], conn_max_age=600)
}

# ---- Static files (bắt buộc để compressor không lỗi) ----
STATIC_URL = "/static/"
STATIC_ROOT = os.path.join(BASE_DIR, "static")  # đường dẫn build static khi deploy

# ---- django-compressor ----
COMPRESS_ROOT = STATIC_ROOT
COMPRESS_ENABLED = True         # hoặc đặt False nếu muốn tắt nén để đơn giản
COMPRESS_OFFLINE = True         # nén trước khi chạy (an toàn khi không có nginx)

# (tuỳ chọn) Media – nếu chưa dùng S3 thì để local
MEDIA_URL = "/media/"
MEDIA_ROOT = os.path.join(BASE_DIR, "media")

