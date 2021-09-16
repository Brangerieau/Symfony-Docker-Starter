php := php
sy := php bin/console
PROJECT_NAME := app

.DEFAULT_GOAL := help
.PHONY: help
help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: create_project
create_project:  ## create Symfony project
	make symfony/install
	make symfony/move_project
	make symfony/remove_project_folder
	sed -i 's/# DATABASE_URL="mysql/DATABASE_URL="mysql/g' .env
	sed -i 's/DATABASE_URL="postgresql/# DATABASE_URL="postgresql/g' .env
	sed -i 's/mysql:\/\/db_user:db_password@127.0.0.1:3306\/db_name?serverVersion=5.7/mysql:\/\/root:secret@mysql_docker_symfony\/symfony_app?serverVersion=8.0/g' .env
	cp .env .env.local
	make create_database
	make server
	
.PHONY: migrate
migrate: vendor/autoload.php ## Migrate the database
	$(sy) doctrine:migrations:migrate -q

.PHONY: server
server: ## Launch server symfony
	symfony serve -d

.PHONY: create_database
create_database:
	$(sy) doctrine:database:create

# -----------------------------------
# Utils
# -----------------------------------
vendor/autoload.php: composer.lock
	composer install

.PHONY: symfony/install
symfony/install: 
	composer create-project symfony/website-skeleton $(PROJECT_NAME)

.PHONY: symfony/move_project
symfony/move_project: $(PROJECT_NAME)
	mv $(PROJECT_NAME)/* .
	mv $(PROJECT_NAME)/.env .
	mv $(PROJECT_NAME)/.env.test .
	mv $(PROJECT_NAME)/.gitignore .

.PHONY: symfony/remove_project_folder
symfony/remove_project_folder: $(PROJECT_NAME)
	rm -R $(PROJECT_NAME)
