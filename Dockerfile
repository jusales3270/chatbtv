# Etapa 2 - Frontend Node
FROM node:18-alpine AS frontend

WORKDIR /app

COPY package*.json ./
COPY scripts ./scripts

RUN npm install --legacy-peer-deps

# Executa pyodide com fallback (não é obrigatório pro build continuar)
RUN node scripts/prepare-pyodide.js || echo "Aviso: prepare-pyodide.js falhou, prosseguindo..."

COPY . .

# REMOVE o redirecionamento de log para mostrar erro diretamente
RUN npm run build
