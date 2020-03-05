APP_NAME="tools"

build:
	docker build . -t $(APP_NAME)

build_nc:
	docker build . -t $(APP_NAME) --no-cache

run: ## run the container with the local kubernetes credentials
	docker run --rm -it -v ~/.kube:/root/.kube $(APP_NAME)

run_isolated: ## run the container without giving it access to the host volumes.  
	docker run --rm -it $(APP_NAME)