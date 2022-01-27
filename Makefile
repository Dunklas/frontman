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
	if [ -z "$$HTTPS_DOMAINS" ]; then \
		echo "Found no domains to generate certificates for"; \
	else \
		for domain in $${HTTPS_DOMAINS//,/ }; \
		do \
		echo "$$domain"; \
		done \
	fi;

renew-certs:
	docker-compose run --service-ports certbot renew
