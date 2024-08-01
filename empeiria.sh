#!/bin/bash

# Функция для отображения логотипа
display_logo() {
  echo -e '\e[40m\e[32m'
  echo -e '███╗   ██╗ ██████╗ ██████╗ ███████╗██████╗ ██╗   ██╗███╗   ██╗███╗   ██╗███████╗██████╗ '
  echo -e '████╗  ██║██╔═══██╗██╔══██╗██╔════╝██╔══██╗██║   ██║████╗  ██║████╗  ██║██╔════╝██╔══██╗'
  echo -e '██╔██╗ ██║██║   ██║██║  ██║█████╗  ██████╔╝██║   ██║██╔██╗ ██║██╔██╗ ██║█████╗  ██████╔╝'
  echo -e '██║╚██╗██║██║   ██║██║  ██║██╔══╝  ██╔══██╗██║   ██║██║╚██╗██║██║╚██╗██║██╔══╝  ██╔══██╗'
  echo -e '██║ ╚████║╚██████╔╝██████╔╝███████╗██║  ██║╚██████╔╝██║ ╚████║██║ ╚████║███████╗██║  ██║'
  echo -e '╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝'
  echo -e '\e[0m'

  echo -e "\nПодписаться на канал may.crypto{🦅} чтобы быть в курсе самых актуальных нод - https://t.me/maycrypto\n"
}

# Функция для печати зеленого текста
printGreen() {
  echo -e "\e[32m$1\e[0m"
}

# Функция для печати линии
printLine() {
  echo "--------------------------------------"
}

