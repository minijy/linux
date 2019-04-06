# 搭建分布式缓存(分布式redis集群)



### 搭建redis集群的数量最好是6个及以上

```
各个redis服务器之间的连接采用的是ping-pong机制使每个服务器间互相通信，检测一个节点是否挂掉采用的是节点间的相互检测(相互投票)，当一个节点被该集群中超过半数的节点检测出有问题，即认为该节点挂掉，所以要想投票过半，节点个数至少为3个（当然两个节点亦可以搭建集群，这样高可用性不强，不能采取投票的方式检测节点是否正常工作）
```

###### 【附】因为一般服务器为了数据安全都会采用一个备用服务器（slave），

###### 备用个数至少为一个，所以一共需要6个服务器即使3主3备用。

###### 附（两节点集群检测自身是否挂掉的方法）：

```
当集群中只有两个节点时投票1：1无法通过投票的方式检测，这时候可以借助另外的参考节点，如ping网关（可以是一个节点），可以和测试点ping通，但不可以和对方通，说明对方节点有问题，或本节点有问题；还有就是通过仲裁设备，如仲裁磁盘，每个节点都间隔一定时间不停往磁盘写数据，若监测到对方不再写入的时候，可能对方节点出故障。
```



### 两台服务器，各启动三个实例，形成三主三从

实验机器IP： 172.31.25.110 172.31.25.111

系统环境：centos 7

1、安装所需环境和工具

```
yum -y install wget vim tcl gcc make
```

2、下载redis 压缩包并解压

```
cd /usr/local/
wget http://download.redis.io/releases/redis-3.2.8.tar.gz
tar -zxvf redis-3.2.8.tar.gz
```

3、编译redis源文件

```
cd redis-3.2.8
make

cd src
make install
```



### 测试： make test
（如果 /usr/local/bin/ 文件夹内没有 redis-server 那几个文件，就从 /usr/local/redis-3.2.8/src/ 中拷贝过去，命令：cp redis-server redis-cli redis-sentinel redis-benchmark redis-check-aof redis-check-rdb /usr/local/bin/）


4、配置内核参数
### 配置 vm.overcommit_memory 为1，这可以避免数据被截断
```
sysctl -w vm.overcommit_memory=1
```

5、创建多实例的文件夹，用来存放不同实例的配置文件

```
cd /usr/local/
mkdir cluster
cd cluster
mkdir 7000 7001 7002
```

6、修改配置文件

```
vim /usr/local/redis-3.2.8/redis.conf

bind 172.31.25.110（需要不同服务器的节点连通，就不能设置为 127.0.0.1）
protected-mode no（需要不同服务器的节点连通，这个就要设置为 no）
daemonize yes（设置后台运行redis）
cluster-enabled yes
cluster-node-timeout 5000
appendonly yes
```



### 根据不同端口需要设置的地方
```
port 7000
pidfile /var/run/redis_7000.pid
logfile /var/log/redis/redis_7000.log
dbfilename dump_7000.rdb
appendfilename "appendonly_7000.aof"
cluster-config-file nodes_7000.conf
```


7、复制配置文件到各个实例文件夹，并修改相应端口号和参数

```
cp -f /usr/local/redis-3.2.8/redis.conf /usr/local/cluster/7000/
cp -f /usr/local/redis-3.2.8/redis.conf /usr/local/cluster/7001/
cp -f /usr/local/redis-3.2.8/redis.conf /usr/local/cluster/7002/
```

8、启动各个实例

```
cd /usr/local/redis-3.2.8/src/
./redis-server /usr/local/cluster/7000/redis.conf &
./redis-server /usr/local/cluster/7001/redis.conf &
./redis-server /usr/local/cluster/7002/redis.conf &
```

使用 ps -ef|grep redis 查看是否都启动成功，IP和端口号都正确

9、防火墙开通端口号策略（这里用centos7默认的firewall-cmd）

```
firewall-cmd --zone=public --add-port=7000-7002/tcp --permanent
firewall-cmd --zone=public --add-port=17000-17002/tcp --permanent（必须开集群总线端口，集群总线端口=端口号+10000,例：7000的集群总线端口是17000。这个集群总线端口不开放，集群的时候外部服务器的节点添加不进来）
firewall-cmd --reload
```

### ===========================

### 1~9都是要在两台服务器中操作的 

### ===========================

10、测试两台服务器是否都能 telnet 得通另一台的 7000~7002 和 17000~17002

11、安装 ruby 环境
Redis 3.0以上的集群方式是通过Redis安装目录下的bin/redis-trib.rb脚本搭建。

这个脚本是用Ruby编写的，尝试运行，如果打印如下，你可以跳过本文的第二部分。

复制代码

```
idata@qa-f1502-xg01.xg01:~/yangfan/local/redis-3.2.1/bin$ ruby redis-trib.rb 
Usage: redis-trib <command> <options> <arguments ...>

  create          host1:port1 ... hostN:portN
                  --replicas <arg>
  check           host:port
  info            host:port
  fix             host:port
                  --timeout <arg>
  reshard         host:port
                  --from <arg>
                  --to <arg>
                  --slots <arg>
                  --yes
                  --timeout <arg>
                  --pipeline <arg>
  rebalance       host:port
                  --weight <arg>
                  --auto-weights
                  --use-empty-masters
                  --timeout <arg>
                  --simulate
                  --pipeline <arg>
                  --threshold <arg>
  add-node        new_host:new_port existing_host:existing_port
                  --slave
                  --master-id <arg>
  del-node        host:port node_id
  set-timeout     host:port milliseconds
  call            host:port command arg arg .. arg
  import          host:port
                  --from <arg>
                  --copy
                  --replace
  help            (show this help)

For check, fix, reshard, del-node, set-timeout you can specify the host and port of any working node in the cluster.
```

复制代码
如果执行失败，那么不幸的是你的机器没有Ruby运行的环境，那么你需要安装Ruby。进入第二部分。



2、安装ruby

下面的过程都是在root权限下完成的。

1）yum安装ruby和依赖的包。

```
yum -y install ruby ruby-devel rubygems rpm-build
```

一般来说，这一步是能正常完成的。



2）使用gem这个命令来安装redis接口

gem是ruby的一个工具包

```
gem install redis
```

3）安装gem redis接口，成功！

复制代码

```
gem install redis
Fetching: redis-4.0.1.gem (100%)
Successfully installed redis-4.0.1
Parsing documentation for redis-4.0.1
Installing ri documentation for redis-4.0.1
Done installing documentation for redis after 0 seconds
1 gem installed
```


复制代码


4）安装rubygems，成功！

复制代码
```
yum install -y rubygems
```

```
Loaded plugins: fastestmirror, security
Setting up Install Process
Loading mirror speeds from cached hostfile
base                                                                                                                                                   | 3.7 kB     00:00     
didi_jenkins_enable                                                                                                                                    | 1.5 kB     00:00     
didi_op_toa_enable                                                                                                                                     | 1.5 kB     00:00     
didi_txjenkins_enable                                                                                                                                  | 1.5 kB     00:00     
didi_update                                                                                                                                            | 1.5 kB     00:00     
epel                                                                                                                                                   | 4.3 kB     00:00     
extras                                                                                                                                                 | 3.4 kB     00:00     
tmprepo                                                                                                                                                | 1.5 kB     00:00     
updates                                                                                                                                                | 3.4 kB     00:00     
Package rubygems-1.3.7-5.el6.noarch already installed and latest version
Nothing to do
```


至此，我们的Ruby和运行redis-trib.rb需要的环境安装完成了。 

14、创建集群

```
cd /usr/local/redis-3.2.8/src/ 
./redis-trib.rb create --replicas 1 172.31.25.110:7000 172.31.25.110:7001 172.31.25.110:7002 172.31.25.111:7000 172.31.25.111:7001 172.31.25.111:7002
```

留意屏幕，会有一句（type 'yes' to accept），输入 yes ，回车，就是接受自动分配的三主三从
如果最后出现
```
[OK] All nodes agree about slots configuration.

Check for open slots...
Check slots coverage...
[OK] All 16384 slots covered.
```

