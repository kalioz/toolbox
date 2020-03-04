APP_NAME="tools"

build:
	docker build . -t $(APP_NAME)

build_nc:
	docker build . -t $(APP_NAME) --no-cache

run: ## run the container with the local kubernetes credentials
	docker run -it -v ~/.kube:/root/.kube $(APP_NAME)

run_isolated: ## run the container without giving it access to the host volumes.  
	docker run -it $(APP_NAME)