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
[root@linux-node1 ~]# cat /etc/shells

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

**拓展知识点：**	

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
admin-1@ubuntu:/data/soft# cat /data/server/demo/test1/views.py

from django.shortcuts import render

from django.http import HttpResponse

 

Create your views here.

 

def hello(resquest):

   return HttpResponse("demo  V1.0")	
```

​	

​	url文件配置

```
admin-1@ubuntu:/data/soft# cat /data/server/st/demo/urls.py

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

 

**拓展知识点：**

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
admin-1@ubuntu:/data/server/nginx# ./sbin/nginx -t

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
admin-1@ubuntu:/data/soft/nginx-1.10.2# ldd /data/server/nginx/sbin/nginx 

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
admin-1@ubuntu:/data/soft/nginx-1.10.2# find / -name "libpcre.so.1"

/data/soft/pcre-8.39/.libs/libpcre.so.1

/usr/local/lib/libpcre.so.1

...
```

链接该文件

```
admin-1@ubuntu:/data/soft/nginx-1.10.2# ln -s /usr/local/lib/libpcre.so.1 /lib/x86_64-linux-gnu/
```

再次检查一下nginx的配置文件

```
admin-1@ubuntu:/data/soft/nginx-1.10.2# /data/server/nginx/sbin/nginx -t

nginx: the configuration file /data/server/nginx/conf/nginx.conf syntax is ok

nginx: configuration file /data/server/nginx/conf/nginx.conf test is successful
```

\---------------

### nginx代理django

**nginx配置简介**

​	nginx的目录结构

```
admin-1@ubuntu:/data/server/nginx# tree -L 2 /data/server/nginx/

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
worker_processes  1;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;
    
    # leaky bucket  限制ip连接  防止DDOS
    limit_conn_log_level error;

    limit_conn_status 503;
	# 设置名为“one”或“allips”的存储区，大小为10兆字节
    limit_conn_zone $binary_remote_addr zone=one:10m;
	
    limit_conn_zone $server_name zone=perserver:10m;

    # 允许1秒钟不超过10个请求，其中$binary_remote_addr有时需要根据已有的log_format变量配置进行替换
    limit_req_zone $binary_remote_addr zone=allips:100m   rate=10r/s;   


# 负载均衡
  upstream demo {
         server 10.200.45.2:8001;  # 此处为uwsgi运行的ip地址和端口号
         # 如果有多台服务器，可以在此处继续添加服务器地址，以下为负载均衡策略
         # weight   权重
         # ip_hash ip哈希  按照哈希后的ip分配至固定的服务器（不推荐）但是解决分布式下session问题
         # least_conn    最少连接数
         # fair（第三方）  响应时间方式 
         # url_hash（第三方）  根据url方式分配   配合缓存命中使用  解决缓存重复下载
     }

   
     server {
         listen  8001;
         server_name api.demo.site;

         location / {
             include uwsgi_params;
             uwsgi_pass demo;
         }

     }


     server {
     	 # 表示最大并发连接数500
         limit_conn  one  500;    
         # 表示该服务提供的总连接数不得超过5000,超过请求的会被拒绝
	     limit_conn perserver 5000;
	     # 表示最大延迟请求数量不大于5。  如果太过多的请求被限制延迟是不需要的 ，这时需要使用nodelay参            数，服务器会立刻返回503状态码。
         limit_req   zone=allips  burst=5  nodelay;
      
         listen       80;
         server_name  www.demo.site;

         #charset koi8-r;

         #access_log  logs/host.access.log  main;
         location /xadmin {
             include uwsgi_params;
             uwsgi_pass demo;
         }

         location /ckeditor {
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

         # 如果想设置用户下载文件的前10m大小时不限速，大于10m后再以128kb/s限速可以增加以下配内容、

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
# 设置主机
ALLOWED_HOSTS = [...,  'www.xxx.xxx']

# 允许跨域访问的域名
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
processes=4
# 线程数
threads=2
# uwsgi服务器的角色
master=True
# 存放进程编号的文件
pidfile=uwsgi.pid
# 日志文件，因为uwsgi可以脱离终端在后台运行，日志看不见。我们以前的runserver是依赖终端的
daemonize=uwsgi.log
# 指定依赖的虚拟环境
virtualenv=/Users/delron/.virtualenv/demo

```

启动uwsgi服务器

```
uwsgi --ini uwsgi.ini
```

注意如果想要停止服务器，除了可以使用kill命令之外，还可以通过 

```
uwsgi --stop uwsgi.pid
```





### 静态文件(Nginx正向代理)

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

