FROM scaleway/cli:2.40

WORKDIR /app

COPY snapshot-clean.sh .
COPY snapshot-create.sh .

RUN apk add --no-cache jq

RUN chmod +x *.sh

ENTRYPOINT ["/bin/sh", "/app/snapshot-clean.sh"]
