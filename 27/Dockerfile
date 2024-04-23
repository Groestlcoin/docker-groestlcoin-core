FROM debian:bullseye-slim

ARG UID=101
ARG GID=101

LABEL maintainer="Groestlcoin developers <groestlcoin@gmail.com>"

RUN groupadd --gid ${GID} groestlcoin \
  && useradd --create-home --no-log-init -u ${UID} -g ${GID} groestlcoin \
  && apt-get update -y \
  && apt-get install -y curl gnupg gosu \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG TARGETPLATFORM
ENV GROESTLCOIN_VERSION=27.0
ENV GROESTLCOIN_DATA=/home/groestlcoin/.groestlcoin
ENV PATH=/opt/groestlcoin-${GROESTLCOIN_VERSION}/bin:$PATH

RUN set -ex \
  && if [ "${TARGETPLATFORM}" = "linux/amd64" ]; then export TARGETPLATFORM=x86_64-linux-gnu; fi \
  && if [ "${TARGETPLATFORM}" = "linux/arm64" ]; then export TARGETPLATFORM=aarch64-linux-gnu; fi \
  && if [ "${TARGETPLATFORM}" = "linux/arm/v7" ]; then export TARGETPLATFORM=arm-linux-gnueabihf; fi \
  && for key in \
  287AE4CA1187C68C08B49CB2D11BD4F33F1DB499 \
  ; do \
  gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key" || \
  gpg --batch --keyserver keys.openpgp.org --recv-keys "$key" || \
  gpg --batch --keyserver pgp.mit.edu --recv-keys "$key" || \
  gpg --batch --keyserver keyserver.pgp.com --recv-keys "$key" || \
  gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
  gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" ; \
  done \
  && curl -SLO https://github.com/Groestlcoin/groestlcoin/releases/download/v${GROESTLCOIN_VERSION}/groestlcoin-${GROESTLCOIN_VERSION}-${TARGETPLATFORM}.tar.gz \
  && curl -SLO https://github.com/Groestlcoin/groestlcoin/releases/download/v${GROESTLCOIN_VERSION}/SHA256SUMS \
  && curl -SLO https://github.com/Groestlcoin/groestlcoin/releases/download/v${GROESTLCOIN_VERSION}/SHA256SUMS.asc \
  && gpg --verify SHA256SUMS.asc SHA256SUMS \
  && grep " groestlcoin-${GROESTLCOIN_VERSION}-${TARGETPLATFORM}.tar.gz" SHA256SUMS | sha256sum -c - \
  && tar -xzf *.tar.gz -C /opt \
  && rm *.tar.gz *.asc \
  && rm -rf /opt/groestlcoin-${GROESTLCOIN_VERSION}/bin/groestlcoin-qt

COPY docker-entrypoint.sh /entrypoint.sh

VOLUME ["/home/groestlcoin/.groestlcoin"]

EXPOSE 1441 1331 17766 17777 18443 18888 31331 31441

ENTRYPOINT ["/entrypoint.sh"]

RUN groestlcoind -version | grep "Groestlcoin Core version v${GROESTLCOIN_VERSION}"

CMD ["groestlcoind"]
