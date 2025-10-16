# script

### srvadmin
- Установка только папки srvadmin\
- Устанавливаем будем в папку /srv\
в пространстве root пользователя клонируем репозиторий 
```bash
git clone --no-checkout https://github.com/1xtier/script.git
cd script
git sparse-checkout init --cone
git checkout main
git sparse-checkout set srvadmin
mv srvadmin /srv/
vim ~/.bashrc
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/usr/sbin:/srv/srvadmin/bin"
source ~/.bashrc
cd ..
rm -rf script
```
**Важно склонировать только определнную папку можно в версии git = 2.25**
