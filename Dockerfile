# --- Estágio 1: Construir o Frontend ---
FROM node:18-alpine AS frontend

WORKDIR /app

COPY package.json ./
RUN npm install --legacy-peer-deps
COPY . .
RUN npm run build


# --- Estágio 2: Imagem Final de Produção ---
FROM python:3.11-slim

WORKDIR /app

# Instala o Git, que é necessário para a biblioteca GitPython ser importada
RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*

# Copia as dependências do backend
COPY ./backend/requirements.txt /app/requirements.txt

# Instala as dependências do Python
RUN pip install --no-cache-dir --upgrade gunicorn -r /app/requirements.txt

# Copia o código do backend
COPY ./backend /app

# Copia os arquivos construídos do frontend para a pasta 'static' do backend
COPY --from=frontend /app/build /app/open_webui/static

# Define a porta que a aplicação vai usar
EXPOSE 8080

# ==================================================================
#                       *** INÍCIO DA CORREÇÃO ***
# Comando para iniciar o servidor Gunicorn.
# --chdir /app: Garante que o Gunicorn rode a partir do diretório /app.
# open_webui.main:app: Diz ao Gunicorn para procurar o arquivo 'main.py'
#                    dentro do pacote 'open_webui' e usar o objeto 'app'.
CMD ["gunicorn", "--workers", "4", "--bind", "0.0.0.0:8080", "--chdir", "/app", "open_webui.main:app"]
#                        *** FIM DA CORREÇÃO ***
# ==================================================================
