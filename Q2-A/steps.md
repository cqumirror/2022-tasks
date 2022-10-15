#步骤(环境:archlinux)

###1.安装依赖

```shell
sudo pacman -S nginx
```

###2.修改配置
(1)nginx.conf

```shell
......

http {

......
#目录显示
    autoindex on;
    autoindex_exact_size off;
    autoindex_localtime on;

......
#80端口
    server {
        listen       80;
        server_name  localhost;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
            root   /data/crates.io-index;
            index  index.html index.htm;
        }
    }
......
#8080端口
    server {
        listen       8080;
        server_name  somename  alias  another.alias;

        location / {
            root   /usr/share/nginx/block;
            index  index.html index.htm;
        }
    }
}
......

```
(2)8080端口的封锁页面

```shell
sudo mkdir /usr/share/nginx/block && cp /usr/share/nginx/html/index.html /usr/share/nginx/block
```

修改index.html为封锁页面

```shell
<!DOCTYPE html>
<html>
<head><title>503 Service Unavailable</title></head>
<body>
<center><h1>503 Service Unavailable</h1></center>
<p>If you see this page, your account was banned from mirror.</p>

<hr><center>Tengine/1.22.1</center>
</body>
</html>

```

###3.准备repo

```shell
sudo mkdir /data && cd /data && git clone https://%repo%/crates.io-index.git
```

###4.启动

```shell
 sudo systemctl start/enable nginx
```
