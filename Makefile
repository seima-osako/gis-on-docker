IMAGE_NAME := gis-work
SERVICE_NAME := gis-work
CONTAINER_NAME := gis-work_container
VERSION_TAG := v1.0.0

# docker-compose up --build コマンドを実行するターゲット
up:
	IMAGE_NAME=$(IMAGE_NAME) \
	CONTAINER_NAME=$(CONTAINER_NAME) \
	VERSION_TAG=$(VERSION_TAG) \
	docker-compose up --build -d

# Jupyter Notebookの環境を構築するターゲット
jupyter:
	IMAGE_NAME=$(IMAGE_NAME) \
	CONTAINER_NAME=$(CONTAINER_NAME) \
	VERSION_TAG=$(VERSION_TAG) \
	docker-compose run --rm -p 8888:9999 $(SERVICE_NAME) jupyter lab --ip=0.0.0.0 --allow-root --NotebookApp.token='' --port=9999 --notebook-dir=./notebook

# Dockerコンテナに入るためのターゲット
shell:
	IMAGE_NAME=$(IMAGE_NAME) \
	CONTAINER_NAME=$(CONTAINER_NAME) \
	VERSION_TAG=$(VERSION_TAG) \
	docker-compose run --rm $(SERVICE_NAME) /bin/bash

down:
	docker-compose down

ps:
	docker-compose ps -a