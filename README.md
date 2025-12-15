# Homebrew Tool Tap

这是一个私有的 Homebrew tap，用于安装和管理自定义工具。

## 安装 Tap

```bash
brew tap zhenhua/tool file:///Users/zhenhua/Desktop/Swift/tool/homebrew-tool
```

或者，如果你已经将这个目录推送到 Git 仓库：

```bash
brew tap zhenhua/tool <git-repo-url>
```

## 安装工具

安装测试工具：

```bash
brew install test-tool
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

