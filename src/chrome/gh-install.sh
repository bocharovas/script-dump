#!/bin/bash
# Установка Google Chrome на Debian 12 (Bookworm)

set -e

echo "=== Обновление системы ==="
sudo apt update

echo "=== Установка зависимостей ==="
sudo apt install -y wget gnupg apt-transport-https ca-certificates

echo "=== Добавление ключа Google ==="
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | \
  sudo gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg

echo "=== Добавление репозитория Chrome ==="
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] https://dl.google.com/linux/chrome/deb/ stable main" | \
  sudo tee /etc/apt/sources.list.d/google-chrome.list

echo "=== Обновление списка пакетов ==="
sudo apt update

echo "=== Установка Google Chrome ==="
sudo apt install -y google-chrome-stable

echo "=== Установка завершена! ==="
echo "Запуск браузера: google-chrome-stable"

