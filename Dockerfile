FROM alpine:3.17

COPY entry.sh /entry.sh

RUN apk update &&\
        apk add python3 py3-pip curl && \
        wget -o /usr/local/bin/kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
        chmod +x /usr/local/bin/kubectl && \
        chmod +x /entry.sh

ENTRYPOINT ["/entry.sh"]