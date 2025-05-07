#!/bin/bash

# path=$(lsblk -o +SERIAL | grep 20121112761000000 | head -c 3)
# echo $path
# path=/dev/$var
# echo $path
# sudo dd if=/dev/$path of=~/projects/tzmoi-viewer/.tmp/rpi-`date --iso`.img status=progress

#!/bin/bash

#!/bin/bash

# Определяем путь к устройству на основе серийного номера
path=$(lsblk -o NAME,SERIAL | grep '20121112761000000' | awk '{print $1}')

# Проверяем, найден ли путь
if [ -n "$path" ]; then
  echo "Найдено устройство: /dev/$path"

  # Проверка прав на каталог
  echo "Проверка прав на каталог $HOME/projects/tzmoi-viewer/.tmp"
  ls -ld $HOME/projects/tzmoi-viewer/.tmp

  # Создаем каталог, если его нет
  mkdir -p $HOME/projects/tzmoi-viewer/.tmp

  # Проверяем наличие прав на запись в каталог
  if [ -w $HOME/projects/tzmoi-viewer/.tmp ]; then
    echo "Права на запись в каталог есть."
  else
    echo "Нет прав на запись в каталог."
    exit 1
  fi

  # Выполнение dd
  sudo dd if=/dev/$path of=$HOME/projects/tzmoi-viewer/.tmp/rpi-$(date --iso).img bs=4M status=progress
else
  echo "Устройство с серийным номером 20121112761000000 не найдено"
  exit 1
fi
