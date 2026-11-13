# cloud-lab-image

A public base image for exe.dev lab VMs: [exeuntu](https://github.com/boldsoftware/exeuntu) plus zsh, Rex, Nix (single-user) with a pinned tool set, and Node 26. Built weekly and on push to `ghcr.io/therapy-rgb/cloud-lab-image`. It holds public software only.

    ssh exe.dev new --image=ghcr.io/therapy-rgb/cloud-lab-image

The flake here is the only copy of the lab tool list: `therapy-rgb/cloud-lab`'s `setup.sh` installs it from `github:therapy-rgb/cloud-lab-image#default` on open VMs, so a change here reaches both the image and those VMs.
