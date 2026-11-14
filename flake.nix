{
  # The cloud lab's tools (02.16 Projects/cloud-lab.md, step 4). Nix as a package manager on
  # exe.dev's Ubuntu image, not NixOS. `nix profile install .` puts them on PATH; `nix flake update`
  # moves every pin at once, and flake.lock records exactly what's installed.
  description = "Tools for the exe.dev cloud lab";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAll = f: nixpkgs.lib.genAttrs systems (s: f nixpkgs.legacyPackages.${s});
    in {
      packages = forAll (pkgs: {
        default = pkgs.buildEnv {
          name = "lab-tools";
          paths = with pkgs; [
            # The harness's needs: chezmoi applies it; its hooks and scripts call these.
            chezmoi git gh jq ripgrep fd python3 sqlite coreutils findutils
            # Projects: mise reads each repo's .node-version, like on the Lenovo.
            mise
            # Shell, matching the Lenovo's prompt.
            starship
            # Shell helpers the harness .zshrc calls at startup (else "command not found").
            direnv atuin zoxide
            # The Lenovo's zsh and its plugins, read from ~/.nix-profile/share on lab hosts (2026-11-13). The login
            # shell is this zsh (setup.sh), not Ubuntu's: fzf-tab's module is built for it and won't load in Ubuntu's.
            zsh fzf zsh-autosuggestions zsh-syntax-highlighting zsh-fzf-tab carapace eza
            # web-estate's Research build (pandoc for markdown, ImageMagick's magick for images), for the
            # mirror and fake-data previews (estate-zones.md, steps 5 and A).
            pandoc imagemagick
          ];
        };
      });
    };
}
