#!/usr/bin/env bash
alias sf="php bin/console";
alias sfchmod="chmod 777 -R var/cache";
alias sfcc="sf cache:clear && sfchmod";
#debugs aliases
alias dg-router="sf router:debug";
alias dg-container="sf container:debug";
alias dg-voter="sf container:debug --tag='security.voter' --show-private";

#db aliases
alias db-drop="sf doctrine:database:drop --force";
alias db-create="sf doctrine:database:create";
alias db-update="sf doctrine:schema:update --force";

alias db-diff="sf doctrine:migration:diff";
alias db-migrate="sf doctrine:migration:migrate";

alias db-clear="sf doctrine:database:drop --force && sf doctrine:database:create";
alias db-init="sf doctrine:migration:migrate && sf d:s:u --force && sf doctrine:fixtures:load";
alias db-build="db-clear && db-update && sf d:f:l";
