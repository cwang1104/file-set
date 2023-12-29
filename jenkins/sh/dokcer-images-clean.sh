docker images --format "{{.Repository}}:{{.Tag}}" | \
  grep 'registry.cn-chengdu.xx.com/xx/xx-xx' | \
  awk -F':' '$2 < 47 {print $1":"$2}' | \
  xargs -I {} docker rmi {}
