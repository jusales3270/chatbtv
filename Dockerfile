# Estágio Único: Construir e Rodar a Aplicação Node.js (SvelteKit)
FROM node:18-alpine

WORKDIR /app

# Copia os arquivos de dependência
COPY package*.json ./

# Instala as dependências
RUN npm install --legacy-peer-deps

# Copia todo o resto do código fonte
COPY . .

# Constrói a aplicação SvelteKit para produção com mais memória
RUN node --max-old-space-size=4096 node_modules/vite/bin/vite.js build

# Expõe a porta padrão do adapter-node
EXPOSE 3000

# Comando para iniciar o servidor Node.js que foi gerado pelo build
CMD ["node", "build/index.js"]
