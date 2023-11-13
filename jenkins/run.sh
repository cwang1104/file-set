echo "当前部署镜像：${LOCATION}"


docker pull ${LOCATION}


if [[ -n $(docker ps -aq -f "name=^moyopecker$") ]];then
    docker stop moyopecker
    echo "----stop old----"
    docker rm -f moyopecker
    echo "----remove old----"
fi

echo "--start run ---"
docker run --name=tttttt -d  -p 62001:62001 ${LOCATION}

docker run --name=moyopecker -d  -p 62001:62001 --net roman_net -v /home/centos/roman:/pecker/log ${LOCATION}


current_time=$(date +"%Y-%m-%d-%H-%M-%S")
export DATA_TIME=${current_time}
echo "start docker build --> $current_time"
docker build -t registry.cn-chengdu.aliyuncs.com/dream0206/ttnew:$current_time .
echo "docker build success"
echo "docker push start"
docker push registry.cn-chengdu.aliyuncs.com/dream0206/ttnew:$current_time
export LOCATION=registry.cn-chengdu.aliyuncs.com/dream0206/ttnew:$current_time
echo "docker push success"