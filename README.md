# Домашнее задание к занятию 2 «Кластеризация и балансировка нагрузки»
## Автор: Кирилл Фролушкин

## Задание 1: Балансировка Round-robin на 4 уровне

### Реализация:
- Запущены 2 Python HTTP сервера на портах 8881 и 8882
- HAProxy настроен на порту 9000
- Используется алгоритм Round-robin

### Конфигурационный файл:
[configs/haproxy_task1.cfg](configs/haproxy_task1.cfg)

### Результаты тестирования:
\`\`\`
Request 1: Server 2 (8882)
Request 2: Server 1 (8881)  
Request 3: Server 2 (8882)
Request 4: Server 1 (8881)
Request 5: Server 2 (8882)
Request 6: Server 1 (8881)
\`\`\`
✅ Балансировка работает корректно

## Задание 2: Weighted Round Robin на 7 уровне

### Реализация:
- Запущены 3 Python HTTP сервера:
  - Сервер 1: порт 8883, вес 2
  - Сервер 2: порт 8884, вес 3  
  - Сервер 3: порт 8885, вес 4
- Default сервер: порт 8080
- HAProxy настроен на порту 9001
- Балансировка только для домена \`example.local\`

### Конфигурационный файл:
[configs/haproxy_task2.cfg](configs/haproxy_task2.cfg)

### Результаты тестирования:
**С доменом example.local (weighted balancing):**
\`\`\`
Request 1: Weighted Server 1 (вес 2)
Request 2: Weighted Server 2 (вес 3)
Request 3: Weighted Server 3 (вес 4)
\`\`\`

**Без домена example.local (default server):**
\`\`\`
Request 1: Default Server
Request 2: Default Server
\`\`\`

✅ Domain-based routing работает корректно
✅ Weighted balancing работает согласно заданным весам

## Файлы проекта:
- \`configs/haproxy_task1.cfg\` - конфигурация для задания 1
- \`configs/haproxy_task2.cfg\` - конфигурация для задания 2
- \`scripts/setup.sh\` - скрипт установки и настройки
- \`demo-balancing.sh\` - демонстрационный скрипт
- \`docs/verification.md\` - документация по проверке

## Быстрый запуск:
\`\`\`bash
# Установить HAProxy
sudo apt install haproxy

# Запустить серверы
python3 -m http.server 8881 &
python3 -m http.server 8882 &
python3 -m http.server 8883 &
python3 -m http.server 8884 &
python3 -m http.server 8885 &
python3 -m http.server 8080 &

# Применить конфигурации
sudo haproxy -f configs/haproxy_task1.cfg &
sudo haproxy -f configs/haproxy_task2.cfg &
\`\`\`
