# 域名解析和ca证书不同服务器的配置





### 阿里云网址解析到域名

在阿里云控制台-产品与服务-云解析DNS-找到需要解析的域名点“解析”，进入解析页面后选择【添加解析】按钮会弹出如下页面：



![](.\image\201711051509883869899454.png)

![201711051509884252873592 - 副本](.\image\201711051509884252873592 - 副本.png)





主机记录这里选择或者www，记录值就是服务器ip地址，确认



### 服务器绑定域名

##### 登录你的服务器管理面板，我们来绑定域名。如下图所示，这里不多做介绍。 

![201711051509884349350882](C:\Users\Administrator\Desktop\image\201711051509884349350882.png)



![201711051509884349183452](.\image\201711051509884349183452.png)

域名绑定总得来说，就是在域名的设置里把域名指向你主机的IP地址，在主机里再给域名做一个指向就可以了。就像两条电级，连接上了就可以通电了。 



查看本地DNS解析缓存

```
nslooup www.xxx.com
```







# ca证书配置

### Apache

​	前提条件

- 已从[SSL证书控制台](https://yundunnext.console.aliyun.com/?spm=5176.2020520155.aliyun_sidebar.30.25af2a528ujbXD&p=cas#/overview/cn-hangzhou)下载Apache服务器证书。
- 已安装Open SSL。

## 操作步骤

运行以下命令在apache2目录下创建ssl目录。

```
mkdir /etc/apache2/ssl
```

 运行以下命令将下载的阿里云证书文件复制到ssl目录中。 

```
cp -r YourDomainName_public.crt /etc/apache2/ssl
```



```
cp -r YourDomainName_chain.crt /etc/apache2/ssl
```



```
cp -r YourDomainName.key /etc/apache2/ssl
```

运行以下命令启用SSL模块。

```
sudo a2enmod ssl
```

![155177668736989_zh-CN](.\image\155177668736989_zh-CN.png)

SSL模块启用后可执行`ls /etc/apache2/sites-available`查看目录下生成的default-ssl.conf文件。 

```
说明** 443端口是网络浏览端口，主要用于HTTPS服务。SSL模块启用后会自动放行443端口。若443端口未自动放行，可执行 `vi /etc/apache2/ports.conf`并添加 `Listen 443`手动放行。 
```

运行以下命令修改SSL配置文件default-ssl.conf。 

```
vi /etc/apache2/sites-available/default-ssl.conf
```

在 default-ssl.conf文件中找到以下参数进行修改后保存并退出。 

```
<IfModules mod_ssl.c>
<VirtualHost *:443>  
ServerName 
#修改为证书绑定的域名www.YourDomainName.com。
SSLCertificateFile /etc/apache2/www.YourDomainName_public.crt 
#将/etc/apache2/www.YourDomainName.com_public.crt替换为证书文件路径+证书文件名。
SSLCertificateKeyFile /etc/apache2/www.YourDomainName.com.key  
#将/etc/apache2/www.YourDomainName.com.key替换为证书秘钥文件路径+证书秘钥文件名。
SSLCertificateChainFile /etc/apache2/www.YourDomainName.com_chain.crt  
#将/etc/apache2/www.YourDomainName.com_chain.crt替换为证书链文件路径+证书链文件名。
```

![155177668736991_zh-CN](.\image\155177668736991_zh-CN.png)

/sites-available：该目录存放的是可用的虚拟主机；/sites-enabled：该目录存放的是已经启用的虚拟主机。 

```
说明 default-ssl.conf文件可能存放在 /etc/apache2/sites-available或 /etc/apache2/sites-enabled目录中。 
```

运行以下命令把default-ssl.conf映射至/etc/apache2/sites-enabled文件夹中建立软链接、实现二者之间的自动关联。 

```
sudo ln -s /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-enabled/001-ssl.conf
```

 运行以下命令重新加载Apache 2配置文件。 

```
sudo /etc/init.d/apache2 force-reload
```

![155177668736992_zh-CN](.\image\155177668736992_zh-CN.png)

运行以下命令重启Apache 2服务。 

```
sudo /etc/init.d/apache2 restart
```

![155177668736993_zh-CN](.\image\155177668736993_zh-CN.png)







# Nginx	

在证书控制台下载Nginx版本证书。下载到本地的压缩文件包解压后包含：

- **.crt**文件：是证书文件，crt是pem文件的扩展名。
- **.key**文件：证书的私钥文件（申请证书时如果没有选择**自动创建CSR**，则没有该文件）。

**友情提示**： **.pem**扩展名的证书文件采用Base64-encoded的PEM格式**文本文件**，可根据需要修改扩展名。

以Nginx标准配置为例，假如证书文件名是a.pem，私钥文件是a.key。

1. 在Nginx的安装目录下创建cert目录，并且将下载的全部文件拷贝到cert目录中。如果申请证书时是自己创建的CSR文件，请将对应的私钥文件放到cert目录下并且命名为a.key；
2. 打开 Nginx 安装目录下 conf 目录中的 nginx.conf 文件，找到：



```
# HTTPS server
# #server {
# listen 443;
# server_name localhost;
# ssl on;
# ssl_certificate cert.pem;
# ssl_certificate_key cert.key;
# ssl_session_timeout 5m;
# ssl_protocols SSLv2 SSLv3 TLSv1;
# ssl_ciphers ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP;
# ssl_prefer_server_ciphers on;
# location / {
#
#
#}
#}
```



1. 将其修改为 (以下属性中ssl开头的属性与证书配置有直接关系，其它属性请结合自己的实际情况复制或调整) : 

```
server {
 listen 443;
 server_name localhost;
 ssl on;
 root html;
 index index.html index.htm;
 ssl_certificate   cert/a.pem;
 ssl_certificate_key  cert/a.key;
 ssl_session_timeout 5m;
 ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
 ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
 ssl_prefer_server_ciphers on;
 location / {
     root html;
     index index.html index.htm;
 }
}
```



保存退出。

1. 重启 Nginx。





# Tomcat



在证书控制台下载Tomcat版本证书，下载到本地的是一个压缩文件，解压后里面包含.pfx文件是证书文件，pfx_password.txt是证书文件的密码。

**友情提示**： 每次下载都会产生新密码，该密码仅匹配本次下载的证书。如果需要更新证书文件，同时也要更新密码。

申请证书时如果没有选择系统创建CSR，则没有该文件，请选择其它服务器下载.crt文件，利用openssl命令自己生成pfx证书。

## 1、PFX证书安装

以Tomcat7标准配置为例，假如证书文件名是a.pfx。

找到安装Tomcat目录下该文件server.xml,一般默认路径都是在 conf 文件夹中。找到 <Connection port=”8443”标签，增加如下属性：

```
keystoreFile="cert/200613478180598.pfx"
keystoreType="PKCS12"
#此处的证书密码，请参考附件中的密码文件或在第1步中设置的密码
keystorePass="证书密码
```

完整的配置如下，其中port属性根据实际情况修改： 

```
<Connector port="8443"
    protocol="HTTP/1.1"
    SSLEnabled="true"
    scheme="https"
    secure="true"
    keystoreFile="cert/a.pfx"
    keystoreType="PKCS12"
    keystorePass="证书密码"
    clientAuth="false"
    SSLProtocol="TLSv1+TLSv1.1+TLSv1.2"
    ciphers="TLS_RSA_WITH_AES_128_CBC_SHA,TLS_RSA_WITH_AES_256_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256,TLS_RSA_WITH_AES_128_CBC_SHA256,TLS_RSA_WITH_AES_256_CBC_SHA256"/>
```



## 2.JKS证书安装



( 1 ) 使用java jdk将PFX格式证书转换为JKS格式证书(windows环境注意在%JAVA_HOME%/jdk/bin目录下执行) 

```
keytool -importkeystore -srckeystore a.pfx -destkeystore a.jks -srcstoretype PKCS12 -deststoretype JKS

```

回车后输入JKS证书密码和PFX证书密码，强烈推荐将JKS密码与PFX证书密码相同，否则可能会导致Tomcat启动失败。

( 2 ) 找到安装 Tomcat 目录下该文件Server.xml，一般默认路径都是在 conf 文件夹中。找到 <Connection port=”8443”标签，增加如下属性：

```
keystoreFile="cert/a.jks"
keystorePass="证书密码"
```

完整的配置如下，其中port属性根据实际情况修改： 

```
<Connector port="8443"
    protocol="HTTP/1.1"
    SSLEnabled="true"
    scheme="https"
    secure="true"
    keystoreFile="cert/a.jks"
    keystorePass="证书密码"
    clientAuth="false"
    SSLProtocol="TLSv1+TLSv1.1+TLSv1.2"
    ciphers="TLS_RSA_WITH_AES_128_CBC_SHA,TLS_RSA_WITH_AES_256_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256,TLS_RSA_WITH_AES_128_CBC_SHA256,TLS_RSA_WITH_AES_256_CBC_SHA256"/>
```

( 注意:不要直接拷贝所有配置，只需添加 keystoreFile,keystorePass等参数即可，其它参数请根据自己的实际情况修改 )

最后，重启 Tomcat。