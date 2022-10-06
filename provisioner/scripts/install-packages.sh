#!/bin/bash

yum install -y epel-release
yum install -y snapd
systemctl enable --now snapd.socket
ln -s /var/lib/snapd/snap /snap

yum install -y python3
pip3 install --upgrade pip

%{ for package in yum ~}
yum install -y ${package}
%{ endfor ~}

%{ for package in snap ~}
snap install ${package} --classic
%{ endfor ~}

%{ for package in pip ~}
pip3 install ${package} --upgrade
%{ endfor ~}
