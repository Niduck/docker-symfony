#!/bin/bash

cecho() {
  echo "$1"
}
#Get vars from .env file
DIR="$(cd "$(dirname "$0")" && pwd)"
. ${DIR}/../.env
if [ ! -f "$1" ]; then
  file=${DIR}/../"compose-dev.yaml"
else
  file="$1"

fi
cecho "\033[34mBUILDING ${DOCKER_CONTAINERS_PREFIX} : \033[0m"
cecho "\rCreating cache folder..."
mkdir -p ${DIR}/../.cache
cecho "\rBuilding docker..."

docker compose -f $file -p "${DOCKER_CONTAINERS_PREFIX}" build >> /dev/null
#Run - app with specified prefix in detached mode
{
  #TRY
  docker compose -f $file -p "${DOCKER_CONTAINERS_PREFIX}" up -d >> /dev/null
} || {
  #CATCH
  cecho "\033[31m Error ${DOCKER_CONTAINERS_PREFIX}... \033[0m"
  cecho "\r \033[41;30m docker compose -f $file -p "${DOCKER_CONTAINERS_PREFIX}" up -d \033[0m - maybe you have somes services running which can be in conflict with this app"
  exit
}

######################################
# NGINX CONFIGURATION
INSPECT_FORMAT="{{.NetworkSettings.Networks.${DOCKER_CONTAINERS_PREFIX}_dockernetwork.IPAddress}}"
NGINX_IP_ADDRESS=$(docker inspect --format ${INSPECT_FORMAT} $(docker ps -f name=nginx -q))
COMPARABLE_NGINX_IP_ADDRESS="_${NGINX_IP_ADDRESS}_"
CURRENT_HOST="$(sed -n "/${SYMFONY_APP_HOST}/p" /etc/hosts)"
if [ "${COMPARABLE_NGINX_IP_ADDRESS}" = "_<no value>_" ]; then
  NGINX_IP_ADDRESS='127.0.0.1'
fi
NEW_HOST="${NGINX_IP_ADDRESS} ${SYMFONY_APP_HOST}"

while true; do
    read -p "Do you wish to write the /etc/hosts file with  : '${NEW_HOST}' ?" yn
    case $yn in
        [Yy]* )
              if [ -z "$CURRENT_HOST" ]; then #add $NGINX_IP_ADDRESS $SYMFONY_APP_HOST in /etc/hosts file
                sudo sed -i -e "\$a${NEW_HOST}" /etc/hosts
              else #replace existing $SYMFONY_APP_HOST ip by $NGINX_IP_ADDRESS in /etc/hosts file
                sudo sed -i -r "s/${CURRENT_HOST}/${NEW_HOST}/" /etc/hosts
              fi
              cecho "\r\033[32mWrited in /etc/hosts : ${NEW_HOST}\033[0m"
          break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
