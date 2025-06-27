# Etapa 1 - Backend Python
FROM python:3.10-slim AS backend

WORKDIR /app/backend
COPY backend/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY backend ./

# Etapa 2 - Frontend Node
FROM node:18-alpine AS frontend

WORKDIR /app

# Instala dependências primeiro (cache otimizado)
COPY package*.json ./
COPY scripts ./scripts

RUN npm install --legacy-peer-deps

# Executa pyodide com fallback caso falhe
RUN node scripts/prepare-pyodide.js || echo "Aviso: prepare-pyodide.js falhou, prosseguindo..."

COPY . .

# Garante que diretório de build existe e logue erro em caso de falha
RUN mkdir -p /app/build && \
    npm run build > /app/build.log 2>&1 || (echo "==== ERRO NO BUILD DO FRONTEND ====" && cat /app/build.log && exit 1)

# Etapa Final - App completo
FROM python:3.10-slim

WORKDIR /app

# Copia backend completo
COPY --from=backend /app/backend /app/backend

# Copia frontend buildado
COPY --from=frontend /app/build /app/backend/open_webui/static

# Copia static extra (opcional)
COPY static /app/backend/open_webui/static

# Configurações de ambiente
ENV NODE_ENV=production
ENV WEBUI_NAME=ChatBTV
ENV DATA_DIR=/app/backend/data
ENV FRONTEND_BUILD_DIR=/app/backend/open_webui/static

EXPOSE 8080

CMD ["python", "-m", "uvicorn", "open_webui.main:app", "--host", "0.0.0.0", "--port", "8080"]
