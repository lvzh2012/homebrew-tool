# Homebrew Tool Tap

这是一个私有的 Homebrew tap，用于安装和管理自定义工具。

## 安装 Tap

### 方法 1: 本地 Git 仓库（推荐用于本地开发）

```bash
brew tap zhenhua/tool file:///Users/zhenhua/Desktop/Swift/tool/homebrew-tool
```

**注意**：确保 `homebrew-tool` 目录已经初始化为 Git 仓库（已完成）。

### 方法 2: Git 远程仓库（推荐用于分享）

如果你已经将这个目录推送到 Git 仓库：

```bash
brew tap zhenhua/tool <git-repo-url>
```

例如：
```bash
brew tap zhenhua/tool https://github.com/zhenhua/tool.git
```

### 方法 3: 直接使用本地路径（如果上述方法不行）

```bash
brew tap zhenhua/tool /Users/zhenhua/Desktop/Swift/tool/homebrew-tool
```

## 安装工具

安装测试工具：

```bash
brew install test-tool
```

## 使用方法

安装完成后，可以直接在终端中使用 `test-tool` 命令：

```bash
test-tool
```

**输出示例：**
```
Welcome to use this tool!!!
```

### 验证安装

检查工具是否已正确安装：

```bash
which test-tool
# 应该输出: /opt/homebrew/bin/test-tool (或类似路径)

test-tool --version
# 或者直接运行查看输出
```

### 工具位置

安装后，`test-tool` 可执行文件位于：
- **Apple Silicon (M1/M2)**: `/opt/homebrew/bin/test-tool`
- **Intel Mac**: `/usr/local/bin/test-tool`

你可以通过以下命令查看：

```bash
brew list test-tool
```

## 卸载工具

```bash
brew uninstall test-tool
```

## 更新 Tap

```bash
brew update
```

## 目录结构

```
homebrew-tool/
├── README.md          # 本文件
└── test-tool.rb       # Test Tool 的 Formula
```

## 添加新的 Formula

1. 在 `homebrew-tool/` 目录下创建新的 `.rb` 文件
2. 按照 Homebrew Formula 规范编写 Formula
3. 使用 `brew install <formula-name>` 安装

## 注意事项

- 这是一个本地 tap，Formula 中的 URL 使用 `file://` 协议
- 如果需要分享给其他人，建议将 tap 推送到 Git 仓库
- 确保脚本有执行权限

