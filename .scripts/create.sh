#!/bin/bash


CONTAINER=
PROXY=
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/../"
PROFILES_ROOT=$SCRIPT_DIR/.data

main() {
    echo "Введите имя контейнера"
    read CONTAINER

    if [[ "${CONTAINER}" =~ [^a-zA-Z0-9_-] ]]; then
        echo "Невалидный формат. Можно только буквы, цифры, и символы -_"
        return 1
    fi

    echo "А теперь проксю. В виде: socks5://host:port или host:port или оставьте пустым если прокси не требуется"
    read PROXY

    echo ""
    echo "Имя - $CONTAINER"
    echo "Прокси - $PROXY"
    echo ""
    echo "Все ОК, продолжаем? Валидный ответ только 'yes'"
}

doit() {
    mkdir -p $PROFILES_ROOT
    echo $CONTAINER $PROXY >> $SCRIPT_DIR/proxies.txt
    cat > $SCRIPT_DIR/$CONTAINER.desktop <<EOF
[Desktop Entry]
Name=Run $CONTAINER
Icon=network-wired
Exec=$SCRIPT_DIR/.scripts/run.sh $CONTAINER
Type=Application
Terminal=false
EOF
    chmod +x $SCRIPT_DIR/$CONTAINER.desktop
}

while true; do
    main && read RESP

    if [ "$RESP" == "yes" ]; then
        doit
        echo "Щикарно! Всё получилось, закругляемся через 3 секунды"
        sleep 3
        exit 0
    else
        echo "Окей, пробуем еще раз"
        echo ""
    fi
done
