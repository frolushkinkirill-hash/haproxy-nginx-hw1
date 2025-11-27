#!/bin/bash

echo "🎯 ДЕМОНСТРАЦИЯ БАЛАНСИРОВКИ HAProxy + Nginx"
echo "==========================================="
echo ""

# Проверка доступности служб
echo "1. 📊 ПРОВЕРКА СЛУЖБ:"
echo "   HAProxy: $(systemctl is-active haproxy 2>/dev/null || echo 'не найден')"
echo "   Nginx: $(systemctl is-active nginx 2>/dev/null || echo 'не найден')"
echo ""

# Проверка портов
echo "2. 🔍 ПРОВЕРКА ПОРТОВ:"
sudo netstat -tlnp | grep -E '(8088|8888|9999|888)' | while read line; do
    echo "   $line"
done
echo ""

# Тест балансировки
echo "3. 🎪 ТЕСТ БАЛАНСИРОВКИ ROUND ROBIN:"
echo "   (должно чередоваться Backend 1 и Backend 2)"
echo "   -----------------------------------------"
for i in {1..10}; do
    BACKEND=$(curl -s --max-time 2 http://localhost:8088 2>/dev/null | grep -o "Backend Server [12]" | head -1)
    if [ -n "$BACKEND" ]; then
        if [ "$BACKEND" = "Backend Server 1" ]; then
            echo "   🟦 Запрос $i → $BACKEND"
        else
            echo "   🟥 Запрос $i → $BACKEND"
        fi
    else
        echo "   ❌ Запрос $i → Нет ответа"
    fi
    sleep 0.3
done
echo ""

# Прямой доступ к бэкендам
echo "4. 🔧 ПРЯМОЙ ДОСТУП К БЭКЕНДАМ:"
BACKEND1=$(curl -s --max-time 2 http://localhost:8888 2>/dev/null | grep -o "Backend Server [12]" | head -1)
BACKEND2=$(curl -s --max-time 2 http://localhost:9999 2>/dev/null | grep -o "Backend Server [12]" | head -1)
echo "   Бэкенд 1 (8888): ${BACKEND1:-❌ Не доступен}"
echo "   Бэкенд 2 (9999): ${BACKEND2:-❌ Не доступен}"
echo ""

# Статистика HAProxy
echo "5. 📈 СТАТИСТИКА HAProxy:"
STATS=$(curl -s --max-time 2 http://localhost:888 2>/dev/null)
if [ -n "$STATS" ]; then
    echo "   ✅ Статистика доступна: http://localhost:888"
else
    echo "   ❌ Статистика не доступна"
fi

echo ""
echo "🎉 ДЕМОНСТРАЦИЯ ЗАВЕРШЕНА!"
