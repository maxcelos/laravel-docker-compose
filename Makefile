.RECIPEPREFIX +=
.DEFAULT_GOAL := help
PROJECT_NAME=jump
include .env

.PHONY: artisan pnpm

help:
	@echo "Welcome to $(PROJECT_NAME) IT Support, have you tried turning it off and on again?"


sonarqube: run-tests
	bash docker/scripts/sonarscan.sh

run-tests:
	docker compose exec app php artisan test \
		--coverage-clover=coverage.xml \
		--coverage-html=build/coverage
		
test:
	@docker exec $(PROJECT_NAME)_php ./vendor/bin/pest --parallel

coverage:
	@docker exec $(PROJECT_NAME)_php ./vendor/bin/pest --coverage

migrate:
	@docker exec $(PROJECT_NAME)_php php artisan migrate

seed:
	@docker exec $(PROJECT_NAME)_php php artisan db:seed

fresh:
	@docker exec crm_php php artisan migrate:fresh

analyse:
	./vendor/bin/phpstan analyse --memory-limit=256m

generate:
	@docker exec $(PROJECT_NAME)_php php artisan ide-helper:models --write

nginx:
	@docker exec -it $(PROJECT_NAME)_nginx /bin/sh

php:
	@docker exec -it $(PROJECT_NAME)_php /bin/bash

postgres:
	@docker exec -it $(PROJECT_NAME)_postgres /bin/sh

redis:
	@docker exec -it $(PROJECT_NAME)_redis /bin/sh

artisan:
	@docker exec -it $(PROJECT_NAME)_php php artisan $(filter-out $@,$(MAKECMDGOALS))

pnpm:
	@docker exec -it $(PROJECT_NAME)_php pnpm $(filter-out $@,$(MAKECMDGOALS))

composer:
	@docker exec -it $(PROJECT_NAME)_php composer $(filter-out $@,$(MAKECMDGOALS))

start:
	@docker exec -it $(PROJECT_NAME)_php composer dev

%:
	@:
