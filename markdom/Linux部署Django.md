---
typora-root-url: image
---

# Linux运维相关备忘录



```
在计算机科学中，Shell就是一个（命令解释器）

shell是位于操作系统和用户之间，是他们二者最主要的接口，shell负责把应用程序的输入命令信息解释给操作系统，将操作系统指令处理后的结果解释给应用程序。
```

查看当前系统的shell类型

```
echo $SHELL
```

查看当前系统环境支持的shell

```
[root@linux-node1 ~]cat /etc/shells

/usr/bin/sh

/usr/bin/bash

/usr/sbin/nologin
```

**shell使用方式**

```
手工方式:

手工敲击键盘,在shell的命令行输入命令,按Enter后,执行通过键盘输入的命令,然后shell返回并显示命令执行的结果.

重点：**逐行输入命令、逐行进行确认执行**
```

 

```
脚本方式:

就是说我们把手工执行的命令a，写到一个脚本文件b中，然后通过执行脚本b，达到执行命令a的效果.
```

**shell执行的方式**

Shell脚本的执行通常可以采用以下几种方式

 

```
bash /path/to/script-name	或	/bin/bash /path/to/script-name	（**强烈推荐使用**）

/path/to/script-name		或	./script-name	（当前路径下执行脚本）

source script-name			或	. script-name	（注意“.“点号）
```

 

执行说明：

1、脚本文件本身没有可执行权限或者脚本首行没有命令解释器时使用的方法，我们推荐用bash执行。

使用频率：☆☆☆☆☆

2、脚本文件具有可执行权限时使用。

使用频率：☆☆☆☆

3、使用source或者.点号，加载shell脚本文件内容，使shell脚本内容环境和当前用户环境一致。

使用频率：☆☆☆

使用场景：环境一致性





### Django项目环境部署



**软件安装**

安装虚拟环境软件

```
apt-get install python-virtualenv -y
```

**虚拟环境基本操作**

​	创建 

```
virtualenv -p /usr/bin/python3.5 venv
```

​	进入

```
source venv/bin/activate
```

​	退出

```
deactivate
```

​	删除

```
rm -rf venv
```



### django环境

**django软件安装**

注意：先进入虚拟环境

​	解压

```
cd /data/soft

tar xf Django-1.10.7.tar.gz
```

​	查看

```
cd Django-1.10.7

cat INSTALL or README
```

​	安装

```
python setup.py install
```

​	

**拓展 ：**	

​	python类型软件的安装流程

​		**普通：**

​			解压   安装

​		**特殊：**

​			解压    编译 	安装

​			

​			编译：`python setup.py build`

 

 **django项目操作**

​	创建项目

```
cd /data/server

django-admin startproject demo
```

**django应用操作**

​	创建应用

```
cd /data/server/demost

python manage.py startapp test1
```

​	注册应用

```
vim demo/settings.py

 

INSTALL_APP = [

	。。。

	'test1',

]
```

**view和url配置**

需求：

访问django的页面请求为：127.0.0.1:8000/hello/,页面返回效果为

分析：

views文件定制逻辑流程函数

urls文件定制路由跳转功能

 

​	view 配置文件生效

```
admin-1@ubuntu:/data/softcat /data/server/demo/test1/views.py

from django.shortcuts import render

from django.http import HttpResponse

 

Create your views here.

 

def hello(resquest):

   return HttpResponse("demo  V1.0")	
```

​	

​	url文件配置

```
admin-1@ubuntu:/data/softcat /data/server/st/demo/urls.py

...

from test1.views import *

 

urlpatterns = [

	url(r'^admin/', admin.site.urls),

	url(r'^hello/$', hello),

]
```

 

​	启动django：

```
cd /data/server/demo

python  manage.py runserver
```

​	



### **nginx环境**

**pcre软件安装**

解压

```
cd /data/soft/

tar xf pcre-8.39.tar.gz
```

查看帮助

```
cd pcre-8.39
```

INSTALL 或者 README

配置

```
./configure
```

编译

```
make
```

安装

```
make install
```

 

**拓展 ：**

