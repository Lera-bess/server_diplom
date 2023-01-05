#!/usr/bin/make

#-------------------------------SYSTEM-----------------------------------
include .env
export
#------------------------------##########--------------------------------

init:
	cd provisioning && make server-init && make server-upgrade

deploy:
	ssh ${HOST} -p ${PORT} 'rm -rf server'
	ssh ${HOST} -p ${PORT} 'mkdir server'
	scp -P ${PORT} docker-compose.yml ${HOST}:server/docker-compose.yml
	scp -P ${PORT} .env ${HOST}:server/.env
	ssh ${HOST} -p ${PORT} 'cd server && docker-compose stop'
	ssh ${HOST} -p ${PORT} 'cd server && docker-compose rm -f'
	ssh ${HOST} -p ${PORT} 'cd server && docker-compose up -d --build --remove-orphans'
