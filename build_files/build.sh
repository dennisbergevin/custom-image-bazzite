#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Install packages

# this installs a package from fedora repos
dnf5 -y install \
  niri \
  noctalia-shell \
  foot \
  xdg-desktop-portal-gtk \
  nautilus \
  brightnessctl \
  xwayland-satellite

systemctl enable podman.socket
