#!/bin/sh

# Жестко заданный таймаут ожидания завершения Chrome (в секундах)
TIMEOUT=10

echo "Проверка, запущен ли Google Chrome..."
pids=$(pgrep chrome)

if [ -z "$pids" ]; then
    echo "Google Chrome не запущен. Перезагрузка системы..."
    sudo shutdown -r now
    exit 0
fi

echo "Найдены процессы Chrome (PID: $pids)"
echo "Попытка корректного завершения (SIGTERM)..."

# Отправляем сигнал SIGTERM (номер 15)
kill -15 $pids

# Ждём завершения, максимум TIMEOUT секунд
i=1
while [ $i -le $TIMEOUT ]; do
    sleep 1
    pids_left=$(pgrep chrome)
    if [ -z "$pids_left" ]; then
        echo "Google Chrome успешно завершён."
        echo "Перезагрузка системы..."
        sudo shutdown -r now
        exit 0
    fi
    echo "Ожидание завершения... ($i сек)"
    i=$((i+1))
done

echo "Chrome не завершён за $TIMEOUT секунд. Прерывание выключения."
exit 1
