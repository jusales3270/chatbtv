# Etapa 2 - Frontend Node
FROM node:18-alpine AS frontend

WORKDIR /app

COPY package*.json ./
COPY scripts ./scripts

RUN npm install --legacy-peer-deps

# Executa pyodide para preparar os pacotes
RUN node scripts/prepare-pyodide.js

COPY . .

# Constrói a aplicação SvelteKit para produção
RUN npm run build

# Expõe a porta que a aplicação vai usar
EXPOSE 3000

# Comando para iniciar a aplicação quando o container rodar
CMD ["node", "build/index.js"]
