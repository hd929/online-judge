# Dockerfile
FROM python:3.11-slim

# system deps (psycopg2, gettext…)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential libpq-dev pkg-config gettext && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app

# python deps
RUN pip install -U pip wheel && \
    pip install -r requirements.txt && \
    pip install dj-database-url gunicorn && \
    pip install pymysql || true

# chạy collectstatic + (tuỳ) compress rồi khởi động
ENV PYTHONUNBUFFERED=1
CMD bash -lc "\
python manage.py collectstatic --noinput && \
python manage.py compress --force || true && \
gunicorn dmoj.wsgi:application --bind 0.0.0.0:${PORT:-8000} --workers 3"

