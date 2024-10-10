#!/bin/sh
set -e

if [ -n "${UID+x}" ] && [ "${UID}" != "0" ]; then
  usermod -u "$UID" groestlcoin
fi

if [ -n "${GID+x}" ] && [ "${GID}" != "0" ]; then
  groupmod -g "$GID" groestlcoin
fi

echo "$0: assuming uid:gid for groestlcoin:groestlcoin of $(id -u groestlcoin):$(id -g groestlcoin)"

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for groestlcoind"

  set -- groestlcoind "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "groestlcoind" ]; then
  mkdir -p "$GROESTLCOIN_DATA"
  chmod 700 "$GROESTLCOIN_DATA"
  # Fix permissions for home dir.
  chown -R groestlcoin:groestlcoin "$(getent passwd groestlcoin | cut -d: -f6)"
  # Fix permissions for groestlcoin data dir.
  chown -R groestlcoin:groestlcoin "$GROESTLCOIN_DATA"

  echo "$0: setting data directory to $GROESTLCOIN_DATA"

  set -- "$@" -datadir="$GROESTLCOIN_DATA"
fi

if [ "$1" = "groestlcoind" ] || [ "$1" = "groestlcoin-wallet" ] || [ "$1" = "groestlcoin-util" ] || [ "$1" = "groestlcoin-cli" ] || [ "$1" = "groestlcoin-tx" ]; then
  echo
  exec su-exec groestlcoin "$@"
fi

echo
exec "$@"
