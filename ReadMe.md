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

- 增加PM2组件
````bash
cat >> ./www/init.sh << EOF
# install nodejs npm
apk add --no-cache nodejs npm
npm config set registry https://registry.npm.taobao.org

# install pm2
npm install pm2@latest -g

# start pm2
pm2 start /www/pm2.yaml

# add to supervisord
cat >> /etc/supervisor/conf.d/supervisord.conf << EOE

[program:pm2]
command=pm2 start /www/pm2.yaml
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
stderr_logfile=/dev/stderr
stderr_logfile_maxbytes=0
autorestart=true
startretries=0
EOE

EOF
````

- 启动并进入容器，执行初始化
````bash
docker-compose up -d
docker-compose exec www bash

./init.sh
````
