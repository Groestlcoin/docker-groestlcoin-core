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

ENV GROESTLCOIN_VERSION=2.11.0
ENV GROESTLCOIN_DATA=/home/groestlcoin/.groestlcoin
ENV PATH=/opt:$PATH

RUN set -ex \
  && curl -SLO https://github.com/Groestlcoin/groestlcoin/releases/download/v${GROESTLCOIN_VERSION}/groestlcoin-${GROESTLCOIN_VERSION}-linux64.tar.gz \
  && tar -xzf *.tar.gz -C /opt \
  && rm *.tar.gz

COPY docker-entrypoint.sh /entrypoint.sh

VOLUME ["/home/groestlcoin/.groestlcoin"]

EXPOSE 1441 1331 17766 17777 18443 18888

ENTRYPOINT ["/entrypoint.sh"]

CMD ["groestlcoind"]
