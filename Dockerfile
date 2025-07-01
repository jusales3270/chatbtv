# --- Estágio 1: Construir o Frontend ---
FROM node:18-alpine AS frontend

WORKDIR /app

# Copia apenas o package.json para instalar as dependências
COPY package.json ./

# Instala as dependências
RUN npm install --legacy-peer-deps

# Copia todo o resto do código
COPY . .

# Executa o build do frontend
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

# ==================================================================
#                       *** INÍCIO DA CORREÇÃO ***
# Copia APENAS o conteúdo da pasta 'backend' para o diretório de trabalho.
# Isso garante que nenhum arquivo da raiz (como um main.py perdido)
# interfira com a aplicação.
COPY ./backend /app
#                        *** FIM DA CORREÇÃO ***
# ==================================================================

# Copia os arquivos construídos do frontend para a pasta 'static' do backend
COPY --from=frontend /app/build /app/static

# Define a porta que a aplicação vai usar
EXPOSE 8080

# Comando para iniciar o servidor Gunicorn
# O Gunicorn vai procurar por 'main:app' dentro do WORKDIR, que agora é o conteúdo do backend.
CMD ["gunicorn", "--workers", "4", "--bind", "0.0.0.0:8080", "main:app"]
