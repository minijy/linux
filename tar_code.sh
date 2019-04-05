#!/bin/bash


CODE_DIR=${HOME}/Desktop
FILE=django.tar.gz
CODE_NAME=django

tar_code() {
    # 打包文件
    cd ${CODE_DIR}/data
    # 如果存在则删除压缩包
    if [ -f ${FILE} ]
    then
        rm -rf ${FILE}
    fi


    # [ -f ${FILE} ] && rm -rf ${FILE}


    tar -zcf ${FILE} ${CODE_NAME}
}

tar_code





