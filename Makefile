.PHONY: help

.DEFAULT_GOAL:=help

setup:
	docker volume create --name=db-share

start: setup ## Run
	set -o allexport; source .env; docker-compose down; docker-compose up --build

stop: ## Stop the docker processes
	docker-compose stop

ssh: ## SSH into the web container
	set -o allexport; source .env; docker-compose exec wp sh

# -----------------------------------------------------------------------------------

help: ## Prints the help about targets.
	@printf "Usage:             make [\033[34mtarget\033[0m]\n"
	@printf "Default:           \033[34m%s\033[0m\n" $(.DEFAULT_GOAL)
	@printf "Targets:\n"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf " \033[34m%-17s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort
