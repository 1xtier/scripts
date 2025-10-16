## Ansible Vault + KeePassXC + OpenGPG
Настройка разблокировки ansible vault с keepassxc

1: Создадим скрипт который и будет нам открывать Ansible Vault и обзовём его так ansible_open_vault.sh

```bash
PATH_KPCLI='/Applications/KeePassXC.app/Contents/MacOS/keepassxc-cli'
# PATH к программе keepassxc-cli проверить в linux можно which keepassxc-cli
# В MacOS если ставили через dmg то путь будет как в переменной PATH_KPCLI
ANSIBLE_PASS_VAULT=$(echo "$_VAULT_KP_TOKEN" | $PATH_KPCLI show 1:/path/DB /FOLDER_SECRET_DB/NAME_SECRET -sa password)
echo "$ANSIBLE_PASS_VAULT"
```

2: Прописываем скрипт в конфиге ansible.cfg

Теперь не много отступим и поговорим о том а где хранить скрипты.
Я предпочитаю на любой системе будто это Linux или MacOS в папке .local создавать директорию srvadmin.\
В директории srvadmin я создаю две поддиректории это bin и sh и так же создадим vault объясню чуть позже зачем.\

```bash
mkdir -p  $HOME/.local/srvadmin/{bin,sh,vault}
```
и переместим наш скрипт разблокировки ansible vault  в папку sh

```bash
mv ansible_open_vault.sh $HOME/.local/srvadmin/sh
```
ну и прописываем в ansible.cfg
```ini
vault_password_file=/home/users/.local/srvadmin/sh/ansible_open_vault.sh
```

Все и так уже можно будет работать , но каждый раз вызов playbook или roles где используеться ansible vault будет запрашивать  пароль от keepassxc хранилища.

3: Отказываем от ввода пароля для keepassxc

И тут есть два пути создать файл разблокировки и использовать пароль. Так как я использую Keepassxc на нескольких ПК и ноутбуках для меня файл разблокировки не удобно. По это выбираю пароль.

если посмотреть на скрипт разблокировки хранилища то мы увидим что перед командой идет вставка переменной.

3: Автоматическая разблокировка хранилище keepassxc

в директории vault ту что мы создали мы создадим файл open_kp_vault.sh и запишем в него следующее

```bash
_VAULT_KP_TOKEN="Тут ваш пароль от keepassxc"
```

Сейчас многие скажут что воу-воу чувак ты хранишь пароль в открытом виде от Keepassxc?\

Но я же не сказал что на этом все.

Теперь мы этот файл с вами зашифруем с помочью OpenGPG как настроить его смотрите в инете.
Шифруем

```bash
gpg -c open_kp_vault.sh
```

и удаляем старый open_kp_vault.sh

```bash
rm -rf open_kp_vault.sh
```

теперь мы имеем файл open_kp_vault.sh.gpg

и нам что то с этим надо делать.

вносим изменения в ~/.zshrc = ~/.bashrc

```bash
kp-open() {
    local PATH_FILE_ENV=$HOME/.local/srvadmin/vault
    gpg $PATH_FILE_ENV/open_kp_vault.sh.gpg
    chmod +x $PATH_FILE_ENV/open_kp_vault.sh
    source $HOME/.local/srvadmin/vault/open_kp_vault.sh
    if [ -z "$_VAULT_KP_TOKEN" ]; then
        echo "Install"
    else
      echo "Is not install"
    fi
     rm $PATH_FILE_ENV/open_kp_vault.sh
}

kp-clouse() {
    unset _VAULT_KP_TOKEN
    if [ -e $HOME/.local/srvadmin/vault/open_kp_vault.sh ]; then
        echo "Удаляю файл open_kp_vault.sh"
        rm $HOME/.local/srvadmin/vault/open_kp_vault.sh
    else
        echo "Файла не существует."
    fi
}

```

Ну и перечитываем файл ~/.zshrc или ~/.bashrc

Объясняю когда мы вводим команду kp-open gpg расшифровывает файл тот который мы свами зашифровали и устанавливает переменную которая далее используется уже в разблокировки базы keepassxc и ansible  vault


