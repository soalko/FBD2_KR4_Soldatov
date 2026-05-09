# Фронтенд и бэкенд разработка

## Контрольная работа № 4

> Выполнил: Солдатов Александр, ЭФБО-04-24
---

## Запуск docker сервера

```bash
docker compose up --build
```

Проверка статуса бэкендов

```bash
curl http://localhost/health
```

Статус Nginx

```bash
curl http://localhost/nginx-status
```

Логи Nginx с информацией о балансировке

```bash
docker compose logs nginx | grep "upstream"
```

Логи конкретного бэкенда

```bash
docker compose logs backend1
```

Проверка балансировки

```bash
for i in {1..10}; do curl -s http://localhost/ | jq -r .serverId; done
```

Запуск комплексного нагрузочного теста

```bash
chmod +x test.sh
./test.sh
```