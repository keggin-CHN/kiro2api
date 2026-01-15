# GitHub Actions 使用指南

本文档详细说明如何使用 GitHub Actions 自动构建和下载 kiro2api 可执行文件。

## 📚 目录

- [什么是 GitHub Actions](#什么是-github-actions)
- [如何获取构建的 exe 文件](#如何获取构建的-exe-文件)
- [自动构建触发条件](#自动构建触发条件)
- [手动触发构建](#手动触发构建)
- [发布新版本](#发布新版本)
- [常见问题](#常见问题)

---

## 什么是 GitHub Actions

GitHub Actions 是 GitHub 提供的自动化服务，可以在代码更新时自动编译程序。**您无需在本地安装 Go 语言环境**，GitHub 服务器会自动完成编译工作。

### 优势

✅ **无需本地环境** - 不需要安装 Go 语言  
✅ **自动编译** - 代码更新后自动构建  
✅ **多平台支持** - 同时生成 Windows/Linux/macOS 版本  
✅ **免费使用** - 公开仓库完全免费  

---

## 如何获取构建的 exe 文件

### 方式一：从 Releases 下载（推荐）

**适合场景**：下载稳定的正式版本

#### 步骤：

1. **访问 Releases 页面**
   ```
   https://github.com/keggin-CHN/kiro2api/releases
   ```

2. **选择版本**
   - 点击页面上的最新版本（例如 `v1.0.0`）
   - 或选择其他想要的版本

3. **下载文件**
   - 在 "Assets" 区域找到 `kiro2api-windows-amd64.exe`
   - 点击文件名即可下载

4. **开始使用**
   - 下载完成后，参考 [WINDOWS.md](./WINDOWS.md) 进行配置
   - 无需安装，直接运行

**截图说明**：

```
GitHub Release 页面结构：
┌────────────────────────────────────────┐
│ kiro2api v1.0.0                       │ ← 版本号
├────────────────────────────────────────┤
│ Release notes...                       │ ← 更新说明
├────────────────────────────────────────┤
│ Assets                                 │
│ 📦 kiro2api-windows-amd64.exe (24 MB) │ ← 点击下载
│ 📦 kiro2api-linux-amd64 (24 MB)       │
│ 📦 kiro2api-darwin-amd64 (25 MB)      │
│ 📦 kiro2api-darwin-arm64 (21 MB)      │
└────────────────────────────────────────┘
```

---

### 方式二：从 Actions 下载（开发版本）

**适合场景**：获取最新代码的构建版本（可能包含未发布的新功能）

#### 步骤：

1. **访问 Actions 页面**
   ```
   https://github.com/keggin-CHN/kiro2api/actions/workflows/build-binaries.yml
   ```

2. **选择构建记录**
   - 页面显示所有的构建历史
   - 找到最新的成功构建（绿色 ✓ 标记）
   - 点击进入构建详情

3. **下载 Artifacts**
   - 滚动到页面底部
   - 找到 "Artifacts" 区域
   - 点击 `kiro2api-windows-amd64` 下载

4. **解压并使用**
   - 下载的是 ZIP 压缩包
   - 解压后得到 `kiro2api-windows-amd64.exe`
   - 参考 [WINDOWS.md](./WINDOWS.md) 进行配置

**注意事项**：
- ⚠️ 需要登录 GitHub 账号才能下载 Artifacts
- ⚠️ Artifacts 保存 90 天后自动删除
- ⚠️ 这是开发版本，可能不如 Release 版本稳定

**截图说明**：

```
GitHub Actions 页面结构：
┌────────────────────────────────────────┐
│ Build Binaries                         │ ← 工作流名称
├────────────────────────────────────────┤
│ ✓ Add feature (#123)          2m ago  │ ← 点击进入
│ ✓ Fix bug (#122)              1h ago  │
│ ✗ Update docs (#121)          2h ago  │
└────────────────────────────────────────┘

点击后进入详情页面，滚动到底部：
┌────────────────────────────────────────┐
│ Artifacts                              │
│ 📦 kiro2api-windows-amd64      24 MB  │ ← 点击下载
│ 📦 kiro2api-linux-amd64        24 MB  │
│ 📦 kiro2api-darwin-amd64       25 MB  │
│ 📦 kiro2api-darwin-arm64       21 MB  │
└────────────────────────────────────────┘
```

---

## 自动构建触发条件

GitHub Actions 会在以下情况**自动运行构建**：

### 1. 推送代码到主分支
```bash
git push origin main
# 或
git push origin master
```
→ 自动构建所有平台，构建产物保存在 Actions Artifacts

### 2. 创建 Pull Request
```
创建或更新 PR 到 main/master 分支
```
→ 自动构建并测试，确保代码可以正常编译

### 3. 推送版本标签
```bash
git tag v1.0.0
git push origin v1.0.0
```
→ 自动构建并创建 GitHub Release，上传所有平台的可执行文件

### 4. 手动触发
通过 GitHub 网页界面手动运行（见下一节）

---

## 手动触发构建

如果想要手动触发一次构建（例如想重新编译当前代码），可以按照以下步骤操作：

### 步骤：

1. **访问 Actions 页面**
   ```
   https://github.com/keggin-CHN/kiro2api/actions/workflows/build-binaries.yml
   ```

2. **点击 "Run workflow" 按钮**
   - 在页面右上方找到 "Run workflow" 按钮
   - 点击后会弹出对话框

3. **选择分支并运行**
   - 选择要构建的分支（通常选择 `main`）
   - 点击绿色的 "Run workflow" 按钮确认

4. **等待构建完成**
   - 页面会显示构建进度
   - 构建成功后显示绿色 ✓
   - 通常需要 2-5 分钟

5. **下载构建产物**
   - 按照"方式二"的步骤下载 Artifacts

**截图说明**：

```
Actions 页面右上角：
┌────────────────────────────────────────┐
│          🔵 Run workflow ▼            │ ← 点击这里
└────────────────────────────────────────┘

弹出对话框：
┌────────────────────────────────────────┐
│ Run workflow                           │
│                                        │
│ Use workflow from                      │
│ Branch: main              ▼           │ ← 选择分支
│                                        │
│         🟢 Run workflow               │ ← 确认运行
└────────────────────────────────────────┘
```

---

## 发布新版本

如果您是项目维护者，想要发布一个新的正式版本：

### 步骤：

1. **确保代码已推送到 GitHub**
   ```bash
   git push origin main
   ```

2. **创建版本标签**
   ```bash
   # 创建标签（标签名必须以 v 开头）
   git tag v1.0.0
   
   # 推送标签到 GitHub
   git push origin v1.0.0
   ```

3. **等待自动构建**
   - GitHub Actions 会自动检测到新标签
   - 自动构建所有平台的可执行文件
   - 自动创建 GitHub Release
   - 自动上传所有构建产物

4. **检查 Release**
   - 访问 Releases 页面确认发布成功
   - 检查是否包含所有平台的文件
   - 可以编辑 Release 说明，添加更新内容

### 版本号命名规范

推荐使用语义化版本号（Semantic Versioning）：

```
v主版本号.次版本号.修订号

例如：
v1.0.0  - 第一个正式版本
v1.0.1  - 修复 bug
v1.1.0  - 添加新功能（向后兼容）
v2.0.0  - 重大更新（可能不向后兼容）
```

---

## 常见问题

### Q1: 我没有 GitHub 账号，可以下载吗？

**A**: 
- ✅ **Releases 版本**：可以，无需登录即可下载
- ❌ **Actions Artifacts**：需要登录 GitHub 账号

建议从 Releases 页面下载稳定版本。

---

### Q2: 为什么 Actions 页面没有构建记录？

**A**: 可能的原因：
1. 代码还没有推送到 main/master 分支
2. 还没有创建过版本标签
3. 工作流文件还未合并到主分支

**解决方法**：
- 手动触发一次构建（见"手动触发构建"章节）
- 或等待代码合并到主分支后自动触发

---

### Q3: 构建失败了怎么办？

**A**: 
1. 点击失败的构建查看详细日志
2. 查看错误信息（通常是红色字体）
3. 常见原因：
   - Go 依赖包下载失败（网络问题，重新运行即可）
   - 代码编译错误（需要修复代码）
   - 工作流配置错误（需要修改 `.github/workflows/build-binaries.yml`）

---

### Q4: 下载的文件被杀毒软件报毒？

**A**: 这是**误报**，新编译的 Go 程序经常被误报。

**解决方法**：
- 添加到杀毒软件的白名单
- 从 GitHub Releases 下载可以提高信任度
- 如果不放心，可以查看源代码自己编译

---

### Q5: Artifacts 下载后是 ZIP 文件？

**A**: 是的，GitHub Actions 会自动将构建产物打包成 ZIP。

**解决方法**：
- 右键点击 ZIP 文件
- 选择"解压到当前文件夹"或"Extract Here"
- 得到 `kiro2api-windows-amd64.exe` 文件

---

### Q6: 我想修改构建配置怎么办？

**A**: 编辑 `.github/workflows/build-binaries.yml` 文件。

常见修改：
- 添加更多平台（如 Windows 32 位）
- 修改构建参数（如添加 CGO 支持）
- 更改 Go 版本
- 添加测试步骤

修改后推送到 GitHub，会自动使用新配置。

---

### Q7: 构建需要多长时间？

**A**: 
- **单平台构建**：约 1-2 分钟
- **全部 4 个平台**：约 2-5 分钟（并行构建）

时间取决于：
- GitHub Actions 服务器负载
- 项目依赖包大小
- 代码复杂度

---

### Q8: 每次构建都要花钱吗？

**A**: 
- ✅ **公开仓库**：完全免费，无限制
- ⚠️ **私有仓库**：每月有免费额度（2000 分钟），超出后需付费

kiro2api 是公开仓库，**不用担心费用问题**。

---

## 📖 相关文档

- [WINDOWS.md](./WINDOWS.md) - Windows 快速上手指南
- [BUILD.md](./BUILD.md) - 完整构建文档
- [README.md](./README.md) - 项目主文档
- [GitHub Actions 官方文档](https://docs.github.com/en/actions)

---

## 🎯 快速链接

- [Releases 下载页面](https://github.com/keggin-CHN/kiro2api/releases)
- [Actions 构建页面](https://github.com/keggin-CHN/kiro2api/actions/workflows/build-binaries.yml)
- [工作流配置文件](../.github/workflows/build-binaries.yml)

---

## 📞 获取帮助

如果遇到问题：

1. 查看本文档的"常见问题"章节
2. 在 GitHub Issues 中搜索相关问题
3. 创建新的 Issue 描述您的问题

---

**最后更新**：2026-01-15
