

### 开发人员常用linunx指令



##### 1. 重定向命令：>

```
如：ls > test.txt 
```

##### 2. 查看或者合并文件内容：cat

```
cat t1.txt t2.txt > t3.txt
```

##### 3. 分屏显示：more

```
more t.txt
```

##### 4. 管道：|

```
ps aux | grep mysql
```

##### 5. 建立链接文件：ln

```
ln 源文件 链接文件
ln -s 源文件 链接文件

如果没有-s选项代表建立一个硬链接文件，两个文件占用相同大小的硬盘空间，即使删除了源文件，链接文件还是存在，所以-s选项是更常见的形式。
```

##### 6. 文本搜索：grep

```
grep [-选项] ‘搜索内容串’文件名

grep 'a' 1.txt
```

常用选项说明：

| 选项 | 含义                                     |
| ---- | ---------------------------------------- |
| -v   | 显示不包含匹配文本的所有行（相当于求反） |
| -n   | 显示匹配行及行号                         |
| -i   | 忽略大小写                               |

grep常用正则表达式：

| 参数         | 含义                                                         |
| ------------ | ------------------------------------------------------------ |
| ^a           | 行首,搜寻以 m 开头的行；grep -n '^a' 1.txt                   |
| ke$          | 行尾,搜寻以 ke 结束的行；grep -n 'ke$' 1.txt                 |
| [Ss]igna[Ll] | 匹配 [] 里中一系列字符中的一个；搜寻匹配单词signal、signaL、Signal、SignaL的行；grep -n '[Ss]igna[Ll]' 1.txt |
| .            | (点)匹配一个非换行符的字符；匹配 e 和 e 之间有任意一个字符，可以匹配 eee，eae，eve，但是不匹配 ee，eaae；grep -n 'e.e' 1.txt |

##### 7. 查找文件：find

```
find ./ -name test.sh 

find ./ -name '*.sh'

find ./ -name "[A-Z]*"
```

常用用法：

| 命令                   | 含义                                   |
| ---------------------- | -------------------------------------- |
| find ./ -name test.sh  | 查找当前目录下所有名为test.sh的文件    |
| find ./ -name '*.sh'   | 查找当前目录下所有后缀为.sh的文件      |
| find ./ -name "[A-Z]*" | 查找当前目录下所有以大写字母开头的文件 |

##### 8. 通配符

> **通配符是一种特殊字符，用来模糊搜索文件。**

统配字符注意有

- *：代表0个或多个任意字符
- ?：代表任意一个字符
- [列举的字符]：代表的任意一个字符

举例

- find . -name *.txt
- ls 1?3.txt

**小结: ls, find命令一般会结合通配符使用**

##### 9. 打包及压缩：tar

计算机中的数据经常需要备份，tar是Unix/Linux中最常用的备份工具，此命令可以把一系列文件归档到一个大文件中，也可以把档案文件解开以恢复数据。

tar使用格式 tar [选项] 打包文件名 文件

常用参数：

| 选项 | 含义                                                      |
| ---- | --------------------------------------------------------- |
| -c   | 生成档案文件，创建打包文件                                |
| -v   | 列出归档解档的详细过程，显示进度                          |
| -f   | 指定档案文件名称，f后面一定是.tar文件，所以必须放选项最后 |
| -x   | 解开档案文件                                              |
| -z   | 压缩                                                      |

**注意：除了f需要放在参数的最后，其它参数的顺序任意。**



##### 1> gz压缩格式

**压缩用法：tar -zcvf 压缩包包名 文件1 文件2 ...**

```
-z:指定压缩包的格式为：file.tar.gz
```



**解压用法： tar -zxvf 压缩包包名**

```
-z:指定压缩包的格式为：file.tar.gz
```



**解压到指定目录：-C （大写字母“C”）**



##### 2> bz2压缩格式

- 压缩用法： **tar -jcvf 压缩包包名 文件**
- 解压用法： **tar -jxvf 压缩包包名**

