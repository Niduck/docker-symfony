#!/bin/bash

#Get vars from .env file
    . ../.env
#ASK - if needs to build
DIR="$( cd "$( dirname "$0" )" && pwd )"
echo "alias ${APP_ALIAS}='sh ${DIR}/actions.sh'" >> ~/.bash_aliases
alias ${APP_ALIAS}='sh ${DIR}/actions.sh'
