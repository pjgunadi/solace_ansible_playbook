# Ansible Playbook for Solace Configuration

## Important
Running this script requires understanding of Solace PubSub+ configuration and its [SEMPv2 API](https://docs.solace.com/SEMP/SEMP-API-Ref.htm). Backup your system before performing any changes.

## Prerequisites
- Ansible
- [Solace Pubsub+ Community Collection](https://galaxy.ansible.com/solace/pubsub_plus)

## Setup
1. Update ansible.cfg for your environment:
   - If your system Python is not version 3, add `INTERPRETER_PYTHON` path:
     `INTERPRETER_PYTHON=<path-to-your-python>`
   - When using ansible-vault for encryption add `vault_password_file`:
     `vault_password_file=./.vault_pass`
2. Configure Broker Connection:
   - Configure broker information at [inventory/solace_hosts](./inventory/solace_hosts)
   - Configure broker username and password variables for each host at inventory/host_vars/<broker-host>/credentials
      ```
      ---
      sempv2_username: admin
      sempv2_password: yourpassword
      ```
   - Encrypt the password in credential file with [ansible-vault](https://docs.ansible.com/ansible/latest/user_guide/vault.html):
     `ansible-vault encrypt_string yourpassword --name sempv2_password`
     Type the _New Value password_ and _Confirm New Vault password_
   - Copy the output and replace the sempv2_password parameter in credentials file

3. Configure playbook input file. Samples are available at [input](./input) sub-directory

## Apply Playbook
Use the provided apply-config.sh shell script:
```
./apply-config.sh <broker-name> <play-book-name> <input-file> <vault-password>
```
**broker-name**: Solace broker name configured at [inventory/solace_hosts](./inventory/solace_hosts)
**play-book-name**: playbook name at [playbooks](./playbooks) directory without prefix `_pb.yml`. Example: `msg-vpn` will obtain playbook file at `playbooks/msg-vpn_pb.yml`
**input-file**: input file relative path from [input](./input) directory. Example: `yml/msg-vpn_vars.yml` will obtain input file at `input/yml/msg-vpn_vars.yml`
**vault-password**: ansible vault password for decrypt encrypted configurations

Message VPN and Queue playbooks contains tags to disable AMQP service and disable ingress required when changing AMQP port and queue permissions. To apply runbook without disabling AMQP and Queues apply runbook with `apply-config-untagged.sh`:
```
./apply-config-untagged.sh <broker-name> <play-book-name> <variable-file-name> <vault-password>
```

Playbook can also be called directly with `ansible-playbook` command:
```
ansible-playbook -e input_file=<input-file-path> -e broker_host=<your-target-host> <playbook-file-path> <vault-password>
```
**input-file-path**: path to input configuration file. Example: `input/yml/msg-vpn_vars.yml`
**playbook-file-path**: path to playbook filename. Example: `playbooks/msg-vpn_pb.yml`

## List of Playbooks
The following playbooks are avaiable in [playbooks](./playbooks) directory:

| Playbook | Input Type | Sample usage | Notes |
|----------|------------|--------------|-------|
| msg-vpn  | yml | apply-config.sh *appliance-ip* msg-vpn yml/msg-vpn.yml | |
| acl-profile | yml | apply-config.sh *appliance-ip* acl-profile yml/acl-profile.yml | |
| client-profile | yml | apply-config.sh *appliance-ip* client-profile yml/client-profile.yml | |
| authorization-group | yml | apply-config.sh *appliance-ip* authorization-group yml/authorization-group.yml | |
| queue | yml | apply-config.sh *appliance-ip* queue yml/queue.yml | |
| queue-range | yml | apply-config.sh *appliance-ip* queue-range yml/queue-range.yml | Recursive Queues with prefix and range numbers |
| bridge | yml | apply-config.sh *appliance-ip* bridge yml/bridge.yml | |
| jndi-cf | yml | apply-config.sh *appliance-ip* jndi-cf yml/jndi-cf.yml | |
| jndi-topic | yml | apply-config.sh *appliance-ip* jndi-topic yml/jndi-topic.yml | |
| jndi-queue | yml | apply-config.sh *appliance-ip* jndi-queue yml/jndi-queue.yml | |
| msg-vpn-csv  | csv | apply-config.sh *appliance-ip* msg-vpn-csv csv/msg-vpn.csv | |
| acl-profile-csv | csv | apply-config.sh *appliance-ip* acl-profile-csv csv/acl-profile.csv | |
| client-profile-csv | csv | apply-config.sh *appliance-ip* client-profile-csv csv/client-profile.csv | |
| authorization-group-csv | csv | apply-config.sh *appliance-ip* authorization-group-csv csv/authorization-group.csv | |
| queue-csv | csv | apply-config.sh *appliance-ip* queue-csv csv/queue.csv | |
| queue-range-csv | csv | apply-config.sh *appliance-ip* queue-range-csv csv/queue-range.csv | Recursive Queues with prefix and range numbers |
| bridge-csv | csv | apply-config.sh *appliance-ip* bridge-csv csv/bridge.csv | |
| jndi-cf-csv | csv | apply-config.sh *appliance-ip* jndi-cf-csv csv/jndi-cf.csv | |
| jndi-topic=csv | csv | apply-config.sh *appliance-ip* jndi-topic-csv csv/jndi-topic.csv | |
| jndi-queue-csv | csv | apply-config.sh *appliance-ip* jndi-queue-csv csv/jndi-queue.csv | |

## Maintaining Input Configuration File

Solace configuration file can be maintained in Excel spreadsheet. See the sample of configuration spreadsheet [sample.xlsx](./input/samples/sample.xlsx)

Export the worksheet to CSV before applying the playbook with CSV input.
Use `import-csv.sh` file to convert CSV input format to YML:
```
import-csv.sh <template-file> <csv-input-file-path> <yml-output-file-path>
```
**template-file**: template filename in [templates](./templates) directory
**csv-input-file-path**: path to csv file to be converted to yml
**yml-output-file-path**: path to yml filename for saving converted yml file
Example:
```
import-csv.sh client-username.j2 ../input/csv/client-username.csv ../client-username-test.yml
```
