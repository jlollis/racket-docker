FROM buildpack-deps:stable
MAINTAINER Jack Firth <jackhfirth@gmail.com>

ARG RACKET_INSTALLER_URL
ARG RACKET_VERSION

RUN wget --output-document=racket-install.sh -q $RACKET_INSTALLER_URL && \
    sh racket-install.sh --create-dir --unix-style && \
    rm racket-install.sh

ENV SSL_CERT_FILE="/usr/lib/ssl/cert.pem"
ENV SSL_CERT_DIR="/usr/lib/ssl/certs"

RUN raco setup

CMD ["racket"]
