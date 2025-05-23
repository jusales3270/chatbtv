FROM python:3.10-slim as backend

WORKDIR /app/backend
COPY backend/requirements.txt .
RUN pip install -r requirements.txt

COPY backend .
ENV WEBUI_NAME=ChatBTV

FROM node:18-alpine as frontend
WORKDIR /app
COPY package*.json ./
RUN npm install --legacy-peer-deps
COPY . .
RUN npm run build

FROM python:3.10-slim
WORKDIR /app
COPY --from=backend /app/backend /app/backend
COPY --from=frontend /app/build /app/backend/open_webui/static
COPY static /app/backend/open_webui/static

ENV NODE_ENV=production
ENV WEBUI_NAME=ChatBTV
ENV DATA_DIR=/app/backend/data
ENV FRONTEND_BUILD_DIR=/app/backend/open_webui/static

EXPOSE 8080
CMD ["python", "-m", "uvicorn", "open_webui.main:app", "--host", "0.0.0.0", "--port", "8080"]

# Additional commands for Docker Compose
RUN docker compose down
RUN docker compose build --no-cache
RUN docker compose up -d

