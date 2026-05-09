const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;
const SERVER_ID = process.env.SERVER_ID || 'unknown';
const SERVER_COLOR = process.env.SERVER_COLOR || '#cccccc';

// Middleware для логирования
app.use((req, res, next) => {
    console.log(`[${SERVER_ID}] ${req.method} ${req.url} - ${new Date().toISOString()}`);
    next();
});

// Эндпоинт для проверки балансировки
app.get('/', (req, res) => {
    res.json({
        message: 'Response from backend server',
        serverId: SERVER_ID,
        port: PORT,
        color: SERVER_COLOR,
        timestamp: new Date().toISOString(),
        requestId: Math.random().toString(36).substring(7)
    });
});

// Health check эндпоинт для Nginx
app.get('/health', (req, res) => {
    res.status(200).json({
        status: 'healthy',
        serverId: SERVER_ID,
        uptime: process.uptime()
    });
});

// Эндпоинт для сброса (тестирование отказа)
app.get('/reset', (req, res) => {
    res.json({ message: 'Reset endpoint', serverId: SERVER_ID });
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`[${SERVER_ID}] Server started on port ${PORT}`);
    console.log(`[${SERVER_ID}] Health check: http://0.0.0.0:${PORT}/health`);
});