##### 3> zip压缩格式

**通过zip压缩文件的目标文件不需要指定扩展名，默认扩展名为zip。**

压缩文件：zip 目标文件(没有扩展名) 源文件

解压文件：unzip -d 解压后目录文件 压缩文件



##### 10. 修改文件权限：chmod

chmod 修改文件权限有两种使用格式：字母法与数字法。

字母法：chmod u/g/o/a +/-/= rwx 文件

| [ u/g/o/a ] | 含义                                                      |
| ----------- | --------------------------------------------------------- |
| u           | user 表示该文件的所有者                                   |
| g           | group 表示与该文件的所有者属于同一组( group )者，即用户组 |
| o           | other 表示其他以外的人                                    |
| a           | all 表示这三者皆是                                        |

| [ +-= ] | 含义     |
| ------- | -------- |
| +       | 增加权限 |
| -       | 撤销权限 |
| =       | 设定权限 |

| rwx  | 含义                                                         |
| ---- | ------------------------------------------------------------ |
| r    | read 表示可读取，对于一个目录，如果没有r权限，那么就意味着不能通过ls查看这个目录的内容。 |
| w    | write 表示可写入，对于一个目录，如果没有w权限，那么就意味着不能在目录下创建新的文件。 |
| x    | excute 表示可执行，对于一个目录，如果没有x权限，那么就意味着不能通过cd进入这个目录。 |



**如果需要同时进行设定拥有者、同组者以及其他人的权限，参考如下：**



数字法：“rwx” 这些权限也可以用数字来代替

| 字母 | 说明                         |
| ---- | ---------------------------- |
| r    | 读取权限，数字代号为 "4"     |
| w    | 写入权限，数字代号为 "2"     |
| x    | 执行权限，数字代号为 "1"     |
| -    | 不具任何权限，数字代号为 "0" |

如执行：chmod u=rwx,g=rx,o=r filename 就等同于：chmod u=7,g=5,o=4 filename

chmod 751 file：

- 文件所有者：读、写、执行权限
- 同组用户：读、执行的权限
- 其它用户：执行的权限

**注意：如果想递归所有目录加上相同权限，需要加上参数“ -R ”。 如：chmod 777 test/ -R 递归 test 目录下所有文件加 777 权限**

##### 11. 查看命令位置：which

which cd 是查看不了命令所在目录，原因是 



Linux命令是分为内置命令和外部命令

1. 内置命令是在系统启动时就载入内存执行效率高
2. 外面命令是系统的软件功能，需要时载入内存

##### 12. 切换到管理员账号：sudo -s

Ubuntu下切换到root的简单命令:

 **提示: 一般不需要切换到管理员账户，需要使用管理员权限在命令前面加上sudo**

##### 13. 查看当前用户：whoami

查看当前用户命令是 **whoami** 

##### 14. 设置用户密码：passwd

在Unix/Linux中，超级用户可以使用passwd命令为普通用户设置或修改用户密码。用户也可以直接使用该命令来修改自己的密码，而无需在命令后面使用用户名。

##### 15. 退出登录账户： exit

- 如果是图形界面，退出当前终端；
- 如果是使用ssh远程登录，退出登陆账户；
- 如果是切换后的登陆用户，退出则返回上一个登陆账号。

##### 16. 查看所有的登录用户：who

who命令用于查看当前所有登录系统的用户信息。

##### 17. 关机重启：reboot、shutdown

| 命令              | 含义                                       |
| ----------------- | ------------------------------------------ |
| reboot            | 重新启动操作系统                           |
| shutdown –r now   | 重新启动操作系统，shutdown会给别的用户提示 |
| shutdown -h now   | 立刻关机，其中now相当于时间为0的状态       |
| shutdown -h 20:25 | 系统在今天的20:25 会关机                   |
| shutdown -h +10   | 系统再过十分钟后自动关机                   |

# 运维人员常用指令

##### 1、linux启动过程

