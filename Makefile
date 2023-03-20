#!/usr/bin/make

#-------------------------------SYSTEM-----------------------------------
include .env
export
HOST = ${USER}@${ADDR}
.PHONY: init
#------------------------------##########--------------------------------

init: create-user create-guest-user sshd-playbook server-playbook upgrade-playbook deploy
update: server-playbook deploy

server-playbook:
	cd provisioning && ansible-playbook -i hosts.yml server.yml

upgrade-playbook:
	cd provisioning && ansible-playbook -i hosts.yml upgrade.yml

sshd-playbook:
	cd provisioning && ansible-playbook -i hosts.yml sshd.yml

deploy:
	ssh ${USER}@${ADDR} -p ${PORT} 'sudo mkdir -p /sys/fs/cgroup/systemd'
	ssh ${USER}@${ADDR} -p ${PORT} 'sudo mountpoint -q /sys/fs/cgroup/systemd || sudo mount -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd'
	ssh ${USER}@${ADDR} -p ${PORT} 'rm -rf server'
	ssh ${USER}@${ADDR} -p ${PORT} 'mkdir server'
	scp -P ${PORT} docker-compose.yml ${USER}@${ADDR}:server/docker-compose.yml
	scp -P ${PORT} .env ${USER}@${ADDR}:server/.env
	ssh ${USER}@${ADDR} -p ${PORT} 'cd server && docker-compose stop'
	ssh ${USER}@${ADDR} -p ${PORT} 'cd server && docker-compose rm -f'
	ssh ${USER}@${ADDR} -p ${PORT} 'cd server && docker-compose up -d --build --remove-orphans'

create-user:
	ssh ${ROOT}@${ADDR} 'adduser --disabled-password --uid "${UID}" -gecos "" ${USER}'
	ssh ${ROOT}@${ADDR} "echo '${USER}:${PASS}' | chpasswd"
	ssh ${ROOT}@${ADDR} 'usermod -aG sudo ${USER}'
	ssh ${ROOT}@${ADDR} "echo '${USER} ALL=(ALL) NOPASSWD:ALL' | sudo EDITOR='tee -a' visudo"
	ssh-copy-id ${USER}@${ADDR}

create-guest-user:
	ssh ${ROOT}@${ADDR} 'adduser --disabled-password --uid "${GUEST_UID}" -gecos "" ${GUEST_USER}'
	ssh ${ROOT}@${ADDR} "echo '${GUEST_USER}:${GUEST_PASS}' | chpasswd"
	ssh ${ROOT}@${ADDR} 'groupadd guest'
	ssh ${ROOT}@${ADDR} 'usermod -aG guest ${GUEST_USER}'

