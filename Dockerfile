# --- Estágio 1: Construir o Frontend SvelteKit ---
FROM node:18-alpine AS frontend

# Coolify injeta essas variáveis. GITHUB_TOKEN é o mais importante para repositórios privados.
ARG GIT_REPOSITORY
ARG GIT_COMMIT_SHA
ARG GITHUB_TOKEN

WORKDIR /app

# Instala o Git
RUN apk add --no-cache git

# Configura o Git para usar o token de acesso para autenticação HTTPS
# Isso permite clonar repositórios privados de forma segura.
RUN git config --global url."https://x-access-token:${GITHUB_TOKEN}@github.com/".insteadOf "https://github.com/"

# Clona o repositório. Usamos a variável GIT_REPOSITORY que geralmente tem o formato "usuario/repo".
RUN git clone --depth 1 "https://github.com/${GIT_REPOSITORY}.git" .

# Faz o fetch de todo o histórico (necessário para o checkout de commits específicos) e faz o checkout
RUN git fetch --unshallow || true
RUN git checkout ${GIT_COMMIT_SHA}

RUN npm install --legacy-peer-deps

# Constrói o frontend com mais memória
RUN node --max-old-space-size=4096 node_modules/vite/bin/vite.js build


# --- Estágio 2: Imagem Final de Produção ---
FROM python:3.11-slim

# Coolify injeta essas variáveis novamente.
ARG GIT_REPOSITORY
ARG GIT_COMMIT_SHA
ARG GITHUB_TOKEN

WORKDIR /app

# Instala o Git
RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*

# Configura o Git para usar o token de acesso para autenticação HTTPS
RUN git config --global url."https://x-access-token:${GITHUB_TOKEN}@github.com/".insteadOf "https://github.com/"

# Clona o repositório.
RUN git clone --depth 1 "https://github.com/${GIT_REPOSITORY}.git" .

# Faz o fetch de todo o histórico e faz o checkout
RUN git fetch --unshallow || true
RUN git checkout ${GIT_COMMIT_SHA}

# Instala as dependências Python a partir do arquivo que foi clonado
RUN pip install --no-cache-dir --upgrade gunicorn -r /app/backend/requirements.txt

# Copia os arquivos construídos do frontend para a pasta 'static' do backend
COPY --from=frontend /app/build /app/static

# Define a porta que a aplicação vai usar
EXPOSE 8080

# Comando para iniciar o servidor Gunicorn
CMD ["gunicorn", "--workers", "4", "--bind", "0.0.0.0:8080", "--chdir", "backend", "main:app"]