linux中软件安装的一般流程

​	解压

​	

```
tar
```

​			解压文件，获取真正的配置文件

​	配置

​		

```
configure
```

​			根据默认的配置项或者更改配置项，生成编译配置文件(Makefile)

​	编译

​		

```
make
```

​			根据 Makefile 内容，编译生成指定的软件所需要的所有文件

​	安装

​		

```
make install
```

​			将编译生成的所有文件，转移到软件指定安装的目录下面



**nginx软件安装**

解压

```
cd /data/soft/

tar xf nginx-1.10.2.tar.gz
```

配置

```
cd nginx-1.10.2/

./configure --prefix=/data/server/nginx --without-http_gzip_module
```

编译

```
make
```

安装

```
make install
```

 

**nginx简单操作**

检查

```
/data/server/nginx/sbin/nginx -t
```

开启

```
/data/server/nginx/sbin/nginx
```

关闭

```
/data/server/nginx/sbin/nginx -s stop
```

重载

```
/data/server/nginx/sbin/nginx -s reload
```

 

**常见问题**

​	突发问题：

```
admin-1@ubuntu:/data/server/nginx./sbin/nginx -t

./sbin/nginx: error while loading shared libraries: libpcre.so.1: cannot open shared object file: No such file or directory
```

 

​		分析：

​			1、先看报错

​			2、思考，是否报错真实有效

​				分析：	谁错了

​				

​			3、查找文件

​				全名找不到，我们使用正则

​			4、找到文件，我没有问题

​				nginx默认找库文件的路径有问题

​			5、解决

解决：

```
admin-1@ubuntu:/data/soft/nginx-1.10.2ldd /data/server/nginx/sbin/nginx 

	linux-vdso.so.1 =>  (0x00007ffdb9154000)

	libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007fa59379b000)

	libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007fa59357e000)

	libcrypt.so.1 => /lib/x86_64-linux-gnu/libcrypt.so.1 (0x00007fa593345000)

	libpcre.so.1 => not found

	libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fa592f7c000)

	/lib64/ld-linux-x86-64.so.2 (0x0000564bfef41000
```

)

查找文件：

```
admin-1@ubuntu:/data/soft/nginx-1.10.2find / -name "libpcre.so.1"

/data/soft/pcre-8.39/.libs/libpcre.so.1

/usr/local/lib/libpcre.so.1

...
```

链接该文件

```
admin-1@ubuntu:/data/soft/nginx-1.10.2ln -s /usr/local/lib/libpcre.so.1 /lib/x86_64-linux-gnu/
```

再次检查一下nginx的配置文件

```
admin-1@ubuntu:/data/soft/nginx-1.10.2/data/server/nginx/sbin/nginx -t

nginx: the configuration file /data/server/nginx/conf/nginx.conf syntax is ok

nginx: configuration file /data/server/nginx/conf/nginx.conf test is successful
```

\---------------

### nginx代理django

**nginx配置简介**

​	nginx的目录结构

```
admin-1@ubuntu:/data/server/nginxtree -L 2 /data/server/nginx/

/data/server/nginx/
```

├── ...

├── conf				配置文件目录

│   ...

│   ├── nginx.conf		默认的配置文件

│   ...

├── ...

├── html				网页文件

│   ├── 50x.html

│   └── index.html

├── logs				日志目录

│   ├── access.log

│   └── error.log

├── ...

├── sbin				执行文件目录

│   └── nginx

├── ...	

​		

**nginx配置文件介绍**

​	全局配置段 					

​	http配置段

​		server配置段			项目或者应用

​			location配置段		url配置



**nginx代理配置**

案例需求：

​	访问地址 192.168.8.14/hello/ 跳转到 127.0.0.1:8000/hello/的django服务来处理hello请求

 

