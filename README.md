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

添加 tap 后，可以安装以下工具：

### 安装 rktool

```bash
brew install rktool
```

### 安装 spinner（脚本动画库）

如果你只需要脚本动画功能，可以单独安装 `spinner`：

```bash
brew install spinner
```

或者同时安装两个工具：

```bash
brew install rktool spinner
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
rktool install arc  # 安装 Libarclite 文件到 arc 目录（需要管理员权限）
```

**输出示例：**
```
Welcome to use this tool!!!
⠋ 正在创建目录 arc（需要管理员权限）...
⠙ 正在下载 Libarclite 文件（需要管理员权限和网络连接）...
⠹ 正在设置文件执行权限...
安装完成！
```

> **注意**：执行命令时会显示旋转加载动画，让用户知道操作正在进行中。

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

### 卸载 rktool

```bash
brew uninstall rktool
```

### 卸载 spinner

```bash
brew uninstall spinner
```

### 同时卸载多个工具

```bash
brew uninstall rktool spinner
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

## 脚本动画功能

`rktool` 内置了通用的脚本动画功能，在执行耗时操作时会显示旋转加载动画，提升用户体验。

### 安装 spinner 动画库

有两种方式获取 `spinner.sh` 动画库：

#### 方式 1: 单独安装 spinner（推荐）

```bash
brew install spinner
```

安装后，`spinner.sh` 位于：
- **Apple Silicon (M1/M2)**: `/opt/homebrew/libexec/spinner.sh`
- **Intel Mac**: `/usr/local/libexec/spinner.sh`

#### 方式 2: 通过 rktool 安装

安装 `rktool` 时，`spinner.sh` 会自动安装到 `libexec` 目录。

### 在 rktool.sh 中使用

`rktool.sh` 已经集成了 `animate_command` 函数，在执行以下操作时会自动显示动画：
- 创建目录
- 下载文件
- 设置文件权限

### 在其他脚本中使用动画库

`spinner.sh` 动画库可以在任何脚本中复用。该库包含三种动画样式：

#### 1. 旋转加载动画（spinner）

```bash
#!/bin/sh

# 在脚本开头引入（使用 Homebrew 安装的路径）
source "$(brew --prefix)/libexec/spinner.sh"

# 或者使用完整路径
# source /opt/homebrew/libexec/spinner.sh  # Apple Silicon
# source /usr/local/libexec/spinner.sh     # Intel Mac

# 使用旋转动画
spinner "正在处理..." "your_command"
```

#### 2. 点动画（dots）

```bash
# 使用点动画（更简单的效果）
dots "正在处理..." "your_command"
```

#### 3. 进度条动画（progress_bar）

```bash
# 使用进度条动画
progress_bar "正在处理..." "your_command"
```

### 动画函数参数

所有动画函数都支持以下参数：

```bash
spinner "提示信息" "要执行的命令" [quiet]
```

- **$1**: 提示信息 - 显示在动画旁边的文本
- **$2**: 要执行的命令 - 需要执行的命令（可以是需要引用的复杂命令）
- **$3**: 可选，如果设置为 `"quiet"`，则隐藏命令输出（仅显示错误）

### 使用示例

```bash
#!/bin/sh

# 引入动画库（使用 Homebrew 安装的路径）
source "$(brew --prefix)/libexec/spinner.sh"

# 正常模式（显示命令输出）
spinner "正在下载文件..." "wget https://example.com/file.tar.gz"

# Quiet 模式（隐藏输出，仅显示错误）
spinner "正在处理数据..." "process_data.sh" "quiet"

# 使用点动画
dots "正在安装..." "install_package.sh"

# 使用进度条动画
progress_bar "正在编译..." "make all"
```

### 查找 spinner.sh 的安装路径

如果不知道 `spinner.sh` 的安装路径，可以使用以下命令查找：

```bash
# 如果安装了 spinner
brew --prefix spinner 2>/dev/null && echo "$(brew --prefix spinner)/libexec/spinner.sh"

# 如果通过 rktool 安装
brew --prefix rktool 2>/dev/null && echo "$(brew --prefix rktool)/libexec/spinner.sh"

# 或者使用通用方法（推荐）
echo "$(brew --prefix)/libexec/spinner.sh"
```

### 动画特点

- ✅ **通用**：可在任何 shell 脚本中使用
- ✅ **高效**：后台执行命令，不影响性能
- ✅ **简洁**：代码清晰，易于维护
- ✅ **灵活**：支持正常模式和 quiet 模式
- ✅ **兼容**：正确处理需要用户交互的命令（如 sudo）

## 目录结构

```
homebrew-tool/
├── README.md          # 本文件
├── rktool.rb          # Rktool 的 Formula
├── rktool.sh          # Rktool 的脚本文件
├── spinner.rb         # Spinner 的 Formula（独立工具）
└── spinner.sh         # 通用脚本动画库
```

## 分发 spinner 给其他开发者

`spinner` 可以作为独立工具分发给其他开发者使用：

### 方式 1: 通过 Homebrew Tap 安装（推荐）

其他开发者只需要：

```bash
# 添加 tap
brew tap lvzh2012/tool

# 安装 spinner
brew install spinner

# 在脚本中使用
source "$(brew --prefix)/libexec/spinner.sh"
spinner "正在处理..." "your_command"
```

### 方式 2: 直接使用源文件

开发者也可以直接从 GitHub 下载 `spinner.sh` 文件：

```bash
# 下载文件
curl -o spinner.sh https://raw.githubusercontent.com/lvzh2012/homebrew-tool/main/spinner.sh
chmod +x spinner.sh

# 在脚本中使用
source ./spinner.sh
```

### 方式 3: 作为 rktool 的依赖

如果开发者已经安装了 `rktool`，`spinner.sh` 会自动安装，可以直接使用。

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

