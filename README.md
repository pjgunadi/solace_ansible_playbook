# Ansible Playbook for Solace Configuration

## Important
Running this script requires understanding of Solace PubSub+ configuration and its SEMP API. Backup your system before performing any changes.

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
./apply-config.sh <broker-name> <run-book-name> <variable-file-name> <vault-password>
```
or run manually with ansible-playbook command:
```
ansible-playbook -e input_file=<your-input-file-path> -e broker_host=<your-target-host> <playbook-file-path> <vault-password>
```
