build:
	docker build -t nodeappsample .

run:
	docker run --rm --init -p 8080:8080 nodeappsample

run-production:
	docker run --rm --init -p 8080:8080 -e "NODE_ENV=production" nodeappsample
