#!/bin/sh

BASE_PATH=$(pwd)
INPUT_PATH=$BASE_PATH/input
PLAYBOOK_PATH=$BASE_PATH/playbooks
TARGET=$1
PLAYBOOK=$2
INPUT_FILE=$3
PASSWD=$4

if [ "$TARGET" == "" -o "$PLAYBOOK" == "" -o "$INPUT_FILE" == "" ]; then
  echo "Usage: $(basename $0) <target-host> <playbook> <input file> [vault password]"
  echo "<target-host>: all | group or host defined in inventory/solace_hosts file"
  echo "<playbook>: playbook prefix name defined in playbooks folder."
  echo "<input file>: input file for playbook under input directory"
  echo "example: $0 all msg-vpn msg-vpn_vars.yml"
  exit 1
fi

if [ "$PASSWD" == "" ]; then
  ansible-playbook -e input_file=${INPUT_PATH}/${INPUT_FILE} -e broker_host=${TARGET} ${PLAYBOOK_PATH}/${PLAYBOOK}_pb.yml --ask-vault-pass
else
  VAULT_PASSWORD=${PASSWD} ansible-playbook -e input_file=${INPUT_PATH}/${INPUT_FILE} -e broker_host=${TARGET} ${PLAYBOOK_PATH}/${PLAYBOOK}_pb.yml --vault-password-file ./.vault_pass
fi