DOCKER_IMAGE=dockette/httpdump

build: docker-build

test: docker-build
	docker compose up -d
	@trap 'docker compose down --volumes --remove-orphans' EXIT; \
		for i in $$(seq 1 30); do \
			curl -fsS http://localhost:8000/ > /dev/null && exit 0; \
			sleep 2; \
		done; \
		curl -fsS http://localhost:8000/ > /dev/null

run: test-up

docker-build:
	docker build --pull -t ${DOCKER_IMAGE} .

docker-push:
	docker push ${DOCKER_IMAGE}

test-up:
	docker compose up

test-in:
	docker compose exec httpdump bash
