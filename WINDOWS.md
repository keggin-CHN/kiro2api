# Windows 快速开始指南

本指南帮助 Windows 用户快速获取和运行 kiro2api。

## 🎯 方式一：直接下载（推荐，无需 Go 环境）

**适合没有 Go 语言环境的用户**

1. **访问 GitHub Releases 页面**
   - 打开：https://github.com/keggin-CHN/kiro2api/releases
   - 选择最新版本

2. **下载 Windows 可执行文件**
   - 点击下载 `kiro2api-windows-amd64.exe`
   - 文件大约 24MB

3. **直接运行**
   - 无需安装 Go 语言环境
   - 下载后即可使用（需要先配置，见下方"配置"章节）

> **提示**：每次代码更新后，GitHub Actions 会自动编译新版本。在 [Actions 页面](https://github.com/keggin-CHN/kiro2api/actions/workflows/build-binaries.yml) 可以下载最新构建的二进制文件（需要登录 GitHub）。

---

## 🔨 方式二：本地构建（需要 Go 环境）

**适合有 Go 语言环境的开发者**

### 📋 前置要求

1. **安装 Go 语言**
   - 访问 [Go 官方下载页面](https://golang.org/dl/)
   - 下载 Windows 安装包（推荐 go1.24.x 或更高版本）
   - 运行安装程序，使用默认设置
   - 打开命令提示符，输入 `go version` 验证安装

### 🚀 构建步骤

### 方法 1：使用批处理脚本（推荐新手）

1. 打开命令提示符（CMD）
2. 切换到项目目录：
   ```cmd
   cd 项目路径\kiro2api
   ```
3. 运行构建脚本：
   ```cmd
   build.bat
   ```
4. 等待构建完成，会在当前目录生成 `kiro2api.exe`

### 方法 2：使用 PowerShell 脚本

1. 右键点击 Windows 开始菜单，选择 "Windows PowerShell"
2. 切换到项目目录：
   ```powershell
   cd 项目路径\kiro2api
   ```
3. 运行构建脚本：
   ```powershell
   .\build.ps1
   ```

### 方法 3：手动构建（推荐高级用户）

```cmd
go build -ldflags="-s -w" -o kiro2api.exe main.go
```

## ⚙️ 配置

1. **复制配置文件模板**
   ```cmd
   copy .env.example .env
   ```

2. **编辑配置文件**
   - 使用记事本打开 `.env` 文件
   - 设置必需的环境变量：
   
   ```env
   # 客户端认证密钥（必需，请设置强密码）
   KIRO_CLIENT_TOKEN=你的安全密码

   # Token 配置（必需）
   KIRO_AUTH_TOKEN=[{"auth":"Social","refreshToken":"你的Token"}]

   # 可选：服务端口（默认 8080）
   PORT=8080

   # 可选：日志级别
   LOG_LEVEL=info
   ```

3. **保存并关闭文件**

## ▶️ 运行程序

在命令提示符或 PowerShell 中运行：

```cmd
kiro2api.exe
```

或者直接双击 `kiro2api.exe` 文件。

程序启动后，你应该看到类似以下的输出：

```
2026-01-15 15:30:00 INFO  正在创建AuthService...
2026-01-15 15:30:00 INFO  服务器启动在端口 :8080
```

## 🧪 测试

打开另一个命令提示符窗口，运行：

```cmd
curl http://localhost:8080/v1/models
```

如果你没有安装 curl，可以：
1. 在浏览器中访问 `http://localhost:8080/`
2. 或使用 PowerShell：
   ```powershell
   Invoke-WebRequest -Uri http://localhost:8080/v1/models
   ```

## ❓ 常见问题

### Q1: 双击运行后窗口一闪而过

**原因**：通常是因为配置错误导致程序退出。

**解决方法**：
1. 从命令提示符运行程序以查看错误信息
2. 检查 `.env` 文件是否正确配置
3. 确保设置了 `KIRO_CLIENT_TOKEN` 和 `KIRO_AUTH_TOKEN`

### Q2: 提示 "go: command not found" 或 "不是内部或外部命令"

**解决方法**：
1. 确认 Go 已正确安装
2. 重启命令提示符
3. 检查系统环境变量中是否包含 Go 的路径

### Q3: 构建时提示 "package xxx not found"

**解决方法**：
```cmd
go mod download
go mod tidy
```

### Q4: Windows Defender 报告威胁

**解决方法**：
这是误报，新编译的 Go 程序经常被杀毒软件误报。你可以：
1. 点击 "允许" 或 "添加例外"
2. 将程序添加到 Windows Defender 排除列表：
   - 打开 Windows 安全中心
   - 病毒和威胁防护 → 管理设置
   - 排除项 → 添加或删除排除项
   - 添加文件：选择 `kiro2api.exe`

### Q5: 端口被占用

**错误信息**：`listen tcp :8080: bind: address already in use`

**解决方法**：
1. 修改 `.env` 文件中的 `PORT` 为其他端口（如 8081）
2. 或者关闭占用 8080 端口的程序：
   ```cmd
   netstat -ano | findstr :8080
   taskkill /PID 进程ID /F
   ```

## 📚 下一步

- 阅读完整文档：[README.md](./README.md)
- 详细构建选项：[BUILD.md](./BUILD.md)
- 开发指南：[CLAUDE.md](./CLAUDE.md)

## 💡 提示

- 首次构建会下载依赖包，可能需要几分钟
- 建议在命令提示符中运行程序，以便查看日志输出
- 生产环境部署建议使用 Docker（参见 README.md）
- 遇到问题可以启用调试日志：在 `.env` 中设置 `LOG_LEVEL=debug`
