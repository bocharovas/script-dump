#!/bin/sh

# Жестко заданный таймаут ожидания завершения Chrome (в секундах)
TIMEOUT=10

echo "Проверка, запущен ли Google Chrome..."
pids=$(pgrep chrome)

if [ -z "$pids" ]; then
    echo "Google Chrome не запущен. reboot..."
    sudo shutdown -h now
    exit 0
fi

echo "Найдены процессы Chrome (PID: $pids)"
echo "Попытка корректного завершения (SIGTERM)..."

# Отправляем сигнал SIGTERM
kill -15 $pids

i=1

# Ждём завершения, максимум TIMEOUT секунд
while [ $i -le $TIMEOUT ]; do
    sleep 1
    pids_left=$(pgrep chrome)
    if [ -z "$pids_left" ]; then
        echo "Google Chrome успешно завершён."
        echo "reboot..."
        sudo shutdown -h now
        exit 0
    fi
    echo "Ожидание завершения... ($i сек)"
    i=$((i+1))
done
echo "Chrome не завершён за $TIMEOUT секунд. Прерывание выключения."
exit 1
