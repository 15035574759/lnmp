#!/bin/bash
lnmp() {
    docker pull centos:7
    docker-compose -f docker_lnmpr.yml up -d lnmp
}

if [[ ${1} == 'lnmp' ]]; then
    echo "lnmp start..."
    redis
fi

echo "success"
