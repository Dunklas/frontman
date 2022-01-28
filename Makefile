SHELL := /bin/bash

start:
	if [ -e nginx.conf ]; then mv --force nginx.conf nginx.conf.bak; fi;
	python3 generate-conf.py
	docker-compose up --build --detach

stop:
	docker-compose stop

validate-certs:
	python3 validate-certs.py

generate-certs:
	HTTPS_DOMAINS=$$(python3 print-https-certs.py); \
	for domain in $${HTTPS_DOMAINS//,/ }; \
	do \
		docker-compose run --service-ports certbot certonly \
			--domains "$$domain" \
			--non-interactive \
			--standalone \
			--agree-tos \
			--register-unsafely-without-email; \
	done \

renew-certs:
	docker-compose run --service-ports certbot renew
