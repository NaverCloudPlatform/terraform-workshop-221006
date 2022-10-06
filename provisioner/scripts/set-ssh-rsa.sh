#!/bin/bash

yum install -y sshpass

rm -f /root/.ssh/id_rsa*
ssh-keygen -t rsa -q -N '' -f $HOME/.ssh/id_rsa

%{ for server_name, attrs in SERVERS ~}
sshpass -p '${ROOT_PWS[server_name]}' ssh-copy-id -i ~/.ssh/id_rsa.pub -o StrictHostKeyChecking=no root@${attrs.private_ip}
%{ endfor ~}
