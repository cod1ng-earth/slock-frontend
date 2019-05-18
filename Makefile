
MAKE = make --no-print-directory
DOCKER = docker
DOCKER_COMPOSE = docker-compose
CLI = $(DOCKER_COMPOSE) exec -T app
CONSOLE = $(CLI) ./bin/console

UNAME := $(shell uname)

# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
# A category can be added with @category
HELP_FUN = \
	%help; \
	while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^([a-zA-Z\-]+)\s*:.*\#\#(?:@([a-zA-Z\-]+))?\s(.*)$$/ }; \
	print "usage: make [target]\n\n"; \
	for (sort keys %help) { \
	print "${WHITE}$$_:${RESET}\n"; \
	for (@{$$help{$$_}}) { \
	$$sep = " " x (32 - length $$_->[0]); \
	print "  ${YELLOW}$$_->[0]${RESET}$$sep${GREEN}$$_->[1]${RESET}\n"; \
	}; \
	print "\n"; }

# Process parameters/options
ifeq (logs,$(firstword $(MAKECMDGOALS)))
    LOGS_TAIL := 0
    ifdef tail
        LOGS_TAIL := $(tail)
    endif
endif

help: ##@other Show this help.
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)
.PHONY: help

start: ##@development start containers
	$(DOCKER_COMPOSE) up -d
	$(MAKE) codebase-update
	$(MAKE) serve
.PHONY: start

logs: ##@development show server logs (default: 0, use parameter 'tail=<#|all>, e.g. call 'make logs tail=all' for all logs, add `make logs tail=10' or any number for specific amount of lines)
	$(DOCKER_COMPOSE) logs -f --tail=$(LOGS_TAIL)
.PHONY: logs

cli: ##@development get shell in a container (defaults: cli (container), /bin/sh (shell), add 'container={container}' to use different container, e.g. 'make cli container=postgres', add 'shell={shell}' to use different shell, e.g. 'make cli shell=/bin/bash')
	$(DOCKER_COMPOSE) exec app bash
.PHONY: cli

stop: ##@development stop containers
	$(DOCKER_COMPOSE) stop -t 1
.PHONY: stop

restart: stop start ##@development restart containers
.PHONY: restart

clean: ##@setup stop and remove containers
	$(MAKE) stop
	$(DOCKER_COMPOSE) down --remove-orphans
.PHONY: clean

rebuild: ##@development removes images
	$(DOCKER_COMPOSE) down --rmi all
	$(MAKE) setup
.PHONY: rebuild

update-containers: build-images start ##@development updates containers
.PHONY: update-containers

build-images: ##@setup build docker images
	$(DOCKER_COMPOSE) build
.PHONY: build-images

update-setup: build-images start ##@setup update docker setup
.PHONY: update-setup

setup: build-images start ##@setup Create dev enviroment
.PHONY: setup

codebase-update: yarn-install ##@development updates code (composer install, codecept build)
.PHONY: codebase-update

yarn-install: ##@development run 'composer install' in container
	$(CLI) yarn install
.PHONY: yarn-install

serve: ##@development run app in development mode
	$(CLI) yarn run serve
.PHONY: start

build: ##@development run app in development mode
	$(CLI) yarn run build
.PHONY: start

docker-stats: ##@other show information about running Docker containers
	$(DOCKER) stats --format "table {{.Container}}\t{{.Name}}\t{{.CPUPerc}}\t{{.MemPerc}}\t{{.BlockIO}}"
.PHONY: docker-stats

run-console: ##@development Run custom command (usage example: make run comm='code:generate:module:yves test')
	$(CONSOLE) $(comm)
.PHONY: run-console