说明成功了。

如果是出现
Waiting for the cluster to join...........
一直有 “.”出现，说明另一台服务器的端口策略没通，一直在等那边的节点加入集群，那么恭喜你，要悲剧了.....


15、验证集群节点数

```
cd /usr/local/redis-3.2.8/src/
./redis-cli -h 172.31.25.110 -c -p 7000
```

## **集群关闭**

关闭集群需要逐个关闭

```
for((i=1;i<=6;i++)); do /usr/local/redis/bin/redis-cli -c -h 192.168.2.128 -p 703$i shutdown; done
```

如果重新启动集群报以下错误

```
[ERR] Node 192.168.2.128:7031 is not empty. Either the node already knows other nodes (check with CLUSTER NODES) or contains some key in database 0.
```

需要清除杀掉redis实例，然后删除每个节点下的临时数据文件appendonly.aof，dump.rdb，nodes-703x.conf，然后再重新启动redis实例即可启动集群。

```
for((i=1;i<=6;i++)); do cd 703$i; rm -rf appendonly.aof; rm -rf dump.rdb; rm -rf nodes-703$i.conf; cd ..; done
```



# **Redis集群分区原理**



## **槽(slot)的基本概念**

从上面集群的简单操作中，我们已经知道redis存取key的时候，都要定位相应的槽(slot)。

Redis 集群键分布算法使用数据分片（sharding）而非一致性哈希（consistency hashing）来实现： 一个 Redis 集群包含 16384 个哈希槽（hash slot）， 它们的编号为0、1、2、3……16382、16383，这个槽是一个逻辑意义上的槽，实际上并不存在。redis中的每个key都属于这 16384 个哈希槽的其中一个，存取key时都要进行key->slot的映射计算。

下面我们来看看启动集群时候打印的信息:

 

```
>>> Creating cluster

>>> Performing hash slots allocation on 6 nodes...

Using 3 masters:

192.168.2.128:7031

192.168.2.128:7032

192.168.2.128:7033

Adding replica 192.168.2.128:7034 to 192.168.2.128:7031

Adding replica 192.168.2.128:7035 to 192.168.2.128:7032

Adding replica 192.168.2.128:7036 to 192.168.2.128:7033

M: bee706db5ae182c5be9b9bdf94c2d6f3f8c8ec5c 192.168.2.128:7031

   slots:0-5460 (5461 slots) master

M: 72826f06dbf3be163f2f456ca24caed76a15bdf4 192.168.2.128:7032

   slots:5461-10922 (5462 slots) master

M: ab6e9d1dfc471225eef01e57be563157f81d26b3 192.168.2.128:7033

   slots:10923-16383 (5461 slots) master

......

[OK] All nodes agree about slots configuration.

>>> Check for open slots...

>>> Check slots coverage...

[OK] All 16384 slots covered.
```

从上面信息可以看出，创建集群的时候，哈希槽被分配到了三个主节点上，从节点是没有哈希槽的。7031负责编号为0-5460 共5461个 slots，7032负责编号为 5461-10922共5462 个 slots，7033负责编号为10923-16383 共5461个 slots。

