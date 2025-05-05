# Build stage for Groestlcoin Core
FROM alpine:3.21.0 as groestlcoin-core

ENV GNUPGHOME=/tmp/gnupg

RUN sed -i 's/http\:\/\/dl-cdn.alpinelinux.org/https\:\/\/alpine.global.ssl.fastly.net/g' /etc/apk/repositories
RUN apk --no-cache add cmake
RUN apk --no-cache add boost-dev
RUN apk --no-cache add build-base
RUN apk --no-cache add chrpath
RUN apk --no-cache add file
RUN apk --no-cache add gnupg
RUN apk --no-cache add libevent-dev
RUN apk --no-cache add libressl
RUN apk --no-cache add libtool
RUN apk --no-cache add linux-headers
RUN apk --no-cache add sqlite-dev
RUN apk --no-cache add zeromq-dev
RUN mkdir -p ${GNUPGHOME}
RUN set -ex \
  && for key in \
  287AE4CA1187C68C08B49CB2D11BD4F33F1DB499 \
  ; do \
  gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key" || \
  gpg --batch --keyserver keys.openpgp.org --recv-keys "$key" || \
  gpg --batch --keyserver keyserver.pgp.com --recv-keys "$key" || \
  gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
  gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" ; \
  done

ENV GROESTLCOIN_VERSION=29.0
ENV GROESTLCOIN_PREFIX=/opt/groestlcoin-${GROESTLCOIN_VERSION}

RUN wget https://github.com/Groestlcoin/groestlcoin/releases/download/v${GROESTLCOIN_VERSION}/SHA256SUMS
RUN wget https://github.com/Groestlcoin/groestlcoin/releases/download/v${GROESTLCOIN_VERSION}/SHA256SUMS.asc
RUN wget https://github.com/Groestlcoin/groestlcoin/releases/download/v${GROESTLCOIN_VERSION}/groestlcoin-${GROESTLCOIN_VERSION}.tar.gz
RUN gpg --verify SHA256SUMS.asc SHA256SUMS
RUN grep " groestlcoin-${GROESTLCOIN_VERSION}.tar.gz\$" SHA256SUMS | sha256sum -c -
RUN tar -xzf *.tar.gz

WORKDIR /groestlcoin-${GROESTLCOIN_VERSION}

RUN cmake -B build \
    -DWITH_QRENCODE=OFF \
    -DBUILD_TESTS=OFF \
    -DWITH_ZMQ=ON \
    -DCMAKE_INSTALL_PREFIX=${GROESTLCOIN_PREFIX}
RUN cmake --build build -j4
RUN cmake --install build
RUN strip ${GROESTLCOIN_PREFIX}/bin/groestlcoin-cli
RUN strip ${GROESTLCOIN_PREFIX}/bin/groestlcoind

# Build stage for compiled artifacts
FROM alpine:3.21.0

ARG UID=100
ARG GID=101

LABEL maintainer="Groestlcoin developers <groestlcoin@gmail.com>"

RUN addgroup groestlcoin --gid ${GID} --system
RUN adduser --uid ${UID} --system groestlcoin --ingroup groestlcoin
RUN sed -i 's/http\:\/\/dl-cdn.alpinelinux.org/https\:\/\/alpine.global.ssl.fastly.net/g' /etc/apk/repositories
RUN apk --no-cache add \
  boost-filesystem \
  boost-system \
  boost-thread \
  libevent \
  libzmq \
  shadow \
  sqlite-dev \
  su-exec

ENV GROESTLCOIN_DATA=/home/groestlcoin/.groestlcoin
ENV GROESTLCOIN_VERSION=29.0
ENV GROESTLCOIN_PREFIX=/opt/groestlcoin-${GROESTLCOIN_VERSION}
ENV PATH=${GROESTLCOIN_PREFIX}/bin:$PATH

COPY --from=groestlcoin-core /opt /opt
COPY docker-entrypoint.sh /entrypoint.sh

VOLUME ["/home/groestlcoin/.groestlcoin"]

EXPOSE 1441 1331 17766 17777 18443 18888 31331 31441

ENTRYPOINT ["/entrypoint.sh"]

RUN groestlcoind -version | grep "Groestlcoin Core daemon version v${GROESTLCOIN_VERSION}"

CMD ["groestlcoind"]