```
开启电源 --> BIOS开机自检 --> 引导程序lilo或grub--> 内核的引导（kernel boot）--> 执行init（rc.sysinit、rc）--> mingetty(建立终端) -->Shell
```

##### 2、网卡绑定多ip

```
ifconfig eth0:1 192.168.1.99 netmask 255.255.255.0
```

##### 3、设置DNS、网关

```
echo "nameserver 202.16.53.68" >> /etc/resolv.conf

route add default gw 192.168.1.1
```

##### 4、弹出、收回光驱

```
eject

eject -t
```

##### 5、用date查询昨天的日期

```
date --date=yesterday
```

##### 6、查询file1里面空行的所在行号

```
grep ^$ file
```

##### 7、查询file1以abc结尾的行

```
grep abc$ file1
```

##### 8、打印出file1文件第1到第三行

```
sed -n '1,3p' file1

head -3 file1
```

##### 9、清空文件

```
true > 1.txt

echo "" > 1.txt

> 1.txt

cat /dev/null > 1.txt
```

##### 10、删除所有空目录

```
find /data -type d -empty -exec rm -rf {} ;
```

##### 11、linux下批量删除空文件（大小等于0的文件）的方法

```
find /data -type f -size 0c -exec rm -rf {} ;

find /data -type f -size 0c|xargs rm –f
```

##### 12、删除五天前的文件

```
find /data -mtime +5 -type f -exec rm -rf {} ;
```

##### 13、删除两个文件重复的部份，打印其它

```
cat 1.txt 3.txt |sort |uniq
```

##### 14、攻取远程服务器主机名

```
echo `ssh $IP cat /etc/sysconfig/network|awk -F = '/hostname/ {print $2}'`
```

##### 15、实时监控网卡流量（安装iftop）

```
/usr/local/iftop/sbin/iftop -i eth1 -n
```

##### 16、查看系统版本

```
lsb_release -a
```

##### 17、强制踢出登陆用户

```
pkill -kill -t pts/1
```

##### 18、tar增理备份、还原

```
tar -g king -zcvf kerry_full.tar.gz kerry

tar -g king -zcvf kerry_diff_1.tar.gz kerry

tar -g king -zcvf kerry_diff_2.tar.gz kerry

tar -zxvf kerry_full.tar.gz

tar -zxvf kerry_diff_1.tar.gz

tar -zxvf kerry_diff_2.tar.gz
```

##### 19、将本地80端口的请求转发到8080端口，当前主机外网IP为202.96.85.46

```
-A PREROUTING -d 202.96.85.46 -p tcp -m tcp --dport 80 -j DNAT --to-destination 192.168.9.10:8080
```

##### 20、在11月份内，每天的早上6点到12点中，每隔2小时执行一次/usr/bin/httpd.sh

```
crontab -e0 6-12/2 * 11 * /usr/bin/httpd.sh
```

##### 21、查看占用端口8080的进程

```
netstat -tnlp | grep 8080lsof -i:8080
```



##### 22、在Shell环境下,如何查看远程Linux系统运行了多少时间?

```
ssh user@被监控主机ip "uptime"
```

##### 23、查看CPU使用情况的命令

##### 每5秒刷新一次，最右侧有CPU的占用率的数据

```
vmstat 5 top 然后按Shift+P，按照进程处理器占用率排序
top
```

##### 24、查看内存使用情况的命令 

```
用free命令查看内存使用情况 # free -mtop 然后按Shift+M, 按照进程内存占用率排序 # top 
```

##### 25、查看磁盘i/o 

```
用iostat查看磁盘/dev/sdc3的磁盘i/o情况，每两秒刷新一次 # iostat -d -x /dev/sdc3 2 
```

##### 26、修复文件系统 

```
fsck –yt ext3 / -t 指定文件系统 -y 对发现的问题自动回答yes 
```

##### 27、read命令5秒后自动退出   

```
 read -t 5 
```

