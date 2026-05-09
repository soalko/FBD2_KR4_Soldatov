# Используем официальный образ Node.js на Alpine Linux (лёгкий ~5MB)
FROM node:18-alpine

# Устанавливаем рабочую директорию внутри контейнера
WORKDIR /app

# Копируем package.json и package-lock.json (если есть)
COPY package*.json ./

# Устанавливаем зависимости
RUN npm install

# Копируем исходный код приложения
COPY server.js .

# Создаём пользователя non-root для безопасности
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001 && \
    chown -R nodejs:nodejs /app

# Переключаемся на non-root пользователя
USER nodejs

# Документируем порт, который будет использовать контейнер
EXPOSE 3000

# Переменные окружения по умолчанию
ENV PORT=3000
ENV SERVER_ID=default
ENV SERVER_COLOR=#cccccc

# Команда запуска приложения
CMD ["node", "server.js"]