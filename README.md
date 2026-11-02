# tiny-ai-sandbox

Run Claude Code with permissions bypassed, in a container that mounts only the directory you
launch from.

Each directory gets its own container. Each container is long-lived. AI can install
any updates needed over time.

Not a defense against hostile code. It protects your host filesystem only.


## Install

```sh
./install.sh
```

Builds `aibox:latest` container image, and installs `aibox` executable to `~/.local/bin`.

You must have logged in to claude on the host first.
credential file.

## Use

```sh
cd ~/some/project
aibox                     # open the TUI
aibox --help              # usage, plus this directory's box name
```

Aibox is designed to ONLY launch the claude code TUI - no other features are supported.

## Maintenance

There are no subcommands for this — the state is two objects you can address directly.

```sh
docker container ls --all  # list all containers, some of which will be aibox- containers
docker rm -f aibox-myproject-a3f91c        # reset the container filesystem, keep claude history
rm -rf ~/.local/share/aibox/aibox-myproject-a3f91c   # drop claude history
./install.sh                               # rebuild the base docker image
```

`aibox --help` prints the current directory's box name, so both are copy-pasteable.

