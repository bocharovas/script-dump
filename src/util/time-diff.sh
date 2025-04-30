#!/bin/bash

# Запросим у пользователя ввод времени
echo "Введите первое время (hh:mm:ss):"
read start_time

echo "Введите второе время (hh:mm:ss):"
read end_time

# Преобразуем оба времени в количество секунд с начала суток
start_sec=$(echo $start_time | awk -F: '{print $1*3600 + $2*60 + $3}')
end_sec=$(echo $end_time | awk -F: '{print $1*3600 + $2*60 + $3}')

# Вычисляем разницу в секундах
diff=$((end_sec - start_sec))

# Если разница отрицательная, прибавляем 24 часа (86400 секунд)
if [ $diff -lt 0 ]; then
    diff=$((diff + 86400))
fi

# Получаем количество часов, минут и секунд
hours=$((diff / 3600))
minutes=$(( (diff % 3600) / 60 ))
seconds=$((diff % 60))

# Выводим разницу в формате hh:mm:ss
printf "Разница: %02d:%02d:%02d\n" $hours $minutes $seconds
