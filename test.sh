#!/bin/bash

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   Load Balancing Test Suite${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Функция для тестирования балансировки
test_balancing() {
    echo -e "${YELLOW}Тест 1: Балансировка нагрузки (10 запросов)${NC}"
    echo "----------------------------------------"

    for i in {1..10}; do
        response=$(curl -s http://localhost/ | jq -r '.serverId')
        echo -e "Запрос $i: ${GREEN}$response${NC}"
        sleep 0.5
    done
    echo ""
}

# Функция для проверки отказоустойчивости
test_fault_tolerance() {
    echo -e "${YELLOW}Тест 2: Отказоустойчивость${NC}"
    echo "----------------------------------------"

    echo -e "Текущие контейнеры:"
    docker ps --format "table {{.Names}}\t{{.Status}}" | grep -E "backend|nginx"
    echo ""

    echo -e "${RED}Останавливаем backend1...${NC}"
    docker stop backend1

    echo -e "Ждём 5 секунд для обнаружения отказа..."
    sleep 5

    echo -e "\nОтправляем запросы после отказа:"
    for i in {1..5}; do
        response=$(curl -s http://localhost/ | jq -r '.serverId')
        echo -e "Запрос $i: ${GREEN}$response${NC}"
        sleep 0.5
    done

    echo -e "\n${GREEN}Запускаем backend1...${NC}"
    docker start backend1

    echo -e "Ждём восстановления..."
    sleep 5

    echo -e "\nПроверка после восстановления:"
    for i in {1..3}; do
        response=$(curl -s http://localhost/ | jq -r '.serverId')
        echo -e "Запрос $i: ${GREEN}$response${NC}"
        sleep 0.5
    done
    echo ""
}

# Функция для проверки резервного сервера
test_backup() {
    echo -e "${YELLOW}Тест 3: Резервный сервер (backup)${NC}"
    echo "----------------------------------------"

    echo -e "${RED}Останавливаем backend1 и backend2...${NC}"
    docker stop backend1 backend2

    echo -e "Ждём 5 секунд..."
    sleep 5

    echo -e "\nЗапросы должны идти на резервный сервер (backend-3-backup):"
    for i in {1..3}; do
        response=$(curl -s http://localhost/ | jq -r '.serverId')
        echo -e "Запрос $i: ${GREEN}$response${NC}"
        sleep 0.5
    done

    echo -e "\n${GREEN}Запускаем все серверы...${NC}"
    docker start backend1 backend2
    echo ""
}

# Функция для проверки health check
test_health() {
    echo -e "${YELLOW}Тест 4: Health Check${NC}"
    echo "----------------------------------------"

    echo "Проверка health каждого backend:"
    for backend in backend1 backend2 backend3; do
        echo -n "$backend: "
        docker exec $backend node -e "require('http').get('http://localhost:3000/health', (r) => {console.log(r.statusCode === 200 ? '✓ OK' : '✗ FAIL')})" 2>/dev/null || echo "Error"
    done

    echo -e "\nNginx status:"
    curl -s http://localhost/nginx-status | head -5
    echo ""
}

# Функция для отображения статистики
show_stats() {
    echo -e "${YELLOW}Статистика запросов:${NC}"
    echo "----------------------------------------"
    echo "Распределение 20 запросов по бэкендам:"
    for i in {1..20}; do
        curl -s http://localhost/ | jq -r .serverId
    done | sort | uniq -c
}

# Основное выполнение
test_balancing
test_fault_tolerance
test_backup
test_health
show_stats

echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}Тестирование завершено!${NC}"
echo -e "${BLUE}========================================${NC}"