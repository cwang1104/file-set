#!/bin/bash

git_dev(){
    git checkout dev
}

git_prod(){
    git checkout main
}

front_dev_operation(){
    docker build -f app/front/api/dockerfile -t registry.cn-chengdu.aliyuncs.com/dream0206/anxin-app-dev:${BUILD_NUMBER} . 
    docker push registry.cn-chengdu.aliyuncs.com/dream0206/anxin-app-dev:${BUILD_NUMBER}
}

front_main_operation(){
    docker build -f app/front/api/dockerfile -t registry.cn-chengdu.aliyuncs.com/dream0206/anxin-app:${BUILD_NUMBER} . 
    docker push registry.cn-chengdu.aliyuncs.com/dream0206/anxin-app:${BUILD_NUMBER}
}

admin_dev_operation(){
    docker build -f app/admin/api/dockerfile -t registry.cn-chengdu.aliyuncs.com/dream0206/anxin-admin-dev:${BUILD_NUMBER} . 
    docker push registry.cn-chengdu.aliyuncs.com/dream0206/anxin-admin-dev:${BUILD_NUMBER}
}

admin_main_operation(){
    docker build -f app/admin/api/dockerfile -t registry.cn-chengdu.aliyuncs.com/dream0206/anxin-admin:${BUILD_NUMBER} . 
    docker push registry.cn-chengdu.aliyuncs.com/dream0206/anxin-admin:${BUILD_NUMBER}
}



# 检查 DEPLOY_TO 环境变量的值
case "$DEPLOYTO" in
  "dev")
    git_dev
    
    ;;
  "prod")
    echo "Performing operation for prod environment"
    git_prod
    ;;
  *)
    echo "Unknown DEPLOY_TO value: $DEPLOYTO"
    exit 1
    ;;
esac


# 检查 MODULES 和 DEPLOY_TO 环境变量的值组合
case "$MODULES-$DEPLOYTO" in
  "all-dev")
    echo "Performing operation for all modules in dev environment"
    front_dev_operation
    admin_dev_operation
    ;;
  "all-prod")
    echo "Performing operation for all modules in prod environment"
    admin_main_operation
    front_main_operation
    ;;
  "front-dev")
    echo "Performing operation for front module in dev environment"
    front_dev_operation
    ;;
  "front-prod")
    echo "Performing operation for front module in prod environment"
    front_main_operation
    ;;
  "admin-dev")
    echo "Performing operation for admin module in dev environment"
    admin_dev_operation
    ;;
  "admin-prod")
    echo "Performing operation for admin module in prod environment"
    admin_main_operation
    ;;
  *)
    echo "Unknown combination of MODULES ($MODULES) and DEPLOY_TO ($DEPLOYTO)"
    exit 1
    ;;
esac
