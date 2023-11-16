#!/bin/bash



front_dev_operation(){
 if [[ -n $(docker ps -aq -f "name=^anxin_app_dev $") ]];then
    docker stop anxin_app_dev
    docker rm -f anxin_app_dev 
  fi
    docker pull registry.cn-chengdu.aliyuncs.com/dream0206/anxin-app-dev:${BUILD_NUMBER}
    docker run --name=anxin_app_dev -d  -p 59999:9999 registry.cn-chengdu.aliyuncs.com/dream0206/anxin-app-dev:${BUILD_NUMBER}
}

front_main_operation(){
  if [[ -n $(docker ps -aq -f "name=^anxin_app $") ]];then
    docker stop anxin_app
    docker rm -f anxin_app 
  fi
    docker pull registry.cn-chengdu.aliyuncs.com/dream0206/anxin-app:${BUILD_NUMBER}
    docker run --name=anxin_app -d  -p 9999:9999 registry.cn-chengdu.aliyuncs.com/dream0206/anxin-app:${BUILD_NUMBER}
}

admin_dev_operation(){
    if [[ -n $(docker ps -aq -f "name=^anxin_admin_dev $") ]];then
    docker stop anxin_admin_dev 
    docker rm -f anxin_admin_dev 
    fi

    docker pull registry.cn-chengdu.aliyuncs.com/dream0206/anxin-admin-dev:${BUILD_NUMBER}
    docker run --name=anxin_admin_dev -d  -p 58888:8888 registry.cn-chengdu.aliyuncs.com/dream0206/anxin-admin-dev:${BUILD_NUMBER}
}

admin_main_operation(){

    if [[ -n $(docker ps -aq -f "name=^anxin_admin $") ]];then
    docker stop anxin_admin
    docker rm -f anxin_admin 
    fi

    docker pull registry.cn-chengdu.aliyuncs.com/dream0206/anxin-admin:${BUILD_NUMBER}
    docker run --name=anxin_admin_dev -d  -p 8888:8888 registry.cn-chengdu.aliyuncs.com/dream0206/anxin-admin:${BUILD_NUMBER}

}





# 检查 MODULES 和 DEPLOYTO 环境变量的值组合
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
