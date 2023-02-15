#!/usr/bin/env bash

#
# File used quick lauch some functions
# we do not use makefile beceause .env file which contains all vars cannot be imported in makefile
#
DIR="$(cd "$(dirname "$0")" && pwd)"
. ${DIR}/../.env
export UID

help() {
  echo "project: \033[31m ${DOCKER_CONTAINERS_PREFIX} \033[0m"
  echo "base command: \033[33m docker-compose -f ${DOCKER_COMPOSE_FILE} -p "${DOCKER_CONTAINERS_PREFIX}" \033[0m"
  echo " \033[33mdocker\033[0m"
  echo "   \033[32mbuild\033[0m                                Build the projet (up + write domain in /etc/hosts)"
  echo "   \033[32mup\033[0m                                   Start or creates all containers for current project"
  echo "   \033[32mstop\033[0m                                 Stop all containers for current project"
  echo "   \033[32mrestart\033[0m                              Restart all containers for current project"
  echo " \033[33mbash\033[0m"
  echo "   \033[32mphp\033[0m                                  Execute php container bash"
  echo "   \033[32mdb\033[0m                                   Execute db container bash"
  echo "   \033[32mnginx\033[0m                                Execute nginx container bash"
}
COMPOSE_FILE="${DIR}/../${DOCKER_COMPOSE_FILE}"
case "$1" in
"build")
  . ${DIR}/build.sh
  ;;
"up")
  docker compose -f "${COMPOSE_FILE}" -p "${DOCKER_CONTAINERS_PREFIX}" up -d
  ;;
"stop")
  docker-compose -f "${COMPOSE_FILE}" -p ${DOCKER_CONTAINERS_PREFIX} stop
  ;;
"restart")
  docker-compose -f "${COMPOSE_FILE}" -p ${DOCKER_CONTAINERS_PREFIX} restart
  ;;

"php")
  echo "# \033[33m docker-compose -f docker-compose.yml -p ${DOCKER_CONTAINERS_PREFIX} exec php bash \033[0m"
  docker compose -f "${COMPOSE_FILE}" -p ${DOCKER_CONTAINERS_PREFIX} exec php bash
  ;;

"nginx")
  echo "# \033[33m docker-compose -f docker-compose.yml -p ${DOCKER_CONTAINERS_PREFIX} exec nginx bash \033[0m"
  docker compose -f ${COMPOSE_FILE} -p ${DOCKER_CONTAINERS_PREFIX} exec nginx bash
  ;;
"db")
  echo "# \033[33m docker-compose -f docker-compose.yml -p ${DOCKER_CONTAINERS_PREFIX} exec db mysql -u ${MYSQL_USER} -p ${MYSQL_DATABASE} \033[0m"
  docker compose -f ${COMPOSE_FILE} -p ${DOCKER_CONTAINERS_PREFIX} exec db mysql -u ${MYSQL_USER} -p ${MYSQL_DATABASE}
  ;;

"help")
  help
  ;;
*)
  help
  ;;
esac
