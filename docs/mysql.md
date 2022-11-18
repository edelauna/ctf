## mySQL

### Installation
* Add keys
```sh
wget https://repo.mysql.com/mysql-apt-config_0.8.22-1_all.deb
sudo dpkg -i mysql-apt-config_0.8.22-1_all.deb
```
* Install mysql `apt update && sudo apt install mysql*`

### Usage
* `mysql -u $user -p$pass -e 'show databases'`
```sh
SHOW databases;
USE {databse_name};
SHOW tables;
```

### Injection
* Try adding `'` to see if an error occurs - afterwards `' -- -` to see if error goes away