#!/bin/bash
# Windows build script for kiro2api
# Builds Windows executable only (as requested)

set -e

BINARY_NAME="kiro2api"
MAIN_FILE="main.go"
BUILD_DIR="build"
VERSION=$(git describe --tags --always --dirty 2>/dev/null || echo "dev")
BUILD_TIME=$(date -u '+%Y-%m-%d_%H:%M:%S')

# Create build directory
mkdir -p "$BUILD_DIR"

echo "Building kiro2api for Windows v${VERSION}"
echo "Build time: ${BUILD_TIME}"
echo ""

# Build flags
LDFLAGS="-s -w -X main.Version=${VERSION} -X main.BuildTime=${BUILD_TIME}"

# Build for Windows
echo "Building for Windows (amd64)..."
GOOS=windows GOARCH=amd64 go build -ldflags="${LDFLAGS}" -o "${BUILD_DIR}/${BINARY_NAME}-windows-amd64.exe" ${MAIN_FILE}
echo "✓ ${BUILD_DIR}/${BINARY_NAME}-windows-amd64.exe"

echo ""
echo "Build complete! Executable is in the '${BUILD_DIR}' directory:"
ls -lh "${BUILD_DIR}/"
