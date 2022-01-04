start:
	if [ -a nginx.conf ]; then mv nginx.conf nginx.conf.bak; fi;
	python3 generate-conf.py
	docker-compose up --build -d

stop:
	docker-compose stop

generate-certs:
	MISSING_CERTS=$$(python3 print-missing-certs.py); \
	if [ -z "$$MISSING_CERTS" ]; then \
		echo "Found no certificates to generate"; \
	else \
		docker-compose run certbot --service-ports certonly \
			--domains "$$MISSING_CERTS" \
			--non-interactive \
			--standalone \
			--agree-tos \
			--register-unsafely-without-email \
			--dry-run ; \
	fi;
