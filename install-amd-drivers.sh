#!/bin/bash
set -e

# Install AMD GPU drivers via amdgpu-install (the official AMD installer
# that bundles AMDGPU graphics + optional ROCm compute stack).
# See https://amdgpu-install.readthedocs.io/ and
# https://www.amd.com/en/support/linux-drivers for the latest version.
#
# Override the AMDGPU_VERSION / AMDGPU_PKG / USECASE if you want a different
# release or a different mix of components.
AMDGPU_VERSION="${AMDGPU_VERSION:-6.3.2}"
AMDGPU_PKG="${AMDGPU_PKG:-amdgpu-install_6.3.60302-1_all.deb}"
USECASE="${USECASE:-graphics,rocm}"   # other options: graphics, rocm, workstation, hip, opencl, lrt

CODENAME="$(lsb_release -cs)"
URL="https://repo.radeon.com/amdgpu-install/${AMDGPU_VERSION}/ubuntu/${CODENAME}/${AMDGPU_PKG}"

cd /tmp
echo "Downloading ${URL}..."
wget -q "$URL" -O "$AMDGPU_PKG"

# Install the installer package, refresh apt indices, then run the installer.
sudo apt-get update
sudo apt-get install -y "./${AMDGPU_PKG}"
rm "$AMDGPU_PKG"

sudo amdgpu-install -y --usecase="${USECASE}"

# AMD ROCm/render access requires membership in the render and video groups.
sudo usermod -aG render,video "$USER"

echo
echo "AMD drivers installed (usecase: ${USECASE})."
echo "You were added to the 'render' and 'video' groups — log out & back in (or reboot) for it to take effect."
echo "After reboot, verify with: rocminfo  (if ROCm was installed) or  glxinfo | grep -i 'opengl renderer'"
