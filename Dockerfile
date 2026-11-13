# A prebuilt exe.dev lab image: exeuntu plus everything setup.sh would fetch from the open internet, so a VM
# made with --egress=integrations (no internet, only its integrations) starts ready. Public on purpose:
# it holds only public software. The harness and private repos come at first boot, through integrations.
FROM ghcr.io/boldsoftware/exeuntu:latest
USER root

# zsh, without dpkg's config-file prompt; Rex from Superlogical's apt repository (preview channel).
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq -o Dpkg::Options::=--force-confold zsh curl \
 && curl -fsSL https://pkgs.superlogical.com/rex/install.sh | sh -s -- --channel preview \
 && chsh -s /usr/bin/zsh exedev && rm -rf /var/lib/apt/lists/*

# Nix for exedev alone (single-user, no daemon: a build step has no systemd), with flakes on.
RUN mkdir -m 0755 /nix && chown exedev:exedev /nix
USER exedev
ENV USER=exedev HOME=/home/exedev
RUN curl -fsSL https://nixos.org/nix/install | sh -s -- --no-daemon \
 && mkdir -p ~/.config/nix && echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf

# The lab's tools from the flake, into exedev's profile.
COPY --chown=exedev:exedev flake.nix flake.lock /home/exedev/.lab-image/
RUN . ~/.nix-profile/etc/profile.d/nix.sh && nix profile add /home/exedev/.lab-image#default \
 && nix-collect-garbage -d >/dev/null

# Node for the projects (mise reads .node-version; this is Suburban Dad Mode's), fetched now, not at boot.
RUN . ~/.nix-profile/etc/profile.d/nix.sh && mise use -g node@26.13.0 && mise reshim

USER root
LABEL exe.dev/login-user=exedev
