# Etapa 1 - Backend Python
FROM python:3.10-slim AS backend

WORKDIR /app/backend
COPY backend/requirements.txt .
RUN pip install -r requirements.txt

COPY backend .

# Etapa 2 - Frontend Node
FROM node:18-alpine AS frontend

WORKDIR /app
COPY package*.json ./
COPY scripts ./scripts
RUN npm install --legacy-peer-deps
RUN node scripts/prepare-pyodide.js
COPY . .
RUN npm run build

# Etapa Final - App completo
FROM python:3.10-slim

WORKDIR /app

# Copia backend
COPY --from=backend /app/backend /app/backend

# Copia frontend buildado
COPY --from=frontend /app/build /app/backend/open_webui/static

# Static extra (opcional)
COPY static /app/backend/open_webui/static

ENV NODE_ENV=production
ENV WEBUI_NAME=ChatBTV
ENV DATA_DIR=/app/backend/data
ENV FRONTEND_BUILD_DIR=/app/backend/open_webui/static

EXPOSE 8080

CMD ["python", "-m", "uvicorn", "open_webui.main:app", "--host", "0.0.0.0", "--port", "8080"]
