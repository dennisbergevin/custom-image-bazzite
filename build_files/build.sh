#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Install packages

# this installs a package from fedora repos
dnf5 -y install \
  niri \
  noctalia \
  alacritty \
  foot \
  xdg-desktop-portal-gtk \
  nautilus \
  brightnessctl \
  xwayland-satellite

### Install Brave Origin from Official Repository
echo "Installing Brave Origin..."

dnf5 -y install dnf-plugins-core

dnf5 config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo

dnf5 -y install brave-origin

# Remove the build-time Brave repository.
rm -f /etc/yum.repos.d/brave-browser.repo

echo "Brave Origin installed successfully"

### Install 1Password from Official Repository
echo "Installing 1Password..."

# Add 1Password RPM repository GPG key
rpm --import https://downloads.1password.com/linux/keys/1password.asc

# Add 1Password RPM repository
cat >/etc/yum.repos.d/1password.repo <<'EOF'
[1password]
name=1Password Stable Channel
baseurl=https://downloads.1password.com/linux/rpm/stable/$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://downloads.1password.com/linux/keys/1password.asc
EOF

# Install 1Password
dnf5 install -y 1password

# Clean up repo file (required - repos don't work at runtime in bootc images)
rm -f /etc/yum.repos.d/1password.repo

echo "1Password installed successfully"
echo "Brave Origin and 1Password installation complete!"

systemctl enable podman.socket

# Clean up boot artifacts from base image
rm -rf /boot/extlinux

# Clean up runtime-only directories
rm -rf /run/dnf

# Clean up dnf state (repos, lock, countme, cache)
rm -rf /var/lib/dnf
