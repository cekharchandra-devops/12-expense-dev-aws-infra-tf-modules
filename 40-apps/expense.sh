#! /bin/bash

dnf install ansible -y
cd /tmp
git clone https://github.com/cekharchandra-devops/05-expense-ansible-roles.git
cd 05-expense-ansible-roles
ansible-playbook -i inventory.ini mysql.yaml
ansible-playbook -i inventory.ini backend.yaml
ansible-playbook -i inventory.ini frontend.yaml