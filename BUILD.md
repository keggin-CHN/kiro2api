# kiro2api 构建指南

本文档提供了在不同平台上构建 kiro2api 的详细说明。

## 目录

- [自动构建（推荐）](#自动构建推荐)
- [前置要求](#前置要求)
- [Windows 构建](#windows-构建)
- [跨平台构建](#跨平台构建)
- [构建选项](#构建选项)
- [验证构建](#验证构建)

## 自动构建（推荐）

**无需本地 Go 环境，直接下载预编译版本**

### GitHub Releases（稳定版本）

1. 访问 [Releases 页面](https://github.com/keggin-CHN/kiro2api/releases)
2. 选择最新版本
3. 下载对应平台的可执行文件：
   - Windows: `kiro2api-windows-amd64.exe`
   - Linux: `kiro2api-linux-amd64`
   - macOS (Intel): `kiro2api-darwin-amd64`
   - macOS (Apple Silicon): `kiro2api-darwin-arm64`

### GitHub Actions（开发版本）

获取最新代码的自动构建版本：

1. 访问 [Actions 页面](https://github.com/keggin-CHN/kiro2api/actions/workflows/build-binaries.yml)
2. 点击最新的成功构建（绿色勾）
3. 滚动到页面底部的 "Artifacts" 区域
4. 下载对应平台的构建产物

> **注意**：从 Actions 下载需要登录 GitHub 账号。Artifacts 保存 90 天后自动删除。

### 自动构建触发条件

GitHub Actions 会在以下情况自动构建：
- 推送到 `main` 或 `master` 分支
- 创建新的 Pull Request
- 推送新的版本标签（`v*`）
- 手动触发（在 Actions 页面点击 "Run workflow"）

版本发布（带标签）会自动创建 GitHub Release 并上传所有平台的可执行文件。

---

## 前置要求

**仅在本地构建时需要**

在构建之前，请确保已安装：

- **Go 1.24.0 或更高版本**
  - 下载地址：https://golang.org/dl/
  - 验证安装：`go version`

## Windows 构建

### 方法 1：使用 build.bat 脚本（推荐）

1. 打开命令提示符（CMD）或 PowerShell
2. 导航到项目目录
3. 运行构建脚本：

```cmd
build.bat
```

构建完成后，会在项目根目录生成 `kiro2api.exe` 文件。

### 方法 2：手动构建

在命令提示符中运行：

```cmd
go build -ldflags="-s -w" -o kiro2api.exe main.go
```

### 方法 3：在 Linux/macOS 上交叉编译 Windows 版本

```bash
GOOS=windows GOARCH=amd64 go build -ldflags="-s -w" -o kiro2api-windows-amd64.exe main.go
```

## 跨平台构建

使用提供的 `build.sh` 脚本可以一次性构建多个平台的可执行文件：

```bash
chmod +x build.sh
./build.sh
```

该脚本会在 `build/` 目录下生成以下文件：

- `kiro2api-windows-amd64.exe` - Windows 64位版本
- `kiro2api-linux-amd64` - Linux 64位版本
- `kiro2api-darwin-amd64` - macOS Intel 版本
- `kiro2api-darwin-arm64` - macOS Apple Silicon 版本

## 构建选项

### 减小可执行文件体积

使用 `-ldflags="-s -w"` 可以去除调试信息，减小文件大小：

```bash
go build -ldflags="-s -w" -o kiro2api.exe main.go
```

- `-s`：去除符号表
- `-w`：去除 DWARF 调试信息

### 添加版本信息

```bash
go build -ldflags="-s -w -X main.Version=1.0.0 -X main.BuildTime=$(date -u '+%Y-%m-%d_%H:%M:%S')" -o kiro2api.exe main.go
```

### 静态编译（Linux）

如果需要在没有动态链接库的环境中运行，可以使用静态编译：

```bash
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o kiro2api-linux-static main.go
```

## 验证构建

### 检查可执行文件

**Windows:**
```cmd
dir kiro2api.exe
kiro2api.exe --version
```

**Linux/macOS:**
```bash
ls -lh build/
./build/kiro2api-linux-amd64 --version
```

### 运行测试

在构建之前，建议先运行测试确保代码正常：

```bash
go test ./...
```

### 快速测试运行

1. 复制配置文件：
```bash
cp .env.example .env
```

2. 编辑 `.env` 文件，设置必需的环境变量：
```bash
KIRO_CLIENT_TOKEN=your-secure-token
KIRO_AUTH_TOKEN='[{"auth":"Social","refreshToken":"your-token"}]'
```

3. 运行程序：

**Windows:**
```cmd
kiro2api.exe
```

**Linux/macOS:**
```bash
./build/kiro2api-linux-amd64
```

4. 测试 API（在另一个终端）：
```bash
curl http://localhost:8080/v1/models
```

## 常见问题

### Q: 构建时提示 "package xxx is not in GOROOT"

A: 运行 `go mod download` 下载依赖包。

### Q: Windows Defender 报告病毒

A: 这是误报。新编译的 Go 程序经常被杀毒软件误报。可以：
- 添加到 Windows Defender 排除列表
- 使用代码签名证书签名可执行文件

### Q: 可执行文件太大

A: 使用 `-ldflags="-s -w"` 优化。也可以使用 UPX 进一步压缩：
```bash
upx --best --lzma kiro2api.exe
```

### Q: 在旧版本 Windows 上运行报错

A: 确保 Windows 版本支持。kiro2api 需要 Windows 10 或更高版本。

## 生产环境构建建议

对于生产环境部署，推荐：

1. **使用版本标签**：
```bash
VERSION=$(git describe --tags --always)
go build -ldflags="-s -w -X main.Version=${VERSION}" -o kiro2api.exe main.go
```

2. **启用优化**：
```bash
go build -ldflags="-s -w" -trimpath -o kiro2api.exe main.go
```

3. **验证构建**：
```bash
go test ./... -race -cover
```

4. **Docker 构建**（可选）：
```bash
docker build -t kiro2api:latest .
```

## 更多信息

- 项目主页：[README.md](./README.md)
- 开发指南：[CLAUDE.md](./CLAUDE.md)
- Docker 部署：参见 README.md 的 Docker 章节