![wps71B9.tmp[4]](https://github.com/minijy/linux/tree/master/markdom/image/783994-20160718161342169-233368796.png) 

## **键-槽映射算法**

和memcached一样，redis也采用一定的算法进行键-槽（key->slot）之间的映射。memcached采用一致性哈希（consistency hashing）算法进行键-节点（key-node）之间的映射，而redis集群使用集群公式来计算键 key 属于哪个槽：

 

```
HASH_SLOT（key）= CRC16(key) % 16384
```

 

其中 CRC16(key) 语句用于计算键 key 的 CRC16 校验和 。key经过公式计算后得到所对应的哈希槽，而哈希槽被某个主节点管理，从而确定key在哪个主节点上存取，这也是redis将数据均匀分布到各个节点上的基础。



## **集群分区好处**

无论是memcached的一致性哈希算法，还是redis的集群分区，最主要的目的都是在移除、添加一个节点时对已经存在的缓存数据的定位影响尽可能的降到最小。redis将哈希槽分布到不同节点的做法使得用户可以很容易地向集群中添加或者删除节点， 比如说：

l 如果用户将新节点 D 添加到集群中， 那么集群只需要将节点 A 、B 、 C 中的某些槽移动到节点 D 就可以了。

l 与此类似， 如果用户要从集群中移除节点 A ， 那么集群只需要将节点 A 中的所有哈希槽移动到节点 B 和节点 C ， 然后再移除空白（不包含任何哈希槽）的节点 A 就可以了。

因为将一个哈希槽从一个节点移动到另一个节点不会造成节点阻塞， 所以无论是添加新节点还是移除已存在节点， 又或者改变某个节点包含的哈希槽数量， 都不会造成集群下线，从而保证集群的可用性。下面我们就来学习下集群中节点的增加和删除。



# **集群操作**

集群操作包括查看集群信息，查看集群节点信息，向集群中增加节点、删除节点，重新分配槽等操作。

## **查看集群信息**

cluster info 查看集群状态，槽分配，集群大小等，cluster nodes也可查看主从节点。

 

```
192.168.2.128:7031> cluster info

cluster_state:ok

cluster_slots_assigned:16384

cluster_slots_ok:16384

cluster_slots_pfail:0

cluster_slots_fail:0

cluster_known_nodes:6

cluster_size:3

cluster_current_epoch:6

cluster_my_epoch:1

cluster_stats_messages_sent:119

cluster_stats_messages_received:119

192.168.2.128:7031>
```



## **新增节点**

（1）新增节点配置文件

执行下面的脚本创建脚本配置文件

 

```
mkdir /usr/local/redis-cluster/7037 && cp /usr/local/redis-cluster/7031/redis.conf /usr/local/redis-cluster/7037/redis.conf && sed -i "s/7031/7037/g" /usr/local/redis-cluster/7037/redis.conf
```

 

（2）启动新增节点

 

```
/usr/local/redis/bin/redis-server /usr/local/redis-cluster/7037/redis.conf
```

 

（3）添加节点到集群

现在已经添加了新增一个节点所需的配置文件，但是这个这点还没有添加到集群中，现在让它成为集群中的一个主节点

 

```
cd /usr/local/redis/bin/

./redis-trib.rb add-node 192.168.2.128:7037 192.168.2.128:7036

>>> Adding node 192.168.2.128:7037 to cluster 192.168.2.128:7036

>>> Performing Cluster Check (using node 192.168.2.128:7036)

S: 2c8d72f1914f9d6052065f7e9910cc675c3c717b 192.168.2.128:7036

   slots: (0 slots) slave

   replicates 6dbb4aa323864265c9507cf336ef7d3b95ea8d1b

M: 6dbb4aa323864265c9507cf336ef7d3b95ea8d1b 192.168.2.128:7033

   slots:10923-16383 (5461 slots) master

   1 additional replica(s)

S: 791a7924709bfd7ef5c36d9b9c838925e41e3c2e 192.168.2.128:7034

   slots: (0 slots) slave

   replicates d9e3c78a7c49689c29ab67a8a17be9d95cb08452

M: d9e3c78a7c49689c29ab67a8a17be9d95cb08452 192.168.2.128:7031

   slots:0-5460 (5461 slots) master

   1 additional replica(s)

M: 69b63d8db629fa8a689dd1ed25ed941c076d4111 192.168.2.128:7032

   slots:5461-10922 (5462 slots) master

   1 additional replica(s)

S: e669a91866225279aafcac29bf07b826eb5be91c 192.168.2.128:7035

   slots: (0 slots) slave

   replicates 69b63d8db629fa8a689dd1ed25ed941c076d4111

[OK] All nodes agree about slots configuration.

>>> Check for open slots...

>>> Check slots coverage...

[OK] All 16384 slots covered.

>>> Send CLUSTER MEET to node 192.168.2.128:7037 to make it join the cluster.

[OK] New node added correctly.
```

 

./redis-trib.rb add-node 命令中，7037 是新增的主节点，7036 是集群中已有的从节点。再来看看集群信息

 

```
192.168.2.128:7031> cluster info

cluster_state:ok

cluster_slots_assigned:16384

cluster_slots_ok:16384

cluster_slots_pfail:0

cluster_slots_fail:0

cluster_known_nodes:7

cluster_size:3

cluster_current_epoch:6

cluster_my_epoch:1

cluster_stats_messages_sent:11256

cluster_stats_messages_received:11256
```

 

![img](https://images2015.cnblogs.com/blog/783994/201607/783994-20160718161934497-973141123.png)

 

（4）分配槽

从添加主节点输出信息和查看集群信息中可以看出，我们已经成功的向集群中添加了一个主节点，但是这个主节还没有成为真正的主节点，因为还没有分配槽（slot），也没有从节点，现在要给它分配槽（slot）

 

```
./redis-trib.rb reshard 192.168.2.128:7031

> > > Performing Cluster Check (using node 192.168.2.128:7031)

M: 1a544a9884e0b3b9a73db80633621bd90ceff64a 192.168.2.128:7031

   ......

[OK] All nodes agree about slots configuration.

>>> Check for open slots...

>>> Check slots coverage...

[OK] All 16384 slots covered.

How many slots do you want to move (from 1 to 16384)? 1024

What is the receiving node ID?
```

 

系统提示要移动多少个配槽（slot）,并且配槽（slot）要移动到哪个节点，任意输入一个数，如1024，再输入新增节点的ID cf48228259def4e51e7e74448e05b7a6c8f5713f.

 

```
What is the receiving node ID? cf48228259def4e51e7e74448e05b7a6c8f5713f

Please enter all the source node IDs.

  Type 'all' to use all the nodes as source nodes for the hash slots.

  Type 'done' once you entered all the source nodes IDs.
```

 

然后提示要从哪几个节点中移除1024个槽（slot），这里输入‘all’表示从所有的主节点中随机转移，凑够1024个哈希槽，然后就开始从新分配槽（slot）了。从新分配完后再次查看集群节点信息

 

![img](https://github.com/minijy/linux/tree/master/markdom/image/783994-20160718162024513-300521558.png)

 

可见，0-340 5461-5802 10923-11263的槽（slot）被分配给了新增加的节点。三个加起来刚好1024个槽（slot）。

（5）指定从节点

现在从节点7036的主节点是7033，现在我们要把他变为新增加节点（7037）的从节点，需要登录7036的客户端

```
/usr/local/redis/bin/redis-cli -c -h 192.168.2.128 -p 7036

192.168.2.128:7036> cluster replicate cf48228259def4e51e7e74448e05b7a6c8f5713f

OK
```

 

再来查看集群节点信息

 

![img](https://github.com/minijy/linux/tree/master/markdom/image/783994-20160718162059263-2014665027.png)

 

可见，7036成为了新增节点7037的从节点。

## **删除节点**

指定删除节点的ID即可，如下



```
./redis-trib.rb del-node 192.168.2.128:7037 'a56461a171334560f16652408c2a45e629d268f6'

>>> Removing node a56461a171334560f16652408c2a45e629d268f6 from cluster 192.168.2.128:7037

>>> Sending CLUSTER FORGET messages to the cluster...

>>> SHUTDOWN the node.
```

## **集群操作小结**

从上面过程可以看出，添加节点、分配槽、删除节点的过程，不用停止集群，不阻塞集群的其他操作。命令小结

 

\#向集群中添加节点，7037是新增节点，7036是集群中已有的节点

```
./redis-trib.rb add-node 192.168.2.128:7037 192.168.2.128:7036
```

\#重新分配槽

```
./redis-trib.rb reshard 192.168.2.128:7031
```

\#指定当前节点的主节点

```
cluster replicate cf48228259def4e51e7e74448e05b7a6c8f5713f
```

\#删除节点

```
./redis-trib.rb del-node 192.168.2.128:7037 'a56461a171334560f16652408c2a45e629d268f6'
```