![img](https://github.com/minijy/linux/blob/master/markdom/image/wps1.jpg) 

代理是什么？



哥，这事交给我就行了，您就甭操心了。

**编辑配置文件实现代理功能**

​	配置内容

```
worker_processes  1; #nginx 进程数，建议按照cpu 数目来指定，一般为它的倍数
worker_rlimit_nofile 20000; #一个nginx 进程打开的最多文件描述符数目，理论值应该是最多打开文件数（ulimit -n）与nginx 进程数相除，但是nginx 分配请求并不是那么均匀，所以最好与ulimit -n 的值保持一致


events {
    use epoll;   # 使用epoll的I/O模型
    worker_connections 20000;  # 每个进程允许的最多连接数， 理论上每台nginx 服务器的最大连接数为 worker_processes*worker_connections
     multi_accept on;

}

http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  35;
    
    leaky bucket  #限制ip连接  防止DDOS
    limit_conn_log_level error;

    limit_conn_status 503;
	#设置名为“one”或“allips”的存储区，大小为10兆字节
    limit_conn_zone $binary_remote_addr zone=one:10m;
	
    limit_conn_zone $server_name zone=perserver:10m;

    #允许1秒钟不超过10个请求，其中$binary_remote_addr有时需要根据已有的log_format变量配置进行替换
    limit_req_zone $binary_remote_addr zone=allips:100m   rate=10r/s;   


负载均衡
  upstream demo {
         server 10.200.45.2:8001;  # 此处为uwsgi运行的ip地址和端口号
         # 如果有多台服务器，可以在此处继续添加服务器地址，以下为负载均衡策略
         weight   # 权重
         ip_hash # ip哈希  按照哈希后的ip分配至固定的服务器（不推荐）但是解决分布式下session问题
         least_conn    # 最少连接数
         fair（第三方）  # 响应时间方式 
         url_hash（第三方）  # 根据url方式分配   配合缓存命中使用  解决缓存重复下载
     }

   
     server {
         listen  8080;
         server_name api.demo.site;

         location / {
             include uwsgi_params;
             uwsgi_pass demo;
         }

     }


     server {
     	 表示最大并发连接数500
         limit_conn  one  500;    
         表示该服务提供的总连接数不得超过5000,超过请求的会被拒绝
	     limit_conn perserver 5000;
	     表示最大延迟请求数量不大于5。  如果太过多的请求被限制延迟是不需要的 ，这时需要使用nodelay参            数，服务器会立刻返回503状态码。
         limit_req   zone=allips  burst=5  nodelay;
      
         listen       80;
         server_name  www.demo.site;

         #charset koi8-r;

         #access_log  logs/host.access.log  main;
         location /xadmin {
             include uwsgi_params;
             uwsgi_pass demo;
         }

         location / {
             root   /home/python/Desktop/static_front_pc;
             index  index.html index.htm;
         }
         
         location /download { 
         	 limit_rate 128k; 
         } 

         如果想设置用户下载文件的前10m大小时不限速，大于10m后再以128kb/s限速可以增加以下配内容、

         location /download { 
         limit_rate_after 10m; 
         limit_rate 128k; 
         }  


         error_page   500 502 503 504  /50x.html;
         location = /50x.html {
             root   html;
         }

     }
```



配置文件生效

```
/data/server/nginx/sbin/nginx -t

/data/server/nginx/sbin/nginx -s reload
```



### 动态接口uWSGI



##### 引入 django-cors-middleware

```
pip install django-cors-middleware 
```

##### 在 settings.py中添加，注意：不添加的话无法生效 

```
INSTALLED_APPS = (

...

'corsheaders',

)
```

 

##### 添加中间件监听

```
MIDDLEWARE = [

...

'corsheaders.middleware.CorsMiddleware',

'django.middleware.common.CommonMiddleware',

...

]
```

设置允许访问的方法: 

```
CORS_ALLOW_METHODS = (

'GET',

'POST',

'PUT',

'PATCH',

'DELETE',

'OPTIONS'

)
```



##### 设置允许的header：

默认值:

```
CORS_ALLOW_HEADERS = (

'x-requested-with',

'content-type',

'accept',

'origin',

'authorization',

'x-csrftoken'

)
```

 

#####  配置允许跨域访问的域名

```
设置主机
ALLOWED_HOSTS = [...,  'www.xxx.xxx']

允许跨域访问的域名
CORS_ORIGIN_WHITELIST = (
    'localhost:8080',
    'www.xxx.xxx',
)
```

##### 修改wsgi.py文件 

```
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "demo.settings.prod")
```

#####  安装uwsgi

```
pip install uwsgi
```

在项目目录下创建uwsgi配置文件 uwsgi.ini

```
[uwsgi]
#使用nginx连接时使用，Django程序所在服务器地址
socket=10.211.55.2:8001
#直接做web服务器使用，Django程序所在服务器地址
#http=10.211.55.2:8001
#项目目录
chdir=/Users/delron/Desktop/demo/demo_app
#项目中wsgi.py文件的目录，相对于项目目录
wsgi-file=demo_app/wsgi.py
# 进程数
processes=24
# 线程数
threads=65535 
uwsgi服务器的角色
master=True
存放进程编号的文件
pidfile=uwsgi.pid
日志文件，因为uwsgi可以脱离终端在后台运行，日志看不见。我们以前的runserver是依赖终端的
daemonize=uwsgi.log
指定依赖的虚拟环境
virtualenv=/Users/delron/.virtualenv/demo
workers/processes = 24   # 并发处理进程数
listen = 65535  # 并发的socket 连接数。默认为100。优化需要根据系统配置
```

启动uwsgi服务器

```
uwsgi --ini uwsgi.ini
```

注意如果想要停止服务器，除了可以使用kill命令之外，还可以通过 

```
uwsgi --stop uwsgi.pid
```

并发测试

```
ab -r -n 10000 -c 5000 -H "User-Agent: python-keystoneclient" 

-H "Accept: application/json" -H "X-Auth-Token: 65e194"  http://172.16.29.10:81/
```



当Django运行在生产模式时，将不再提供静态文件的支持，需要将静态文件交给静态文件服务器。



**我们要将收集的静态文件放到static_front目录下的static目录中，所以先创建目录static。**

Django提供了收集静态文件的方法。先在配置文件中配置收集之后存放的目录

```
STATIC_ROOT = os.path.join(os.path.dirname(os.path.dirname(BASE_DIR)), 'static_front/static')
```

然后执行收集命令

```
python manage.py collectstatic
```





### Keepalived + Nginx 实现高可用 Web 负载均衡



### 方案规划

| VIP           | IP            | 主机名 | Nginx端口 | 默认主从 |
| ------------- | ------------- | ------ | --------- | -------- |
| 192.168.2.130 | 192.168.2.101 | host1  | 88        | MASTER   |
| 192.168.2.130 | 192.168.2.102 | host2  | 88        | BACKUP   |

##### 系统防火墙打开对应的端口 88

```
vi /etc/sysconfig/iptables #Nginx -A INPUT -m state --state NEW -m tcp -p tcp --dport 88 -j ACCEPT service iptables restart
```



##### 安装 Keepalived

```
http://www.keepalived.org/download.html
```

##### 解压安装

```
cd /usr/local/src

tar -zxvf keepalived-1.2.18.tar.gz

cd keepalived-1.2.18

./configure --prefix=/usr/local/keepalived

make && make install
```

##### 将 keepalived 安装成 Linux 系统服务

因为没有使用 keepalived 的默认路径安装（默认是/usr/local） ,安装完成之后，需要做一些工作复制默认配置文件到默认路径

```
mkdir /etc/keepalived

cp /usr/local/keepalived/etc/keepalived/keepalived.conf /etc/keepalived
```

##### 复制 keepalived 服务脚本到默认的地址

```
cp /usr/local/keepalived/etc/rc.d/init.d/keepalived /etc/init.d/

cp /usr/local/keepalived/etc/sysconfig/keepalived /etc/sysconfig/

ln -s /usr/local/sbin/keepalived /usr/sbin/

ln -s /usr/local/keepalived/sbin/keepalived /sbin/
```

设置 keepalived 服务开机启动

```
chkconfig keepalived on
```

修改 Keepalived 配置文件
(1) MASTER 节点配置文件（192.168.2.102）

```
vi /etc/keepalived/keepalived.conf
```



```
! Configuration File for keepalived
global_defs {
	#keepalived 自带的邮件提醒需要开启 sendmail 服务。 建议用独立的监控或第三方 SMTP
	router_id liuyazhuang133 #标识本节点的字条串，通常为 hostname
}
```

keepalived 会定时执行脚本并对脚本执行的结果进行分析，动态调整 vrrp_instance 的优先级。如果脚本执行结果为 0，并且 weight 配置的值大于 0，则优先级相应的增加。如果脚本执行结果非 0，并且 weight配置的值小于 0，则优先级相应的减少。其他情况，维持原本配置的优先级，即配置文件中 priority 对应的值。

```
vrrp_script chk_nginx {
	script "/etc/keepalived/nginx_check.sh" #检测 nginx 状态的脚本路径
	interval 2 #检测时间间隔
	weight -20 #如果条件成立，权重-20
}
```


## 定义虚拟路由， VI_1 为虚拟路由的标示符，自己定义名称
```
vrrp_instance VI_1 {
	state MASTER #主节点为 MASTER， 对应的备份节点为 BACKUP
	interface eth0 #绑定虚拟 IP 的网络接口，与本机 IP 地址所在的网络接口相同， 我的是 eth0
	virtual_router_id 33 #虚拟路由的 ID 号， 两个节点设置必须一样， 可选 IP 最后一段使用, 相同的 VRID 为一个组，他将决定多播的 MAC 地址
	mcast_src_ip 192.168.2.101 #本机 IP 地址
	priority 100 #节点优先级， 值范围 0-254， MASTER 要比 BACKUP 高
	nopreempt #优先级高的设置 nopreempt 解决异常恢复后再次抢占的问题
	advert_int 1 #组播信息发送间隔，两个节点设置必须一样， 默认 1s
	#设置验证信息，两个节点必须一致
	authentication {
		auth_type PASS
		auth_pass 1111 #真实生产，按需求对应该过来
	}
	#将 track_script 块加入 instance 配置块
	track_script {
		chk_nginx #执行 Nginx 监控的服务
	} #
	虚拟 IP 池, 两个节点设置必须一样
	virtual_ipaddress {
		192.168.2.130 #虚拟 ip，可以定义多个
	}
}

```


(2)BACKUP 节点配置文件（192.168.2.102） 

```
vi /etc/keepalived/keepalived.conf
```



```
! Configuration File for keepalived
global_defs {
	router_id liuyazhuang134
}
vrrp_script chk_nginx {
	script "/etc/keepalived/nginx_check.sh"
	interval 2
	weight -20
}
vrrp_instance VI_1 {
	state BACKUP
	interface eth1
	virtual_router_id 33
	mcast_src_ip 192.168.2.102
	priority 90
	advert_int 1
	authentication {
		auth_type PASS
		auth_pass 1111
	}
	track_script {
		chk_nginx
	}
	virtual_ipaddress {
		192.168.2.130
	}
}
```


5、 编写 Nginx 状态检测脚本
编写 Nginx 状态检测脚本 /etc/keepalived/nginx_check.sh (已在 keepalived.conf 中配置)脚本要求：如果 nginx 停止运行，尝试启动，如果无法启动则杀死本机的 keepalived 进程， keepalied将虚拟 ip 绑定到 BACKUP 机器上。 内容如下：

```
vi /etc/keepalived/nginx_check.sh
```

```
!/bin/bash

A=`ps -C nginx –no-header |wc -l`
if [ $A -eq 0 ];then
/usr/local/nginx/sbin/nginx
sleep 2
if [ `ps -C nginx --no-header |wc -l` -eq 0 ];then
	killall keepalived
fi
fi
```


保存后，给脚本赋执行权限： 
```
chmod +x /etc/keepalived/nginx_check.sh
```

6、 启动 Keepalived
```
service keepalived start

Starting keepalived: [ OK ]
```





### mysql主从复制读写分离



##### 1.  备份主服务器原有数据到从服务器

```
mysqldump -uroot -pmysql --all-databases --lock-all-tables > ~/master_db.sql
```

- -u ：用户名
- -p ：示密码
- --all-databases ：导出所有数据库
- --lock-all-tables ：执行操作时锁住所有表，防止操作时有数据修改
- ~/master_db.sql :导出的备份数据（sql文件）位置，可自己指定

导入数据

```
mysql -uroot -pmysql -h192.168.40.1 --port=3306 < ~/master_db.sql
```

##### 2. 配置主服务器master

编辑设置mysqld的配置文件，设置log_bin和server-id

```
sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf
```

```
server-id      = 1                            #服务器唯一ID，默认是1，一般取IP最后一段
log_bin        = /var/log/mysql/mysql-bin.log    #主库必须启用二进制日志，此路径必须存在（手动创建）
log-slave-updates=1                         #将更新的记录些不断地写入到二进制文件里
```

其他扩展配置项【非必须】

```
# skip-name-resolve       #关闭名称解析
# binlog-do-db=day15      #需要备份的数据库名，如果备份多个数据库，重复设置这个选项即可
# binlog-ignore-db=mysql  #不需要备份的数据库名，如果备份多个数据库，重复设置这个选项即可

# slave-skip-errors=1     #是跳过错误，继续执行复制操作(可选)
```

- 检查修改的配置是否正确

```
egrep 'server-id|log-bin' /etc/my.cnf
```

重启mysql服务

```
sudo service mysql restart
```

登入主服务器中的mysql，创建用于从服务器同步数据使用的帐号

```
mysql –uroot –pmysql

GRANT REPLICATION SLAVE ON *.* TO 'slave'@'%' identified by 'slave';

FLUSH PRIVILEGES;
```

获取主服务器的二进制日志信息

```
SHOW MASTER STATUS;
```

**File为使用的日志文件名字，Position为使用的文件位置，这两个参数须记下，配置从服务器时会用到。**

#### 4）配置从服务器slave 

配置

```
server-id=102                                       #配置server-id，让从服务器有唯一ID号
relay_log = /application/mysql/log/mysql-relay-bin  #打开Mysql中继日志，此路径必须存在，手动创建
read_only = 1                       #设置只读权限
log_bin = mysql-bin                 #开启从服务器二进制日志(一主一从时从库可以不开启)
log_slave_updates = 1               #使得更新的数据写进二进制日志中(一主一从时从库可以不开启)
```

进入docker中的mysql

```
mysql -uroot -pmysql -h 192.168.40.1 --port=3306
```

执行

```
change master to master_host='192.168.40.1', master_user='slave', master_password='slave',master_log_file='mysql-bin.000006', master_log_pos=590;
```

- master_host：主服务器Ubuntu的ip地址
- master_log_file: 前面查询到的主服务器日志文件名
- master_log_pos: 前面查询到的主服务器日志文件位置

启动slave服务器，并查看同步状态

```
start slave;
show slave status \G
```



### Django实现数据库读写分离

django在进行数据库操作的时候，读取数据与写数据（增、删、改）可以分别从不同的数据库进行操作。

#### 1. 在配置文件中增加slave数据库的配置

```
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'HOST': '10.211.55.5',
        'PORT': 3306,
        'USER': 'name',
        'PASSWORD': 'xxx',
        'NAME': 'project'
    },
    'slave': {
        'ENGINE': 'django.db.backends.mysql',
        'HOST': '10.211.55.6',
        'PORT': 3306,
        'USER': 'name',
        'PASSWORD': 'mysql',
        'NAME': 'project'
    }
}
```

### 2. 创建数据库操作的路由分发类

在project/utils中创建db_router.py

```
class MasterSlaveDBRouter(object):
    """数据库主从读写分离路由"""

    def db_for_read(self, model, **hints):
        """读数据库"""
        return "slave"

    def db_for_write(self, model, **hints):
        """写数据库"""
        return "default"

    def allow_relation(self, obj1, obj2, **hints):
        """是否运行关联操作"""
        return True
```

#### 3. 配置读写分离路由

在配置文件中增加

```
# 配置读写分离
DATABASE_ROUTERS = ['project_mall.utils.db_router.MasterSlaveDBRouter']
```