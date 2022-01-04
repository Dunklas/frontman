import json
import os
import sys

def is_https(server):
    return server['https']

def cert_missing(domain_name):
    chain_exists = os.path.exists("/etc/letsencrypt/live/{}/fullchain.pem".format(domain_name))
    private_exists = os.path.exists("/etc/letsencrypt/live/{}/privkey.pem".format(domain_name))
    return not (chain_exists and private_exists)

with open("servers.json") as f:
    servers_input = json.loads(f.read())
    https_servers = filter(is_https, servers_input)
    https_server_names = map(lambda https_server: https_server['server_name'], https_servers)
    missing_certs = list(filter(cert_missing, https_server_names))

    if not missing_certs:
        print("Found no missing certificates")
        sys.exit(0)
    
    domains = ",".join(missing_certs)
    os.system("docker run certbot/certbot certonly --domains {} --non-interactive --standalone --agree-tos --register-unsafely-without-email --dry-run".format(missing_certs))
