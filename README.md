# groestlcoin/groestlcoin-core

A groestlcoin-core docker image with support for the following platforms:

* `amd64` (x86_64)
* `arm32v7` (armv7)
* `arm64` (aarch64, armv8)

[![groestlcoin/groestlcoin-core][docker-pulls-image]][docker-hub-url] [![groestlcoin/groestlcoin-core][docker-stars-image]][docker-hub-url] [![groestlcoin/groestlcoin-core][docker-size-image]][docker-hub-url]

## Tags

- `25`, `latest` ([24/Dockerfile](https://github.com/groestlcoin/docker-groestlcoin-core/blob/master/25/Dockerfile)) [**multi-arch**]
- `25-alpine` ([24/alpine/Dockerfile](https://github.com/groestlcoin/docker-groestlcoin-core/blob/master/25/alpine/Dockerfile))

- `24` ([24/Dockerfile](https://github.com/groestlcoin/docker-groestlcoin-core/blob/master/24/Dockerfile)) [**multi-arch**]
- `24-alpine` ([24/alpine/Dockerfile](https://github.com/groestlcoin/docker-groestlcoin-core/blob/master/24/alpine/Dockerfile))

- `23` ([23/Dockerfile](https://github.com/groestlcoin/docker-groestlcoin-core/blob/master/23/Dockerfile)) [**multi-arch**]
- `23-alpine` ([23/alpine/Dockerfile](https://github.com/groestlcoin/docker-groestlcoin-core/blob/master/23/alpine/Dockerfile))

- `22`, ([22/Dockerfile](https://github.com/groestlcoin/docker-groestlcoin-core/blob/master/22/Dockerfile)) [**multi-arch**]
- `22-alpine` ([22/alpine/Dockerfile](https://github.com/groestlcoin/docker-groestlcoin-core/blob/master/22/alpine/Dockerfile))

- `2.21` ([2.21/Dockerfile](https://github.com/groestlcoin/docker-groestlcoin-core/blob/master/2.21/Dockerfile)) [**multi-arch**]
- `2.21-alpine` ([2.21/alpine/Dockerfile](https://github.com/groestlcoin/docker-groestlcoin-core/blob/master/2.21/alpine/Dockerfile))

- `2.20` ([2.20/Dockerfile](https://github.com/groestlcoin/docker-groestlcoin-core/blob/master/2.20/Dockerfile)) [**multi-arch**]
- `2.20-alpine` ([2.20/alpine/Dockerfile](https://github.com/groestlcoin/docker-groestlcoin-core/blob/master/2.20/alpine/Dockerfile))

- `2.19` ([2.19/Dockerfile](https://github.com/groestlcoin/docker-groestlcoin-core/blob/master/2.19/Dockerfile)) [**multi-arch**]
- `2.19-alpine` ([2.19/alpine/Dockerfile](https://github.com/groestlcoin/docker-groestlcoin-core/blob/master/2.19/alpine/Dockerfile))

- `2.18`, ([2.18/Dockerfile](https://github.com/groestlcoin/docker-groestlcoin-core/blob/master/2.18/Dockerfile)) [**multi-arch**]
- `2.18-alpine` ([2.18/alpine/Dockerfile](https://github.com/groestlcoin/docker-groestlcoin-core/blob/master/2.18/alpine/Dockerfile))

- `2.17` ([2.17/Dockerfile](https://github.com/groestlcoin/docker-groestlcoin-core/blob/master/2.17/Dockerfile)) [**multi-arch**]
- `2.17-alpine` ([2.17/alpine/Dockerfile](https://github.com/groestlcoin/docker-groestlcoin-core/blob/master/2.17/alpine/Dockerfile))

- `2.16` ([2.16/Dockerfile](https://github.com/groestlcoin/docker-groestlcoin-core/blob/master/2.16/Dockerfile)) [**multi-arch**]
- `2.16-alpine` ([2.16/alpine/Dockerfile](https://github.com/groestlcoin/docker-groestlcoin-core/blob/master/2.16/alpine/Dockerfile))

**Multi-architecture builds**

The newest images (Debian-based, *2.13+*) provide built-in support for multiple architectures. Running `docker pull` on any of the supported platforms will automatically choose the right image for you as all of the manifests and artifacts are pushed to the Docker registry.

**Picking the right tag**

- `groestlcoin/groestlcoin-core:latest`: points to the latest stable release available of Groestlcoin Core. Caution when using in production as blindly upgrading Groestlcoin Core is a risky procedure.
- `groestlcoin/groestlcoin-core:alpine`: same as above but using the Alpine Linux distribution (a resource efficient Linux distribution with security in mind, but not officially supported by the Groestlcoin Core team — use at your own risk).
- `groestlcoin/groestlcoin-core:<version>`: based on a slim Debian image, this tag format points to a specific version branch (e.g. `2.20`). Uses the pre-compiled binaries which are distributed by the Groestlcoin Core team.
- `groestlcoin/groestlcoin-core:<version>-alpine`: same as above but using the Alpine Linux distribution.

## What is Groestlcoin Core?

Groestlcoin Core is a reference client that implements the Groestlcoin protocol for remote procedure call (RPC) use. It is also the second Groestlcoin client in the network's history..

## Usage

### How to use this image

This image contains the main binaries from the Groestlcoin Core project - `groestlcoind`, `groestlcoin-cli` and `groestlcoin-tx`. It behaves like a binary, so you can pass any arguments to the image and they will be forwarded to the `groestlcoind` binary:

```sh
❯ docker run --rm -it groestlcoin/groestlcoin-core \
  -printtoconsole \
  -regtest=1 \
  -rpcallowip=172.17.0.0/16 \
  -rpcauth='foo:7d9ba5ae63c3d4dc30583ff4fe65a67e$9e3634e81c11659e3de036d0bf88f89cd169c1039e6e09607562d54765c649cc'
```

_Note: [learn more](#using-rpcauth-for-remote-authentication) about how `-rpcauth` works for remote authentication._

By default, `groestlcoind` will run as user `groestlcoin` in the group `groestlcoin` for security reasons and with its default data dir set to `~/.groestlcoin`. If you'd like to customize where `groestlcoin-core` stores its data, you must use the `GROESTLCOIN_DATA` environment variable. The directory will be automatically created with the correct permissions for the `groestlcoin` user and `groestlcoind` automatically configured to use it.

```sh
❯ docker run --env GROESTLCOIN_DATA=/var/lib/groestlcoin-core --rm -it groestlcoin/groestlcoin-core \
  -printtoconsole \
  -regtest=1
```

You can also mount a directory in a volume under `/home/groestlcoin/.groestlcoin` in case you want to access it on the host:

```sh
❯ docker run -v ${PWD}/data:/home/groestlcoin/.groestlcoin -it --rm groestlcoin/groestlcoin-core \
  -printtoconsole \
  -regtest=1
```

You can optionally create a service using `docker-compose`:

```yml
groestlcoin-core:
  image: groestlcoin/groestlcoin-core
  command:
    -printtoconsole
    -regtest=1
```

### Using a custom user id (UID) and group id (GID)

By default, images are created with a `groestlcoin` user/group using a static UID/GID (`101:101` on Debian and `100:101` on Alpine). You may customize the user and group ids using the build arguments `UID` (`--build-arg UID=<uid>`) and `GID` (`--build-arg GID=<gid>`).

If you'd like to use the pre-built images, uou can also customize the UID/GID on runtime via environment variables `$UID` and `$GID`:

```sh
❯ docker run -e UID=10000 -e GID=10000 -it --rm groestlcoin/groestlcoin-core \
  -printtoconsole \
  -regtest=1
```

This will recursively change the ownership of the `groestlcoin` home directory and `$GROESTLCOIN_DATA` to UID/GID `10000:10000`.

### Using RPC to interact with the daemon

There are two communications methods to interact with a running Groestlcoin Core daemon.

The first one is using a cookie-based local authentication. It doesn't require any special authentication information as running a process locally under the same user that was used to launch the Groestlcoin Core daemon allows it to read the cookie file previously generated by the daemon for clients. The downside of this method is that it requires local machine access.

The second option is making a remote procedure call using a username and password combination. This has the advantage of not requiring local machine access, but in order to keep your credentials safe you should use the newer `rpcauth` authentication mechanism.

#### Using cookie-based local authentication

Start by launch the Groestlcoin Core daemon:

```sh
❯ docker run --rm --name groestlcoin-server -it groestlcoin/groestlcoin-core \
  -printtoconsole \
  -regtest=1
```

Then, inside the running `groestlcoin-server` container, locally execute the query to the daemon using `groestlcoin-cli`:

```sh
❯ docker exec --user groestlcoin groestlcoin-server groestlcoin-cli -regtest getmininginfo

{
  "blocks": 0,
  "currentblocksize": 0,
  "currentblockweight": 0,
  "currentblocktx": 0,
  "difficulty": 4.656542373906925e-10,
  "errors": "",
  "networkhashps": 0,
  "pooledtx": 0,
  "chain": "regtest"
}
```

In the background, `groestlcoin-cli` read the information automatically from `/home/groestlcoin/.groestlcoin/regtest/.cookie`. In production, the path would not contain the regtest part.

#### Using rpcauth for remote authentication

Before setting up remote authentication, you will need to generate the `rpcauth` line that will hold the credentials for the Groestlcoind Core daemon. You can either do this yourself by constructing the line with the format `<user>:<salt>$<hash>` or use the official [`rpcauth.py`](https://github.com/groestlcoin/groestlcoin/blob/master/share/rpcauth/rpcauth.py)  script to generate this line for you, including a random password that is printed to the console.

_Note: This is a Python 3 script. use `[...] | python3 - <username>` when executing on macOS._

Example:

```sh
❯ curl -sSL https://raw.githubusercontent.com/groestlcoin/groestlcoin/master/share/rpcauth/rpcauth.py | python - <username>

String to be appended to groestlcoin.conf:
rpcauth=foo:7d9ba5ae63c3d4dc30583ff4fe65a67e$9e3634e81c11659e3de036d0bf88f89cd169c1039e6e09607562d54765c649cc
Your password:
qDDZdeQ5vw9XXFeVnXT4PZ--tGN2xNjjR4nrtyszZx0=
```

Note that for each run, even if the username remains the same, the output will be always different as a new salt and password are generated.

Now that you have your credentials, you need to start the Groestlcoin Core daemon with the `-rpcauth` option. Alternatively, you could append the line to a `groestlcoin.conf` file and mount it on the container.

Let's opt for the Docker way:

```sh
❯ docker run --rm --name groestlcoin-server -it groestlcoin/groestlcoin-core \
  -printtoconsole \
  -regtest=1 \
  -rpcallowip=172.17.0.0/16 \
  -rpcauth='foo:7d9ba5ae63c3d4dc30583ff4fe65a67e$9e3634e81c11659e3de036d0bf88f89cd169c1039e6e09607562d54765c649cc'
```

Two important notes:

1. Some shells require escaping the rpcauth line (e.g. zsh), as shown above.
2. It is now perfectly fine to pass the rpcauth line as a command line argument. Unlike `-rpcpassword`, the content is hashed so even if the arguments would be exposed, they would not allow the attacker to get the actual password.

You can now connect via `groestlcoin-cli`. You will still have to define a username and password when connecting to the Groestlcoin Core RPC server.

To avoid any confusion about whether or not a remote call is being made, let's spin up another container to execute `groestlcoin-cli` and connect it via the Docker network using the password generated above:

```sh
❯ docker run -it --link groestlcoin-server --rm groestlcoin/groestlcoin-core \
  groestlcoin-cli \
  -rpcconnect=groestlcoin-server \
  -regtest \
  -rpcuser=foo\
  -stdinrpcpass \
  getbalance
```

Enter the password `qDDZdeQ5vw9XXFeVnXT4PZ--tGN2xNjjR4nrtyszZx0=` and hit enter:

```
0.00000000
```

Note: under Groestlcoin Core < 2.16, use `-rpcpassword="qDDZdeQ5vw9XXFeVnXT4PZ--tGN2xNjjR4nrtyszZx0="` instead of `-stdinrpcpass`.

Done!

### Exposing Ports

Depending on the network (mode) the Groestlcoin Core daemon is running as well as the chosen runtime flags, several default ports may be available for mapping.

Ports can be exposed by mapping all of the available ones (using `-P` and based on what `EXPOSE` documents) or individually by adding `-p`. This mode allows assigning a dynamic port on the host (`-p <port>`) or assigning a fixed port `-p <hostPort>:<containerPort>`.

Example for running a node in `regtest` mode mapping JSON-RPC/REST (18443) and P2P (18888) ports:

```sh
docker run --rm -it \
  -p 18443:18443 \
  -p 18888:18888 \
  groestlcoin/groestlcoin-core \
  -printtoconsole \
  -regtest=1 \
  -rpcallowip=172.17.0.0/16 \
  -rpcbind=0.0.0.0 \
  -rpcauth='foo:7d9ba5ae63c3d4dc30583ff4fe65a67e$9e3634e81c11659e3de036d0bf88f89cd169c1039e6e09607562d54765c649cc'
```

To test that mapping worked, you can send a JSON-RPC curl request to the host port:

```
curl --data-binary '{"jsonrpc":"1.0","id":"1","method":"getnetworkinfo","params":[]}' http://foo:qDDZdeQ5vw9XXFeVnXT4PZ--tGN2xNjjR4nrtyszZx0=@127.0.0.1:18443/
```

#### Mainnet

- JSON-RPC/REST: 1441
- P2P: 1331

#### Testnet

- Testnet JSON-RPC: 17766
- P2P: 17777

#### Regtest

- JSON-RPC/REST: 18443
- P2P: 18888

#### Signet

- JSON-RPC/REST: 31441
- P2P: 31331

## Archived tags

For historical reasons, the following tags are still available and automatically updated when the underlying base image (_Alpine Linux_ or _Debian stable_) is updated as well:

- `2.13` ([2.13/Dockerfile](https://github.com/groestlcoin/docker-groestlcoin-core/blob/master/2.13/Dockerfile)) [**multi-arch**]
- `2.13-alpine` ([2.13/alpine/Dockerfile](https://github.com/groestlcoin/docker-groestlcoin-core/blob/master/2.13/alpine/Dockerfile))

- `2.11` ([2.11/Dockerfile](https://github.com/groestlcoin/docker-groestlcoin-core/blob/master/2.11/Dockerfile))
- `2.11-alpine` ([2.11/alpine/Dockerfile](https://github.com/groestlcoin/docker-groestlcoin-core/blob/master/2.11/alpine/Dockerfile))

## Docker

This image is officially supported on Docker version 17.09, with support for older versions provided on a best-effort basis.

## License

[License information](https://github.com/groestlcoin/groestlcoin/blob/master/COPYING) for the software contained in this image.

[License information](https://github.com/groestlcoin/docker-groestlcoin-core/blob/master/LICENSE) for the [groestlcoin/groestlcoin-core][docker-hub-url] docker project.

[docker-hub-url]: https://hub.docker.com/r/groestlcoin/groestlcoin-core
[docker-pulls-image]: https://img.shields.io/docker/pulls/groestlcoin/groestlcoin-core.svg?style=flat-square
[docker-size-image]: https://img.shields.io/docker/image-size/groestlcoin/groestlcoin-core?style=flat-square
[docker-stars-image]: https://img.shields.io/docker/stars/groestlcoin/groestlcoin-core.svg?style=flat-square
