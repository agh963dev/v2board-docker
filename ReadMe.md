安装步骤
====

- 下载v2board代码

````bash
git submodule update --init --recursive
````

- 修改域名
````bash
sed -i "s/http:\/\/localhost/http:\/\/domain.com/" ./caddy.conf
````

- 修改MySql密码
````bash
sed -i "s/v2boardisbest/newpassword/" ./docker-compose.yaml
````

- 启动并进入容器，执行初始化
````bash
docker-compose up -d
docker-compose exec www bash

# optional
sed -i "s/memory_limit = 128M/memory_limit = 2G/" /etc/php7/php.ini
php -r "echo ini_get('memory_limit').PHP_EOL;"

# initialize
bash ./init.sh
````
