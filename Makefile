init:
	docker compose up --build -d
	docker exec -it rails rails db:migrate
up:
	docker compose up -d
build:
	docker compose build
down:
	docker compose down --rmi all --volumes
app:
	docker exec -it rails /bin/bash
db:
	docker exec -it db /bin/bash
