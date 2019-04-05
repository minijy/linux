#!/bin/bash


REMOTE_ACCOUNT=python
REMOTE_IP=192.168.203.140
REMOTE_DIR=/home/python/Desktop

LOCAL_DIR=${HOME}/Desktop/sz21/day03

LOCK_FILE=/tmp/deploy.pid

LOG_FILE=deploy.log

write_log() {
    # 日期、时间、步骤
    DATE=`date +%F`
    TIME=$(date +%T)
    step=$1
    
    echo "${DATE} ${TIME} ${step}" >> ${LOCAL_DIR}/data/logs/${LOG_FILE}
}

# 获得代码
get_code() {
    echo "获得代码"
    write_log "获得代码"
}


# 打包代码
tar_code() {
    echo "打包代码"

    # 打包代码仓库中的代码
    # 远程调用代码仓库中的打包脚本
    ssh ${REMOTE_ACCOUNT}@${REMOTE_IP} "/bin/bash ${REMOTE_DIR}/data/scripts/tar_code.sh"
}

# 传输代码
scp_code() {
    echo "传输代码"

    # 本地服务器找代码仓库拿代码
    scp ${REMOTE_ACCOUNT}@${REMOTE_IP}:${REMOTE_DIR}/data/django.tar.gz ${LOCAL_DIR}/data/codes
}

# 停止应用
stop_serv() {
    echo "停止应用"


    echo "stop nginx"
    sudo ${LOCAL_DIR}/data/server/nginx/sbin/nginx -s stop

    echo "stop django"
    kill -kill $(lsof -Pti :8000)
}

# 解压代码
untar_code() {
    echo "解压代码"

    # 进入代码文件夹　ｃｏｄｅｓ
    cd ${LOCAL_DIR}/data/codes
    [ -f django.tar.gz ] && tar -zxf django.tar.gz
}

# 放置代码
place_code() {
    echo "放置代码"


    # 备份旧代码
    mv ${LOCAL_DIR}/data/server/itcast/test1/views.py ${LOCAL_DIR}/data/backup/views-`date +%Y%m%d%H%M%S`.py

    # 放置新代码
    cp ${LOCAL_DIR}/data/codes/django/views.py ${LOCAL_DIR}/data/server/itcast/test1
}


# 开启应用
start_serv() {
    echo "开启应用"

    echo "start django"
    source ${LOCAL_DIR}/data/virtual/venv/bin/activate
    cd ${LOCAL_DIR}/data/server/itcast
    python3 manage.py runserver >> /dev/null 2>&1 &
    deactivate

    echo "start nginx"
    sudo ${LOCAL_DIR}/data/server/nginx/sbin/nginx
}

# 检查效果
check() {
    echo "检查"

    netstat -tnulp | grep ':80'
}

deploy_pro() {
    get_code
    tar_code
    scp_code
    stop_serv
    untar_code
    place_code
    start_serv
    check
}

main() {
    
    # 检查锁文件
    if [ -f ${LOCK_FILE} ]
    then
        echo "锁文件存在，退出程序"
    else
        sudo touch ${LOCK_FILE}
        deploy_pro
        sudo rm -rf ${LOCK_FILE}
    fi
}

usage() {
    echo "脚本 $0 的使用方式： deploy.sh [ deploy ]"
}

# 脚本参数个数的判断
if [ $# -eq 1 ]
then
    case $1 in
        "deploy")
            main
            ;;
        *)
            usage
            ;;
    esac

else
    usage
fi






