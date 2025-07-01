# --- Estágio 1: Construir o Frontend ---
FROM node:18-alpine AS frontend

WORKDIR /app

# Copia os arquivos de manifesto do projeto
COPY package.json ./

# Instala as dependências
RUN npm install --legacy-peer-deps

# Copia todo o resto do código
COPY . .

# Executa o build do frontend
RUN npm run build


# --- Estágio 2: Imagem Final de Produção ---
FROM python:3.11-slim

# Define o diretório de trabalho principal
WORKDIR /app

# Instala o Git (necessário para a biblioteca GitPython ser importada)
RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*

# ==================================================================
#                       *** INÍCIO DA CORREÇÃO ***
# Copia TODOS os arquivos do projeto para o WORKDIR.
# Isso garante que CHANGELOG.md e package.json estejam na raiz de /app
COPY . /app
#                        *** FIM DA CORREÇÃO ***
# ==================================================================

# Instala as dependências do Python a partir do local correto
RUN pip install --no-cache-dir --upgrade gunicorn -r /app/backend/requirements.txt

# Copia os arquivos construídos do frontend para a pasta 'static' do backend
COPY --from=frontend /app/build /app/backend/open_webui/static

# Define a porta que a aplicação vai usar
EXPOSE 8080

# Comando para iniciar o servidor Gunicorn
# --chdir /app/backend: Diz ao Gunicorn para mudar para a pasta do backend antes de rodar.
# main:app: Diz ao Gunicorn para usar o arquivo 'main.py' e o objeto 'app'.
CMD ["gunicorn", "--workers", "4", "--bind", "0.0.0.0:8080", "--chdir", "/app/backend", "open_webui.main:app"]
