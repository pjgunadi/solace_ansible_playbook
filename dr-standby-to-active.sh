#!/bin/sh

BASE_PATH=$(pwd)
INPUT_PATH=$BASE_PATH/input
PLAYBOOK_PATH=$BASE_PATH/playbooks
PLAYBOOK_PATH=$BASE_PATH/playbooks/dr-switch-to-active.yml
STANDBY_BROKER=$1
INPUT_FILE=$2
TAG=$3
PASSWD=$4

if [ "$STANDBY_BROKER" == "" -o "$INPUT_FILE" == "" -o "$TAG" == "" ]; then
  echo "Usage: $(basename $0) <standby-host> <input file> <apply|check> [vault password]"
  echo "<standby-host>: host defined in inventory/solace_hosts file"
  echo "<input file>: input file for playbook under input directory"
  echo "example: $0 primary-site alternate-site test_vpns.yml check"
  exit 1
fi

if [ "$PASSWD" == "" ]; then
  ansible-playbook -e input_file=${INPUT_PATH}/${INPUT_FILE} -e standby_host=${STANDBY_BROKER} ${PLAYBOOK_PATH} --tags ${TAG} --ask-vault-pass
else
  VAULT_PASSWORD=${PASSWD} ansible-playbook -e input_file=${INPUT_PATH}/${INPUT_FILE} -e standby_host=${STANDBY_BROKER} ${PLAYBOOK_PATH} --tags ${TAG} --vault-password-file ./.vault_pass
fi