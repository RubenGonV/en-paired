# ---------- STAGE 1: build ----------
FROM python:3.11-slim AS build

WORKDIR /app

# Copiamos solo requirements primero para aprovechar la caché
COPY requirements.txt .

# Instalamos dependencias en un entorno temporal
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copiamos el código fuente
COPY . .

# ---------- STAGE 2: runtime ----------
FROM python:3.11-slim

# Crea un usuario no root por seguridad
RUN useradd -m appuser

WORKDIR /app

# Copiamos dependencias ya instaladas desde el build stage
COPY --from=build /usr/local/lib/python3.11 /usr/local/lib/python3.11
COPY --from=build /usr/local/bin /usr/local/bin
COPY --from=build /app /app

# Establecemos variables de entorno
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

USER appuser

# Puerto de la app
EXPOSE 8000

# Comando de inicio (usa uvicorn)
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
