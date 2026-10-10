#!/usr/bin/env bash
# Runs inside a fresh OrbStack Ubuntu machine; `make vm-create` passes it in.
set -euo pipefail

branch=${1:-}

# zsh goes in before Nix so that the installer also hooks /etc/zsh/zshrc.
sudo apt-get update
sudo apt-get install -y docker-compose-v2 docker.io git make xz-utils zsh

# BuildKit cannot mount overlays on the containerd image store inside an
# OrbStack machine (EPERM), while the classic overlay2 store builds fine.
echo '{"features":{"containerd-snapshotter":false}}' | sudo tee /etc/docker/daemon.json >/dev/null
sudo systemctl restart docker
sudo usermod -aG docker "$USER"

if ! test -x /nix/var/nix/profiles/default/bin/nix; then
  nix_conf=$(mktemp)
  echo 'experimental-features = nix-command flakes' >"$nix_conf"
  curl --proto '=https' --tlsv1.2 -sSf -L https://nixos.org/nix/install |
    sh -s -- --daemon --yes --nix-extra-conf-file "$nix_conf"
fi
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

dotfiles=$HOME/ghq/github.com/kazu728/dotfiles
test -d "$dotfiles" || nix run nixpkgs#ghq -- get kazu728/dotfiles
cd "$dotfiles"
if [ -n "$branch" ]; then
  git switch "$branch"
fi
git pull --ff-only
make switch

curl -fsSL https://claude.ai/install.sh | bash
sudo chsh -s /usr/bin/zsh "$USER"
