# cloud-lab-image

A public base image for exe.dev lab VMs: exeuntu plus zsh, Rex, single-user Nix with a pinned tool set, and Node 26. Published weekly and on push to `ghcr.io/therapy-rgb/cloud-lab-image`.

## Layout

- `Dockerfile` builds the image.
- `flake.nix` and `flake.lock` are the only copy of the lab tool list. `therapy-rgb/cloud-lab`'s `setup.sh` installs `github:therapy-rgb/cloud-lab-image#default` on open VMs, so a change here reaches both the image and those VMs.

## Build and test

- Build locally: `docker build -t cloud-lab-image .` (or let CI build it). Check the flake with `nix flake check` where Nix is installed.
- Update the pinned tools with `nix flake update`, then commit `flake.lock`.
- Try the image: `ssh exe.dev new --image=ghcr.io/therapy-rgb/cloud-lab-image`.

## Deploy

A push to the default branch builds and publishes the image through GitHub Actions. The branch is `main`.

## Rules

- This repo is public. It holds public software only: no secrets, tokens, client data, or private paths.
- Keep the flake the single source for tools; don't duplicate the list in `cloud-lab`.
