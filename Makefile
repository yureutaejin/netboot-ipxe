ISOS ?= ./isos

.PHONY: up
up:
	ISOS=${ISOS} \
	docker compose up -d

.PHONY: down
down:
	ISOS=${ISOS} \
	docker compose down -v
