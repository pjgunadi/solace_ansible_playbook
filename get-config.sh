#!/bin/sh

BASE_PATH=$(pwd)
OUTPUT_PATH=$BASE_PATH/output
PLAYBOOK_PATH=$BASE_PATH/playbooks/get-config_pb.yml
TARGET=$1
MSG_VPN=$2
TAG=$3
OUTPUT_FILE=$4

if [ "$TARGET" == "" -o "$MSG_VPN" == "" -o "$TAG" == "" -o "$OUTPUT_FILE" == "" ]; then
  echo "Usage: get-config.sh <target-host> <msg-vpn> <config-name> <output file> [vault password]"
  echo "<target-host>: all | group or host defined in inventory/solace_hosts file"
  echo "<msg-vpn>: Solace broker message-vpn name"
  echo "<config-name>: configuration name to be exported"
  echo "<output file>: result output file in output directory"
  echo "example: get-config.sh all my-vpn msg-vpn my-vpn_output.yml"
  exit 1
fi

if [ "$5" == "" ]; then
  ansible-playbook -e result_output=${OUTPUT_PATH}/${OUTPUT_FILE} -e broker_host=${TARGET} -e msg_vpn=${MSG_VPN} ${PLAYBOOK_PATH} --tags ${TAG} --ask-vault-pass
else
  VAULT_PASSWORD=$5 ansible-playbook -e result_output=${OUTPUT_PATH}/${OUTPUT_FILE} -e broker_host=${TARGET} -e msg_vpn=${MSG_VPN} ${PLAYBOOK_PATH} --tags ${TAG} --vault-password-file ./.vault_pass
fi
