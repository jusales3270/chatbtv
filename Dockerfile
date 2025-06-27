# --- Estágio 1: Construir o Backend Python ---
FROM python:3.11-slim AS backend

WORKDIR /app

# Instala dependências do sistema
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copia e instala as dependências Python
COPY ./backend/requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt

# Copia o código do backend
COPY ./backend /app


# --- Estágio 2: Construir o Frontend SvelteKit ---
FROM node:18-alpine AS frontend

WORKDIR /app

COPY package*.json ./
RUN npm install --legacy-peer-deps

COPY . .

# Constrói o frontend com mais memória
RUN node --max-old-space-size=4096 node_modules/vite/bin/vite.js build


# --- Estágio 3: Imagem Final de Produção ---
FROM python:3.11-slim

WORKDIR /app

# Copia os executáveis (como gunicorn) do estágio 'backend' <-- LINHA CRÍTICA ADICIONADA
COPY --from=backend /usr/local/bin/ /usr/local/bin/

# Copia as dependências Python do estágio 'backend'
COPY --from=backend /usr/local/lib/python3.11/site-packages/ /usr/local/lib/python3.11/site-packages/

# Copia o código do backend do estágio 'backend'
COPY --from=backend /app /app

# Copia os arquivos construídos do frontend para a pasta 'static' do backend
COPY --from=frontend /app/build /app/static

# Define a porta que a aplicação vai usar
EXPOSE 8080

# Comando para iniciar o servidor Python (Gunicorn)
CMD ["gunicorn", "-c", "gunicorn_config.py", "main:app"]r Python (Gunicorn)
CMD ["gunicorn", "-c", "gunicorn_config.py", "main:app"]
