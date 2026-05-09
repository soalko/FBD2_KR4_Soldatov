# Просмотр запущенных контейнеров
```docker ps```

# Просмотр логов
```docker compose logs -f```

# Остановка всех контейнеров
```docker compose down```

# Полная очистка (с удалением томов)
```docker compose down -v```

# Перезапуск конкретного сервиса
```docker compose restart nginx```

# Масштабирование (запуск 5 экземпляров)
```docker compose up -d --scale backend1=5```