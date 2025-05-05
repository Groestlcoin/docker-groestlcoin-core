# Build stage for BerkeleyDB
FROM alpine:3.16.0 as berkeleydb

RUN sed -i 's/http\:\/\/dl-cdn.alpinelinux.org/https\:\/\/alpine.global.ssl.fastly.net/g' /etc/apk/repositories
RUN apk --no-cache add autoconf
RUN apk --no-cache add automake
RUN apk --no-cache add build-base
RUN apk --no-cache add libressl

ENV BERKELEYDB_VERSION=db-5.3.28.NC
ENV BERKELEYDB_PREFIX=/opt/${BERKELEYDB_VERSION}

RUN wget https://download.oracle.com/berkeley-db/${BERKELEYDB_VERSION}.tar.gz
RUN tar -xzf *.tar.gz
RUN sed s/__atomic_compare_exchange/__atomic_compare_exchange_db/g -i ${BERKELEYDB_VERSION}/src/dbinc/atomic.h
RUN sed s/atomic_init/atomic_init_db/g -i ${BERKELEYDB_VERSION}/src/dbinc/atomic.h ${BERKELEYDB_VERSION}/src/mp/mp_region.c ${BERKELEYDB_VERSION}/src/mp/mp_mvcc.c ${BERKELEYDB_VERSION}/src/mp/mp_fget.c ${BERKELEYDB_VERSION}/src/mutex/mut_method.c ${BERKELEYDB_VERSION}/src/mutex/mut_tas.c
RUN sed s/WinIoCtl.h/winioctl.h/g -i ${BERKELEYDB_VERSION}/src/dbinc/win_db.h
RUN mkdir -p ${BERKELEYDB_PREFIX}

WORKDIR /${BERKELEYDB_VERSION}/build_unix

RUN ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=${BERKELEYDB_PREFIX} --build=aarch64-unknown-linux-gnu
RUN make -j4
RUN make install
RUN rm -rf ${BERKELEYDB_PREFIX}/docs

# Build stage for Groestlcoin Core
FROM alpine:3.16.0 as groestlcoin-core

COPY --from=berkeleydb /opt /opt

RUN sed -i 's/http\:\/\/dl-cdn.alpinelinux.org/https\:\/\/alpine.global.ssl.fastly.net/g' /etc/apk/repositories
RUN apk --no-cache add autoconf
RUN apk --no-cache add automake
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

ENV GROESTLCOIN_VERSION=25.0
ENV GROESTLCOIN_PREFIX=/opt/groestlcoin-${GROESTLCOIN_VERSION}

RUN wget https://github.com/Groestlcoin/groestlcoin/releases/download/v${GROESTLCOIN_VERSION}/SHA256SUMS
RUN wget https://github.com/Groestlcoin/groestlcoin/releases/download/v${GROESTLCOIN_VERSION}/SHA256SUMS.asc
RUN wget https://github.com/Groestlcoin/groestlcoin/releases/download/v${GROESTLCOIN_VERSION}/groestlcoin-${GROESTLCOIN_VERSION}.tar.gz
RUN gpg --verify SHA256SUMS.asc SHA256SUMS
RUN grep " groestlcoin-${GROESTLCOIN_VERSION}.tar.gz\$" SHA256SUMS | sha256sum -c -
RUN tar -xzf *.tar.gz

WORKDIR /groestlcoin-${GROESTLCOIN_VERSION}

RUN sed -i s:sys/fcntl.h:fcntl.h: src/compat/compat.h
RUN ./autogen.sh
RUN ./configure LDFLAGS=-L`ls -d /opt/db*`/lib/ CPPFLAGS=-I`ls -d /opt/db*`/include/ \
  --prefix=${GROESTLCOIN_PREFIX} \
  --mandir=/usr/share/man \
  --disable-tests \
  --disable-bench \
  --disable-ccache \
  --with-gui=no \
  --with-utils \
  --with-libs \
  --with-sqlite=yes \
  --with-daemon
RUN make -j4
RUN make install
RUN strip ${GROESTLCOIN_PREFIX}/bin/groestlcoin-cli
RUN strip ${GROESTLCOIN_PREFIX}/bin/groestlcoin-tx
RUN strip ${GROESTLCOIN_PREFIX}/bin/groestlcoind
RUN strip ${GROESTLCOIN_PREFIX}/lib/libgroestlcoinconsensus.a
RUN strip ${GROESTLCOIN_PREFIX}/lib/libgroestlcoinconsensus.so.0.0.0

# Build stage for compiled artifacts
FROM alpine

ARG UID=100
ARG GID=101

LABEL maintainer="Groestlcoin developers <groestlcoin@gmail.com>"

RUN addgroup groestlcoin --gid ${GID} --system
RUN adduser --uid ${UID} --system groestlcoin --ingroup groestlcoin
RUN sed -i 's/http\:\/\/dl-cdn.alpinelinux.org/https\:\/\/alpine.global.ssl.fastly.net/g' /etc/apk/repositories
RUN apk --no-cache add \
  libevent \
  libzmq \
  shadow \
  sqlite-dev \
  su-exec

ENV GROESTLCOIN_DATA=/home/groestlcoin/.groestlcoin
ENV GROESTLCOIN_VERSION=25.0
ENV GROESTLCOIN_PREFIX=/opt/groestlcoin-${GROESTLCOIN_VERSION}
ENV PATH=${GROESTLCOIN_PREFIX}/bin:$PATH

COPY --from=groestlcoin-core /opt /opt
COPY docker-entrypoint.sh /entrypoint.sh

VOLUME ["/home/groestlcoin/.groestlcoin"]

EXPOSE 1441 1331 17766 17777 18443 18888 31331 31441

ENTRYPOINT ["/entrypoint.sh"]

RUN groestlcoind -version | grep "Groestlcoin Core version v${GROESTLCOIN_VERSION}"

CMD ["groestlcoind"]
