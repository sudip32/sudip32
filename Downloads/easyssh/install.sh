#!/bin/bash

CONSOLE=`echo $SHELL | awk -F/ '{print $NF}'`
CAN_I_RUN_SUDO=$(sudo uptime 2>&1|grep "load"|wc -l)

echo $CAN_I_RUN_SUDO

if [ ${CAN_I_RUN_SUDO} -gt 0 ]
then
	  echo
	  echo "INSTALLING THE REQUIRED PACKAGES"
	  echo
    sudo easy_install -q pip 2>&1 > /dev/null
    sudo pip install -q boto 2>&1 > /dev/null
    sudo cp ec2-sshconfig-generate /usr/local/bin/ && sudo chmod 755 /usr/local/bin/ec2-sshconfig-generate
    sudo cp hostgen /usr/local/bin/ && sudo chmod 755 /usr/local/bin/hostgen

    echo "POPULATING YOUR SHELL RC FILE TO RUN THE FETCH ASYNCHRONOUSLY IF NOT ALREADY THERE"
    if ! grep -w -q 'disown' ~/.${CONSOLE}rc;then
	     echo "set +o monitor"  >> ~/.${CONSOLE}rc
  	   echo "hostgen &" >> ~/.${CONSOLE}rc
  	   echo "disown %1" >> ~/.${CONSOLE}rc
  	   echo "set -o monitor" >> ~/.${CONSOLE}rc
    fi
else
    echo "You are not in sudoers file man !!!"
fi
