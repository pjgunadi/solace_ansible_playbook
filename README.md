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
   - Define path to inventory file:
     `inventory=inventory/solace_hosts`

2. Configure Broker Connection:
   - Configure broker information at inventory file [inventory/solace_hosts](./inventory/solace_hosts) or as defined in ansible.cfg
   - Configure broker username and password variables for each host at inventory/host_vars/<broker-host>/credentials
      ```
      ---
      sempv2_username: admin
      sempv2_password: yourpassword
      cluster_password: your_dmr_cluster_password
      cloud_service_id: your_cloud_service_id
      cloud_api_token: your_cloud_service_api_token
      ```
   - Encrypt the password in credential file with [ansible-vault](https://docs.ansible.com/ansible/latest/user_guide/vault.html). Example:
     `ansible-vault encrypt_string yourpassword --name sempv2_password`
     Type the _New Value password_ and _Confirm New Vault password_
   - Update encrypted variables in inventory/host_vars/<broker-host>/credentials file

3. Configure playbook input file. Samples are available at [input](./input) sub-directory

## Apply Playbook
Use the provided apply-config.sh shell script:
```
./apply-config.sh <broker-name> <play-book-name> <input-file> <vault-password>
```
**Description**:
- **broker-name**: Solace broker name configured at [inventory/solace_hosts](./inventory/solace_hosts)
- **play-book-name**: playbook name at [playbooks](./playbooks) directory without prefix `_pb.yml`. Example: `msg-vpn` will obtain playbook file at `playbooks/msg-vpn_pb.yml`
- **input-file**: input file relative path from [input](./input) directory. Example: `yml/msg-vpn_vars.yml` will obtain input file at `input/yml/msg-vpn_vars.yml`
- **vault-password**: ansible vault password for decrypt encrypted configurations

Playbook can also be called directly with `ansible-playbook` command:
```
ansible-playbook -e input_file=<input-file-path> -e broker_host=<your-target-host> <playbook-file-path> <vault-password>
```
**Description:**
- **input-file-path**: path to input configuration file. Example: `input/yml/msg-vpn_vars.yml`
- **playbook-file-path**: path to playbook filename. Example: `playbooks/msg-vpn_pb.yml`

## List of Playbooks
The following playbooks are avaiable in [playbooks](./playbooks) directory:

| Playbook | Input Type | Sample usage | Notes |
|----------|------------|--------------|-------|
| msg-vpn  | yml | apply-config.sh *host_or_group_name* msg-vpn yml/msg-vpn.yml | |
| acl-profile | yml | apply-config.sh *host_or_group_name* acl-profile yml/acl-profile.yml | |
| client-profile | yml | apply-config.sh *host_or_group_name* client-profile yml/client-profile.yml | |
| authorization-group | yml | apply-config.sh *host_or_group_name* authorization-group yml/authorization-group.yml | |
| queue | yml | apply-config.sh *host_or_group_name* queue yml/queue.yml | |
| queue-range | yml | apply-config.sh *host_or_group_name* queue-range yml/queue-range.yml | Recursive Queues with prefix and range numbers |
| bridge | yml | apply-config.sh *host_or_group_name* bridge yml/bridge.yml | |
| jndi-cf | yml | apply-config.sh *host_or_group_name* jndi-cf yml/jndi-cf.yml | |
| jndi-topic | yml | apply-config.sh *host_or_group_name* jndi-topic yml/jndi-topic.yml | |
| jndi-queue | yml | apply-config.sh *host_or_group_name* jndi-queue yml/jndi-queue.yml | |
| mqtt-session | yml | apply-config.sh *host_or_group_name* mqtt-session yml/mqtt-session.yml | |
| rdp | yml | apply-config.sh *host_or_group_name* rdp yml/rdp.yml | |
| dmr-cluster | yml | apply-config.sh *host_or_group_name* dmr-cluster | |
| replicated-topic | yml | apply-config.sh *host_or_group_name* replicated-topic yml/replicated-topic.yml | Planned |
| msg-vpn-csv  | csv | apply-config.sh *host_or_group_name* msg-vpn-csv csv/msg-vpn.csv | |
| acl-profile-csv | csv | apply-config.sh *host_or_group_name* acl-profile-csv csv/acl-profile.csv | |
| client-profile-csv | csv | apply-config.sh *host_or_group_name* client-profile-csv csv/client-profile.csv | |
| authorization-group-csv | csv | apply-config.sh *host_or_group_name* authorization-group-csv csv/authorization-group.csv | |
| queue-csv | csv | apply-config.sh *host_or_group_name* queue-csv csv/queue.csv | |
| queue-range-csv | csv | apply-config.sh *host_or_group_name* queue-range-csv csv/queue-range.csv | Limitation: use one csv file per range number profile |
| bridge-csv | csv | apply-config.sh *host_or_group_name* bridge-csv csv/bridge.csv | |
| jndi-cf-csv | csv | apply-config.sh *host_or_group_name* jndi-cf-csv csv/jndi-cf.csv | |
| jndi-topic=csv | csv | apply-config.sh *host_or_group_name* jndi-topic-csv csv/jndi-topic.csv | |
| jndi-queue-csv | csv | apply-config.sh *host_or_group_name* jndi-queue-csv csv/jndi-queue.csv | |

## Get Config
Use the provided get-config.sh shell script:
```
./get-config.sh <broker-name> <msg-vpn> <config-name> <output-file> <vault-password>
```
**Description**:
- **broker-name**: Solace broker name configured at [inventory/solace_hosts](./inventory/solace_hosts)
- **msg-vpn**: Message VPN name of Solace broker
- **config-name**: Name of Solace Configurations: msg-vpn, acl-profile, authorization-group, bridge, client-profile, client-username, jndi-cf, jndi-queue, jndi-topic, mqtt-session, queue, rdp, dmr-cluster, replicated-topic
- **output-file**: output file relative path from [output](./output) directory. When output file extension is `.csv` the output will be saved as `csv` format, otherwise the default format is `yml`. Example: `msg-vpn_export.yml` will be saved at `output/msg-vpn_export.yml`.
- **vault-password**: ansible vault password for decrypt encrypted configurations

## Maintaining Input Configuration File

Solace configuration file can be maintained in Excel spreadsheet. See the sample of configuration spreadsheet [sample.xlsx](./input/samples/sample.xlsx)

Export the worksheet to CSV before applying the playbook with CSV input.
Use `import-csv.sh` file to convert CSV input format to YML:
```
import-csv.sh <template-file> <csv-input-file-path> <yml-output-file-path>
```
**Description:**
- **template-file**: template filename in [templates](./templates) directory
- **csv-input-file-path**: path to csv file to be converted to yml
- **yml-output-file-path**: path to yml filename for saving converted yml file
Example:
```
import-csv.sh client-username.j2 ../input/csv/client-username.csv ../client-username-test.yml
```
## Dynamic Message Routing (DMR) Variables
When using this playbook for configuring DMR, the hosts in inventory file should be configured with the following group pattern:
```
dmr_group_name:
  children:
    local:
      hosts:
        broker_name:
          ...
    external_link:
      hosts:
        broker_name:
          ...
    internal_link:
```
The hosts in the inventory files should have these additional variables:
| Group | Variable Name | Required at | Description |
|-------|---------------|-------------|-------------|
| local | cluster_name | appliance,software | DMR Cluster name |
| local | cluster_enabled | appliance,software | true or false |
| local | cluster_password | appliance,software | DMR Cluster password |
| local | cluster_link_msg_vpn | appliance,software | Message VPN for DMR Cluster Link |
| local | cluster_link_service_address | appliance,software | Solace SMF service IP/Hostname |
| local | cluster_link_service_port | appliance,software | Solace SMF service port (Secure) |
| local | cluster_link_authenticationScheme | appliance,software,cloud (all) | basic or client-certificate |
| local | cluster_link_enabled | all | true or false |
| local | cluster_link_initiator | all | local / remote / lexical |
| local | cluster_link_transportCompressedEnabled | all | true or false |
| local | cluster_link_transportTlsEnabled | all | true |
| local | cluster_link_state | all | present or absent |
| external_link | cluster_name | appliance,software | DMR Cluster name |
| external_link | cluster_enabled | appliance,software | true or false |
| external_link | cluster_password | appliance,software | DMR Cluster password |
| external_link | cluster_link_msg_vpn | appliance,software | Message VPN for DMR Cluster Link |
| external_link | cluster_link_service_address | appliance,software | Solace SMF service IP/Hostname |
| external_link | cluster_link_service_port | appliance,software | Solace SMF service port (Secure) |
| internal_link | not applicable for cloud | appliance and software only | Internal Link is not applicable for Solace Cloud broker |
| internal_link | cluster_name | appliance,software | DMR Cluster name |
| internal_link | cluster_enabled | appliance,software | true or false |
| internal_link | cluster_password | appliance,software | DMR Cluster password |
| internal_link | cluster_link_msg_vpn | appliance,software | Message VPN for DMR Cluster Link |
| internal_link | cluster_link_service_address | appliance,software | Solace SMF service IP/Hostname |
| internal_link | cluster_link_service_port | appliance,software | Solace SMF service port (Secure) |

## Author
Paulus Gunadi