CONTAINER_NAME=test_backend

install:
	cd ../test-backend && cp .env.example .env
	make up
	make composer-install
	make migrate
	docker ps

up:
	docker-compose up -d

down:
	docker-compose down

bash:
	docker exec -it $(CONTAINER_NAME) sh

build:
	docker-compose build

force-recreate:
	docker-compose up -d --force-recreate --build

composer-install:
	docker exec -t $(CONTAINER_NAME) composer install
	docker exec -t $(CONTAINER_NAME) php artisan key:generate

migrate:
	docker exec $(CONTAINER_NAME) php artisan migrate --seed

test:
ifdef FILTER
	make up
	#make clear
	docker exec -t $(CONTAINER_NAME) composer unit-test -- --filter="$(FILTER)"
else
	make up
	#make clear
	docker exec -t $(CONTAINER_NAME) composer unit-test
endif

logs:
	make up
	docker-compose logs --follow

clear:
	make up
	docker exec $(CONTAINER_NAME) sh -c "php artisan optimize:clear"

coverage-html:
	make up
	#make clear
	docker exec -t $(CONTAINER_NAME) composer test-coverage-html

format:
	make up
	docker exec -t $(CONTAINER_NAME) composer lint-fix
