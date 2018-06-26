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
RUN raco pkg config --set catalogs \
    "https://download.racket-lang.org/releases/$RACKET_VERSION/catalog/" \
    "https://pkg-build.racket-lang.org/server/built/catalog/" \
    "https://pkgs.racket-lang.org" \
    "https://planet-compats.racket-lang.org"

WORKDIR /src
CMD ["raco", "test", "."]

ONBUILD ADD ./src/info.rkt ./info.rkt
ONBUILD RUN raco pkg install --auto --no-setup
ONBUILD RUN raco setup --no-docs
ONBUILD ADD ./src .
ONBUILD RUN raco setup --no-docs
