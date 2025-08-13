# ---- Base image ----
FROM python:3.11-slim

# ---- System deps ----
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential libpq-dev pkg-config gettext ca-certificates git \
 && rm -rf /var/lib/apt/lists/*

# ---- Workdir ----
WORKDIR /app

# ---- Copy requirements first for caching ----
COPY requirements.txt /app/

# ---- Python deps ----
RUN python -m pip install -U pip wheel \
 && pip install --no-cache-dir -r requirements.txt \
 && pip install pymysql gunicorn dj-database-url

# ---- Copy full code ----
COPY . /app/

# ---- Build static files ----
# Nếu COMPRESS_ENABLED=False thì compress sẽ bị bỏ qua an toàn
RUN python manage.py collectstatic --noinput \
 && python manage.py compress --force || true

# ---- Env ----
ENV PYTHONUNBUFFERED=1
ENV PORT=8000

# ---- Start ----
CMD gunicorn dmoj.wsgi:application --bind 0.0.0.0:${PORT} --workers 3

