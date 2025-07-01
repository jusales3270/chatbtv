# --- Estágio 1: Construir o Frontend ---
FROM node:18-alpine AS frontend

WORKDIR /app

# Copia apenas os arquivos necessários para instalar as dependências
COPY package.json ./
COPY package-lock.json ./

# Instala as dependências
RUN npm install --legacy-peer-deps

# Copia todo o resto do código
COPY . .

# Executa o build do frontend
# O projeto Open WebUI espera que o resultado esteja em './build'
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
# O build do npm deve criar a pasta 'build' corretamente
COPY --from=frontend /app/build /app/static

# Define a porta que a aplicação vai usar
EXPOSE 8080

# Comando para iniciar o servidor Gunicorn
CMD ["gunicorn", "--workers", "4", "--bind", "0.0.0.0:8080", "main:app"]
