# --- Estágio 1: Construir o Frontend SvelteKit ---
FROM node:18-alpine AS frontend

# Coolify injeta essas variáveis, que podemos usar para clonar o repositório
ARG GIT_REPOSITORY_URL
ARG GIT_COMMIT_SHA

WORKDIR /app

# Instala o Git para poder clonar o repositório
RUN apk add --no-cache git

# Clona o repositório e faz checkout no commit exato do deploy
RUN git clone ${GIT_REPOSITORY_URL} . && git checkout ${GIT_COMMIT_SHA}

RUN npm install --legacy-peer-deps

# Constrói o frontend com mais memória
RUN node --max-old-space-size=4096 node_modules/vite/bin/vite.js build


# --- Estágio 2: Imagem Final de Produção ---
FROM python:3.11-slim

# Coolify injeta essas variáveis novamente para o segundo estágio
ARG GIT_REPOSITORY_URL
ARG GIT_COMMIT_SHA

WORKDIR /app

# Instala o Git, que é necessário para clonar e para a sua aplicação
RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*

# Clona o repositório e faz checkout no commit exato do deploy
# Agora a pasta .git EXISTIRÁ dentro do contêiner para sua aplicação usar
RUN git clone ${GIT_REPOSITORY_URL} . && git checkout ${GIT_COMMIT_SHA}

# Instala as dependências Python a partir do arquivo que foi clonado
RUN pip install --no-cache-dir --upgrade gunicorn -r /app/backend/requirements.txt

# Copia os arquivos construídos do frontend para a pasta 'static' do backend
COPY --from=frontend /app/build /app/static

# Define a porta que a aplicação vai usar
EXPOSE 8080

# Comando para iniciar o servidor Gunicorn
# Usamos --chdir para dizer ao Gunicorn para rodar a partir da pasta 'backend'
CMD ["gunicorn", "--workers", "4", "--bind", "0.0.0.0:8080", "--chdir", "backend", "main:app"]
