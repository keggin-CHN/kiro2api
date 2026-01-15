#!/bin/bash
# Cross-platform build script for kiro2api
# Builds executables for multiple platforms

set -e

BINARY_NAME="kiro2api"
MAIN_FILE="main.go"
BUILD_DIR="build"
VERSION=$(git describe --tags --always --dirty 2>/dev/null || echo "dev")
BUILD_TIME=$(date -u '+%Y-%m-%d_%H:%M:%S')

# Create build directory
mkdir -p "$BUILD_DIR"

echo "Building kiro2api v${VERSION}"
echo "Build time: ${BUILD_TIME}"
echo ""

# Build flags (with sonic_no_asm tag for CGO_ENABLED=0 compatibility)
LDFLAGS="-s -w -X main.Version=${VERSION} -X main.BuildTime=${BUILD_TIME}"
TAGS="-tags=sonic_no_asm"

# Build for Windows
echo "Building for Windows (amd64)..."
CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build ${TAGS} -ldflags="${LDFLAGS}" -o "${BUILD_DIR}/${BINARY_NAME}-windows-amd64.exe" ${MAIN_FILE}
echo "✓ ${BUILD_DIR}/${BINARY_NAME}-windows-amd64.exe"

# Build for Linux
echo "Building for Linux (amd64)..."
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build ${TAGS} -ldflags="${LDFLAGS}" -o "${BUILD_DIR}/${BINARY_NAME}-linux-amd64" ${MAIN_FILE}
echo "✓ ${BUILD_DIR}/${BINARY_NAME}-linux-amd64"

# Build for macOS
echo "Building for macOS (amd64)..."
CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build ${TAGS} -ldflags="${LDFLAGS}" -o "${BUILD_DIR}/${BINARY_NAME}-darwin-amd64" ${MAIN_FILE}
echo "✓ ${BUILD_DIR}/${BINARY_NAME}-darwin-amd64"

echo "Building for macOS (arm64)..."
CGO_ENABLED=0 GOOS=darwin GOARCH=arm64 go build ${TAGS} -ldflags="${LDFLAGS}" -o "${BUILD_DIR}/${BINARY_NAME}-darwin-arm64" ${MAIN_FILE}
echo "✓ ${BUILD_DIR}/${BINARY_NAME}-darwin-arm64"

echo ""
echo "Build complete! Executables are in the '${BUILD_DIR}' directory:"
ls -lh "${BUILD_DIR}/"