# Функция для установки ноды Empeiria
install_node() {
  read -p "Создайте имя для кошелька: " WALLET
  echo 'export WALLET='$WALLET
  read -p "Создайте имя для ноды(MONIKER): " MONIKER
  echo 'export MONIKER='$MONIKER
  read -p "Введите Порт, на котором будет работать нода: " PORT
  echo 'export PORT='$PORT

  # задаем переменные
  echo "export WALLET="$WALLET"" >> $HOME/.bash_profile
  echo "export MONIKER="$MONIKER"" >> $HOME/.bash_profile
  echo "export EMPED_CHAIN_ID="empe-testnet-2"" >> $HOME/.bash_profile
  echo "export EMPED_PORT="$PORT"" >> $HOME/.bash_profile
  source $HOME/.bash_profile

  printLine
  echo -e "Имя ноды(MONIKER): \e[1m\e[32m$MONIKER\e[0m"
  echo -e "Кошелек:           \e[1m\e[32m$WALLET\e[0m"
  echo -e "Chain ID:        \e[1m\e[32m$EMPED_CHAIN_ID\e[0m"
  echo -e "PORT: \e[1m\e[32m$EMPED_PORT\e[0m"
  printLine
  sleep 1

  printGreen "1. Установка go..." && sleep 1
  # установка go, если нужно
  cd $HOME
  VER="1.22.3"
  wget "https://golang.org/dl/go$VER.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "go$VER.linux-amd64.tar.gz"
  rm "go$VER.linux-amd64.tar.gz"
  [ ! -f ~/.bash_profile ] && touch ~/.bash_profile
  echo "export PATH=$PATH:/usr/local/go/bin:~/go/bin" >> ~/.bash_profile
  source $HOME/.bash_profile
  [ ! -d ~/go/bin ] && mkdir -p ~/go/bin

  echo $(go version) && sleep 1

  source <(curl -s https://raw.githubusercontent.com/itrocket-team/testnet_guides/main/utils/dependencies_install)

  printGreen "4. Установка бинарного файла..." && sleep 1
  # загрузка бинарного файла
  cd $HOME
  curl -LO https://github.com/empe-io/empe-chain-releases/raw/master/v0.1.0/emped_linux_amd64.tar.gz
  tar -xvf emped_linux_amd64.tar.gz 
  mv emped ~/go/bin

  printGreen "5. Настройка и инициализация приложения..." && sleep 1
  # настройка и инициализация приложения
  emped config node tcp://localhost:${EMPED_PORT}657
  emped config keyring-backend os
  emped config chain-id empe-testnet-2
  emped init $MONIKER --chain-id empe-testnet-2
  sleep 1
  echo готово

  printGreen "6. Загрузка genesis и addrbook..." && sleep 1
  # загрузка genesis и addrbook
  wget -O $HOME/.empe-chain/config/genesis.json https://server-5.itrocket.net/testnet/empeiria/genesis.json
  wget -O $HOME/.empe-chain/config/addrbook.json  https://server-5.itrocket.net/testnet/empeiria/addrbook.json
  sleep 1
  echo готово

  printGreen "7. Добавление seed, peer, настройка пользовательских портов, обрезка, минимальная цена газа..." && sleep 1
  # настройка seed и peer
  SEEDS="20ca5fc4882e6f975ad02d106da8af9c4a5ac6de@empeiria-testnet-seed.itrocket.net:28656"
  PEERS="03aa072f917ed1b79a14ea2cc660bc3bac787e82@empeiria-testnet-peer.itrocket.net:28656,004e2924efb660169e27d55518909b24f902dd48@155.133.27.170:26656,7f777a33fc94dfdade513c161a0bafbb0cfc2025@213.199.45.86:43656,5faa12744223fd0aea91970e405d69731ff35fed@62.169.17.9:43656,33cfcfa07ad55331d40fb7bcda010b0156328647@149.102.144.171:43656,3e30e4b87bdd45e9715b0bbf02c9930d820a3158@164.132.168.149:26656,bb15883943a2f31b1ca73247a1b0526a5778f23a@135.181.94.81:26656,e058f20874c7ddf7d8dc8a6200ff6c7ee66098ba@65.109.93.124:29056,0340080d68f88eb6944bd79c86abd3c9794eb0a0@65.108.233.73:13656,45bdc8628385d34afc271206ac629b07675cd614@65.21.202.124:25656,a9cf0ffdef421d1f4f4a3e1573800f4ee6529773@136.243.13.36:29056,878d0e8b9741adc865823e4f69554712e35236b9@91.227.33.18:13656,66ac611ba87753e92f1e5d792a2b19d4c5080f32@188.40.73.112:22656"
  sed -i -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*seeds *=.*/seeds = \"$SEEDS\"/}" \
         -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*persistent_peers *=.*/persistent_peers = \"$PEERS\"/}" \
         $HOME/.empe-chain/config/config.toml

  # настройка пользовательских портов в app.toml
  sed -i.bak -e "s%:1317%:${EMPED_PORT}317%g;
  s%:8080%:${EMPED_PORT}080%g;
  s%:9090%:${EMPED_PORT}090%g;
  s%:9091%:${EMPED_PORT}091%g" $HOME/.empe-chain/config/app.toml

  # настройка пользовательских портов в config.toml
  sed -i.bak -e "s%:26658%:${EMPED_PORT}658%g;
  s%:26657%:${EMPED_PORT}657%g;
  s%:6060%:${EMPED_PORT}060%g;
  s%:26656%:${EMPED_PORT}656%g;
  s%^external_address = \"\"%external_address = \"$(wget -qO- eth0.me):${EMPED_PORT}656\"%;
  s%:26660%:${EMPED_PORT}660%g" $HOME/.empe-chain/config/config.toml

  # настройка обрезки
  sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.empe-chain/config/app.toml
  sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.empe-chain/config/app.toml
  sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"50\"/" $HOME/.empe-chain/config/app.toml

  # настройка минимальной цены газа, включение prometheus и отключение индексирования
  sed -i 's|minimum-gas-prices =.*|minimum-gas-prices = "0.0001uempe"|g' $HOME/.empe-chain/config/app.toml
  sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.empe-chain/config/config.toml
  sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.empe-chain/config/config.toml
  sleep 1
  echo готово

  # создание файла службы
  sudo tee /etc/systemd/system/emped.service > /dev/null <<EOF
[Unit]
Description=empeiria node
After=network-online.target
[Service]
User=$USER
WorkingDirectory=$HOME/.empe-chain
ExecStart=$(which emped) start --home $HOME/.empe-chain
Restart=on-failure
RestartSec=5
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

  printGreen "8. Загрузка snapshot и запуск узла..." && sleep 1
  # сброс и загрузка снапшота
  emped tendermint unsafe-reset-all --home $HOME/.empe-chain
  if curl -s --head curl https://server-5.itrocket.net/testnet/empeiria/empeiria_2024-08-01_781124_snap.tar.lz4 | head -n 1 | grep "200" > /dev/null; then
    curl https://server-5.itrocket.net/testnet/empeiria/empeiria_2024-08-01_781124_snap.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.empe-chain
  else
    echo "Snapshot не найден"
  fi

  # включение и запуск службы
  sudo systemctl daemon-reload
  sudo systemctl enable emped
  sudo systemctl restart emped
}

# Функция для проверки статуса синхронизации ноды Empeiria
check_sync_status() {
  emped status 2>&1 | jq
  echo "Если \"catching_up: false\", то Вы можете продолжить установку."
}

# Функция для создания кошелька Empeiria
create_wallet() {
  emped keys add $WALLET

  # save wallet and validator address
  WALLET_ADDRESS=$(emped keys show $WALLET -a)
  VALOPER_ADDRESS=$(emped keys show $WALLET --bech val -a)
  echo "export WALLET_ADDRESS=\"$WALLET_ADDRESS\"" >> $HOME/.bash_profile
  echo "export VALOPER_ADDRESS=\"$VALOPER_ADDRESS\"" >> $HOME/.bash_profile
  source $HOME/.bash_profile
}

# Функция для запроса токенов на кошелек
request_tokens() {
  if [ -z "$WALLET" ] || [ -z "$WALLET_ADDRESS" ]; then
    echo "Кошелек не создан. Пожалуйста, создайте кошелек с помощью пункта 3."
  else
    echo "Имя кошелька: $WALLET"
    echo "Адрес кошелька: $WALLET_ADDRESS"
    # Здесь код для запроса токенов (например, через Faucet или другой метод)
  fi
}

# Функция для создания валидатора Empeiria
create_validator() {
  emped tx staking create-validator \
  --amount 1000000uempe \
  --from $WALLET \
  --commission-rate 0.1 \
  --commission-max-rate 0.2 \
  --commission-max-change-rate 0.01 \
  --min-self-delegation 1 \
  --pubkey $(emped tendermint show-validator) \
  --moniker $MONIKER \
  --identity "" \
  --website "" \
  --details "NodeRunner Community 2024" \
  --chain-id empe-testnet-2 \
  --gas auto --gas-adjustment 1.5 --fees 30uempe \
  -y
}

# Функция для отображения логов ноды Empeiria
show_logs() {
  echo "Ждем 10 секунд..."
  sleep 10
  echo "Начинается отображение логов ноды Empeiria..."
  echo "Для выхода из логов используйте CTRL+C"
  sudo journalctl -u emped -f
}

# Функция для отображения меню
show_menu() {
  display_logo
  echo "МЕНЮ СКРИПТА:"
  echo "1. Установить ноду Empeiria"
  echo "2. Проверить статус синхронизации ноды Empeiria"
  echo "3. Создать кошелек Empeiria Wallet"
  echo "4. Создать валидатора Empeiria"
  echo "5. Проверить логи ноды Empeiria"
  echo "6. Выйти"
  echo ""
  read -p "Выберите пункт меню: " choice
  case $choice in
    1) install_node ;;
    2) check_sync_status ;;
    3) create_wallet ;;
    4) create_validator ;;
    5) show_logs ;;
    6) exit 0 ;;
    *) echo "Неверный выбор, попробуйте снова." ;;
  esac
  show_menu
}

# Запуск меню
show_menu
