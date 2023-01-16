#!/usr/bin/make

#-------------------------------SYSTEM-----------------------------------
include .env
export
HOST = ${USER}@${ADDR}
#------------------------------##########--------------------------------

init:
	cd provisioning && make server-init && make server-upgrade

deploy:
	ssh ${USER}@${ADDR} -p ${PORT} 'rm -rf server'
	ssh ${USER}@${ADDR} -p ${PORT} 'mkdir server'
	scp -P ${PORT} docker-compose.yml ${USER}@${ADDR}:server/docker-compose.yml
	scp -P ${PORT} .env ${USER}@${ADDR}:server/.env
	ssh ${USER}@${ADDR} -p ${PORT} 'cd server && docker-compose stop'
	ssh ${USER}@${ADDR} -p ${PORT} 'cd server && docker-compose rm -f'
	ssh ${USER}@${ADDR} -p ${PORT} 'cd server && docker-compose up -d --build --remove-orphans'

create-user:
	ssh ${ROOT}@${ADDR} -p ${PORT} 'adduser --disabled-password --uid "${UID}" -gecos "" ${USER}'
	ssh ${ROOT}@${ADDR} -p ${PORT} "echo '${USER}:${PASS}' | chpasswd"
	ssh ${ROOT}@${ADDR} -p ${PORT} 'usermod -aG sudo ${USER}'
	ssh ${ROOT}@${ADDR} -p ${PORT} "echo '${USER} ALL=(ALL) NOPASSWD:ALL' | sudo EDITOR='tee -a' visudo"
	ssh-copy-id -p ${PORT} ${USER}@${ADDR}
