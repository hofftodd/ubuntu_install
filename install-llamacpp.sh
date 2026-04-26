#!/bin/bash
set -e

# Build llama.cpp from source. See https://github.com/ggml-org/llama.cpp
# Set BACKEND to enable GPU acceleration:
#   BACKEND=vulkan (default) — cross-vendor GPU via Vulkan
#   BACKEND=cpu    — CPU-only build
#   BACKEND=cuda   — NVIDIA CUDA (requires nvcc)
#   BACKEND=hip    — AMD ROCm/HIP (requires ROCm toolchain)
BACKEND="${BACKEND:-vulkan}"
SRC_DIR="${LLAMACPP_DIR:-$HOME/src/llama.cpp}"

# Build prerequisites.
sudo apt-get update
sudo apt-get install -y build-essential cmake git curl libcurl4-openssl-dev

# Backend-specific extras.
case "$BACKEND" in
    vulkan)
        sudo apt-get install -y libvulkan-dev glslc glslang-tools spirv-headers
        ;;
    cuda|hip|cpu)
        : # cuda/hip toolchains are user-managed; cpu needs nothing extra
        ;;
    *)
        echo "Unknown BACKEND: $BACKEND" >&2
        exit 1
        ;;
esac

# Clone or update.
mkdir -p "$(dirname "$SRC_DIR")"
if [ -d "$SRC_DIR/.git" ]; then
    echo "Updating existing checkout at $SRC_DIR..."
    git -C "$SRC_DIR" pull --ff-only
else
    git clone https://github.com/ggml-org/llama.cpp "$SRC_DIR"
fi

# Configure with selected backend.
CMAKE_FLAGS=()
case "$BACKEND" in
    cuda)   CMAKE_FLAGS+=(-DGGML_CUDA=ON) ;;
    hip)    CMAKE_FLAGS+=(-DGGML_HIP=ON) ;;
    vulkan) CMAKE_FLAGS+=(-DGGML_VULKAN=ON) ;;
esac

cmake -S "$SRC_DIR" -B "$SRC_DIR/build" "${CMAKE_FLAGS[@]}"
cmake --build "$SRC_DIR/build" --config Release -j"$(nproc)"

# Symlink the main binaries onto PATH.
mkdir -p "$HOME/.local/bin"
for bin in llama-cli llama-server llama-quantize llama-bench; do
    if [ -f "$SRC_DIR/build/bin/$bin" ]; then
        ln -sf "$SRC_DIR/build/bin/$bin" "$HOME/.local/bin/$bin"
    fi
done

echo "llama.cpp built ($BACKEND) at $SRC_DIR/build"
echo "Binaries symlinked into ~/.local/bin (llama-cli, llama-server, ...)"
echo "Try: llama-cli --help"