##### 28、grep -E -P 是什么意思 -E, --extended-regexp 采用扩展正规表达式。    

```
-P，--perl-regexp 采用perl正规表达式 
```

##### 29、vi编辑器(涉及到修改，添加，查找) 插入(insert)模式 i　　　　    

```
光标前插入 I　　　　 光标行首插入 a　　　　 光标后插入 A　　　　 光标行尾插入 o　　　　 光标所在行下插入一行，行首插入 O　　　　 光标所在行上插入一行，行首插入 G　　　　 移至最后一行行首 nG　　　　移至第n行行首 n+　　　　下移n行，行首 n-　　　　上移n行，行首 :/str/　　　　　　　　　　从当前往右移动到有str的地方 :?str?　　　　　　　　　　从当前往左移动到有str的地方 :s/str1/str2/　　　　　 　将找到的第一个str1替换为str2　　 :s/str2/str2/g　　　　　　将当前行找到的所有str1替换为str2 :n1,n2s/str1/str2/g　　　 将从n1行至n2行找到的所有的str1替换为str2 :1,.s/str1/str2/g　　　　 将从第1行至当前行的所有str1替换为str2 :.,$s/str1/str2/g　　　　 将从当前行至最后一行的所有str1替换为str2 
```

##### 30、linux服务器之间相互复制文件    

```
copy 本地文件1.sh到远程192.168.9.10服务器的/data/目录下 
scp /etc/1.sh king@192.168.9.10:/data/copy远程192.168.9.10服务器/data/2.sh文件到本地/data/目录
scp king@192.168.9.10:/data/2.sh /data/
```

##### 31、使用sed命令把test.txt文件的第23行的TEST换成TSET.

```
sed -i '23s/TEST/TSET/' test.txt

sed -i '23 s/TEST/TSET/' test.txt
```

##### 32、使history命令能显示时间

```
export HISTTIMEFORMAT="%F %T "
```

33、如何查看目标主机192.168.0.1开放那些端口
```
nmap -ps 192.168.0.1
```

##### 34、如何查看网络连接

```
netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'
```

##### 35、如何查看当前系统使用了那些库文件

```
ldconfig -v
```

##### 36、如何查看网卡的驱动版本

```
ethtool -i eth0
```

##### 37、使用tcpdump来监视主机192.168.0.1的tcp的80端口

```
tcpdump tcp port 80 host 192.168.0.1
```

##### 38、 如何看其它用户的邮件列表

```
mial -u king
```

39、对大文件进行切割

##### 按每个文件1000行来分割

```
split -l 1000 httperr8007.log httperr
按照每个文件5m来分割
split -b 5m httperr8007.log httperr
```

##### 40、合并文件

```
取出两个文件的并集(重复的行只保留一份)
cat file1 file2 | sort | uniq

取出两个文件的交集(只留下同时存在于两个文件中的文件)
cat file1 file2 | sort | uniq -d
删除交集，留下其他的行
cat file1 file2 | sort | uniq –u
```

##### 41、打印文本模式下运行的服务

```
chkconfig --list|awk '$5~/on/{print $1,$5}'
```

##### 42、删除0字节文件

```
find -type f -size 0 -exec rm -rf {} ;
```

##### 43、查看进程，按内存从大到小排列

```
ps -e -o "%C : %p : %z : %a"|sort -k5 -nr
```

##### 44、查看http的并发请求数及其TCP连接状态

```
netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'
```

##### 45、获取IP地址

```
ifconfig eth0|sed -n '2p'|awk '{print $2}'|cut -c 6-30
```



##### 47、查看CPU核心数 

```
cat /proc/cpuinfo |grep -c processor
```

#####  48、查看磁盘使用情况

```
df -h
```

##### 49、查看有多少个活动的PHP-cgi进程 

```
netstat -anp | grep php-cgi | grep ^tcp | wc -l
```

##### 50、查看硬件制造商 

```
dmidecode -s system-product-name
```

