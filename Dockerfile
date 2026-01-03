FROM certbot/certbot:latest

RUN pip install --no-cache-dir certbot-dns-dnspod

ENTRYPOINT ["certbot"]
