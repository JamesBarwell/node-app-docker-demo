NODE_BASE_IMAGE := node:12.13.0-alpine
NODE_BASE_INSTALL_DIR := /home/node/app
IMAGE_NAME := nodeappsample

build:
	docker build -t ${IMAGE_NAME} .

test-and-build: lint test audit build

run-prod:
	docker run --rm --init -p 8080:8080 -e NODE_ENV=production ${IMAGE_NAME}

run-dev:
	docker run --rm --init -p 8080:8080 -v $(shell pwd)/app:${NODE_BASE_INSTALL_DIR} -w ${NODE_BASE_INSTALL_DIR} ${NODE_BASE_IMAGE} npm run start-dev

run-dev-debug:
	docker run --rm --init -p 8080:8080 -p 9229:9229 -v $(shell pwd)/app:${NODE_BASE_INSTALL_DIR} -w ${NODE_BASE_INSTALL_DIR} ${NODE_BASE_IMAGE} npm run start-dev-debug

install-dependencies:
	docker run --rm --init -v $(shell pwd)/app:${NODE_BASE_INSTALL_DIR} -w ${NODE_BASE_INSTALL_DIR} ${NODE_BASE_IMAGE} npm install --ignore-scripts
	sudo chown -R $(shell whoami): $(shell pwd)/app/node_modules

test:
	docker run --rm --init -v $(shell pwd)/app:${NODE_BASE_INSTALL_DIR} -w ${NODE_BASE_INSTALL_DIR} ${NODE_BASE_IMAGE} npm test

test-watch:
	docker run --rm --init -v $(shell pwd)/app:${NODE_BASE_INSTALL_DIR} -w ${NODE_BASE_INSTALL_DIR} ${NODE_BASE_IMAGE} npm run test-watch

lint:
	docker run --rm --init -v $(shell pwd)/app:${NODE_BASE_INSTALL_DIR} -w ${NODE_BASE_INSTALL_DIR} ${NODE_BASE_IMAGE} npm run lint

audit:
	docker run --rm --init -v $(shell pwd)/app:${NODE_BASE_INSTALL_DIR} -w ${NODE_BASE_INSTALL_DIR} ${NODE_BASE_IMAGE} npm audit

dev-env:
	./tmux-env.sh
