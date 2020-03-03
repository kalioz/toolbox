APP_NAME="tools"

build:
	docker build . -t $(APP_NAME)

build_nc:
	docker build . -t $(APP_NAME) --no-cache

run:
	docker run -it $(APP_NAME)