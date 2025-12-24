# Homebrew Tool Tap

这是一个 Homebrew tap，用于安装和管理自定义工具。

## 安装 Tap

添加 tap 到你的 Homebrew：

```bash
brew tap lvzh2012/tool https://github.com/lvzh2012/homebrew-tool.git
```

如果仓库是公开的，也可以简化为：

```bash
brew tap lvzh2012/tool
```

## 安装工具

添加 tap 后，安装工具：

```bash
brew install rktool
```

## 更新 Tap

更新 tap 以获取最新版本：

```bash
brew update
```

或者手动更新特定 tap：

```bash
cd $(brew --repo lvzh2012/tool)
git pull
```

## 使用方法

安装完成后，可以直接在终端中使用 `rktool` 命令：

```bash
rktool -h          # 显示帮助信息
rktool -v          # 显示版本信息
rktool install xarc  # 安装 Libarclite 文件到 xarc 目录
```

**输出示例：**
```
Welcome to use this tool!!!
```

### 验证安装

检查工具是否已正确安装：

```bash
which rktool
# 应该输出: /opt/homebrew/bin/rktool (或类似路径)

rktool -v
# 显示版本信息
```

### 工具位置

安装后，`rktool` 可执行文件位于：
- **Apple Silicon (M1/M2)**: `/opt/homebrew/bin/rktool`
- **Intel Mac**: `/usr/local/bin/rktool`

你可以通过以下命令查看：

```bash
brew list rktool
```

## 卸载工具

```bash
brew uninstall rktool
```

## 移除 Tap

如果你想完全移除这个 tap：

```bash
brew untap lvzh2012/tool
```

**注意**：
- `brew untap` 只会移除 tap 本身，不会自动卸载通过该 tap 安装的工具
- 如果你想先卸载所有工具再移除 tap，可以这样做：

```bash
# 先卸载所有通过此 tap 安装的工具
brew uninstall rktool

# 然后移除 tap
brew untap lvzh2012/tool
```

### 查看已安装的 Tap

#### 查看所有已安装的 tap

列出所有已安装的 tap：

```bash
brew tap
```

**输出示例：**
```
homebrew/core
homebrew/cask
lvzh2012/tool
```

#### 查看特定 tap 的详细信息

查看某个 tap 的详细信息，包括：
- Tap 的路径
- Formula 数量
- 是否已安装
- 最后更新时间

```bash
brew tap-info lvzh2012/tool
```

查看所有 tap 的详细信息：

```bash
brew tap-info --installed
```

#### 查看 tap 中可用的 Formula

查看某个 tap 中所有可用的 Formula（工具）：

```bash
brew search lvzh2012/tool
```

或者：

```bash
ls /opt/homebrew/Library/Taps/lvzh2012/homebrew-tool/
```

#### 查看 tap 的安装路径

查看 tap 在系统中的实际位置：

```bash
brew --repo lvzh2012/tool
```

**输出示例：**
```
/opt/homebrew/Library/Taps/lvzh2012/homebrew-tool
```

#### 检查 tap 是否已安装

检查特定 tap 是否已安装：

```bash
brew tap | grep lvzh2012/tool
```

如果已安装，会显示 `lvzh2012/tool`；如果未安装，则没有输出。

## 更新 Tap

```bash
brew update
```

## 目录结构

```
homebrew-tool/
├── README.md          # 本文件
├── rktool.rb          # Rktool 的 Formula
└── rktool.sh          # Rktool 的脚本文件
```

## 添加新的 Formula

1. 在 `homebrew-tool/` 目录下创建新的 `.rb` 文件
2. 按照 Homebrew Formula 规范编写 Formula
3. 使用 `brew install <formula-name>` 安装

### 生成 SHA256 校验和

在创建或更新 Formula 时，需要为下载的文件生成 SHA256 校验和。Homebrew 使用这个校验和来验证文件的完整性。

#### 方法 1: 使用 `shasum` 命令（macOS 内置）

```bash
shasum -a 256 /path/to/your/file
```

**输出示例：**
```
bd12cfb53cc7c7bb8881f3625a93695c75ff65f4b65caed7f30c66055c737728  your-file
```

只需要复制 SHA256 值（第一列）到 Formula 文件中。

#### 方法 2: 使用 `sha256sum` 命令（如果可用）

```bash
sha256sum /path/to/your/file
```

#### 方法 3: 使用 Homebrew 的 `brew fetch` 命令

如果文件已经可以通过 URL 访问，可以使用：

```bash
brew fetch --formula <formula-name>
```

这会显示下载文件的 SHA256 值。

#### 方法 4: 使用 `openssl` 命令

```bash
openssl dgst -sha256 /path/to/your/file
```

**输出示例：**
```
SHA256(/path/to/your/file)= bd12cfb53cc7c7bb8881f3625a93695c75ff65f4b65caed7f30c66055c737728
```

#### 在 Formula 中使用 SHA256

将生成的 SHA256 值添加到 Formula 文件中：

```ruby
class YourTool < Formula
  # ... 其他配置 ...
  url "https://github.com/yourusername/your-repo/raw/main/your-file"
  sha256 "bd12cfb53cc7c7bb8881f3625a93695c75ff65f4b65caed7f30c66055c737728"
  # ... 其他配置 ...
end
```

#### 注意事项

- **更新文件后必须更新 SHA256**：如果修改了源文件，必须重新计算并更新 Formula 中的 SHA256 值
- **SHA256 是必需的**：Homebrew 要求所有下载的文件都有 SHA256 校验和（除非使用 `:no_check` 跳过，但不推荐）
- **验证 SHA256**：安装时 Homebrew 会自动验证文件的 SHA256，如果不匹配会报错

## 注意事项

- 确保脚本有执行权限
- 更新 Formula 后记得提交并推送到 GitHub

