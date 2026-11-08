FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Install dependencies first so this layer is cached until requirements change
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Run as a non-root user
RUN useradd --create-home appuser

# --chown gives appuser ownership, so the app is readable regardless of the
# file permissions on the host machine
COPY --chown=appuser:appuser app.py .
COPY --chown=appuser:appuser templates ./templates

USER appuser

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=3s --start-period=20s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/health')" || exit 1

# --preload: init_db() runs once in the master before workers fork
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "--preload", "app:app"]