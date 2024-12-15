#!/bin/sh

# Detect the architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        ARCH="x86_64"
        ;;
    arm64 | aarch64)
        ARCH="aarch64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# Detect the operating system
OS=$(uname -s)
case $OS in
    Darwin)
        OS="apple-darwin"
        ;;
    Linux)
        OS="unknown-linux-gnu"
        ;;
    MINGW* | MSYS* | CYGWIN* | Windows_NT)
        OS="pc-windows-msvc"
        ;;
    *)
        echo "Unsupported operating system: $OS"
        exit 1
        ;;
esac

VERSION="v0.2.2"
FILENAME="commitlint-${VERSION}-${ARCH}-${OS}.tar.gz"
BASE_URL="https://github.com/KeisukeYamashita/commitlint-rs/releases/download/${VERSION}"
DOWNLOAD_URL="${BASE_URL}/${FILENAME}"

# Download the TAR
echo "Detected system: $ARCH-$OS"
echo "Downloading: ${DOWNLOAD_URL}"
curl -L -o "${FILENAME}" "${DOWNLOAD_URL}" || { echo "Failed to download ${FILENAME}"; exit 1; }

# Verify the download
if [ -f "${FILENAME}" ]; then
    echo "Downloaded successfully: ${FILENAME}"
else
    echo "Error: File not downloaded"
    exit 1
fi

echo "Extracting: ${FILENAME}"
tar -xzf "${FILENAME}" || { echo "Failed to extract ${FILENAME}"; exit 1; }

echo "Deleting ${FILENAME}"
rm "${FILENAME}"

echo "Moving executable"
mv commitlint.* tools/
chmod +x tools/commitlint.*
