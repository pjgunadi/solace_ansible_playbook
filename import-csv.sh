#!/bin/sh

BASE_PATH=$(pwd)
TEMPLATE_PATH=$BASE_PATH/templates
PLAYBOOK_PATH=$BASE_PATH/playbooks
TEMPLATE_FILE=$1
CSV_FILE=$2
YML_FILE=$3


if [ "$TEMPLATE_FILE" == "" -o "$CSV_FILE" == "" -o "$YML_FILE" == "" ]; then
  echo "Usage: import-csv.sh <template-file> <csv-input-file> <yml-output-file>"
  echo "example: import-csv.sh acl-profile.j2 ../input/csv/acl-profile.csv ../acl-profile.yml"
  exit 1
fi

ansible-playbook -e template_file=${TEMPLATE_PATH}/${TEMPLATE_FILE} -e csv_file=${CSV_FILE} -e output_file=${YML_FILE} -e broker_host=localhost playbooks/import-csv_pb.yml
