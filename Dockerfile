# --- Estágio 1: Construir o Frontend SvelteKit ---
FROM node:18-alpine AS frontend

WORKDIR /app

COPY package*.json ./
RUN npm install --legacy-peer-deps

COPY . .

# Constrói o frontend com mais memória
RUN node --max-old-space-size=4096 node_modules/vite/bin/vite.js build


# --- Estágio 2: Imagem Final de Produção ---
FROM python:3.11-slim

WORKDIR /app

# Não precisamos mais instalar o Git aqui, a aplicação não precisa mais dele.

# Copia e instala as dependências Python
COPY ./backend/requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir --upgrade gunicorn -r /app/requirements.txt

# Copia o código do backend. Simples e direto.
COPY ./backend /app

# Copia os arquivos construídos do frontend para a pasta 'static' do backend
COPY --from=frontend /app/build /app/static

# Define a porta que a aplicação vai usar
EXPOSE 8080

# Comando para iniciar o servidor Gunicorn
CMD ["gunicorn", "--workers", "4", "--bind", "0.0.0.0:8080", "main:app"]:app"]
