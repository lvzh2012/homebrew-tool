#!/bin/sh

VERSION="1.0.0"

# 通用脚本动画函数
# 用法: animate_command "提示信息" "要执行的命令" [quiet]
# 参数:
#   $1: 提示信息
#   $2: 要执行的命令（可以是需要引用的复杂命令）
#   $3: 可选，如果设置为 "quiet"，则隐藏命令输出（仅显示错误）
# 示例: 
#   animate_command "正在下载文件..." "wget https://example.com/file"
#   animate_command "正在处理..." "some_command" "quiet"
animate_command() {
    local message="$1"
    local cmd="$2"
    local quiet_mode="$3"
    local pid
    local spinner_chars="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
    local spinner_idx=0
    local output_file="/tmp/rktool_output_$$.log"
    
    # 根据 quiet_mode 决定输出重定向方式
    if [ "$quiet_mode" = "quiet" ]; then
        # quiet 模式：只显示错误，标准输出重定向到日志
        eval "$cmd" > "$output_file" 2>&1 &
    else
        # 正常模式：标准输出正常显示，错误重定向到日志
        eval "$cmd" 2> "$output_file" &
    fi
    pid=$!
    
    # 显示动画
    while kill -0 $pid 2>/dev/null; do
        local spinner_char="${spinner_chars:$spinner_idx:1}"
        printf "\r%s %s" "$spinner_char" "$message" >&2
        spinner_idx=$(( (spinner_idx + 1) % ${#spinner_chars} ))
        sleep 0.1
    done
    
    # 等待命令完成并获取退出码
    wait $pid
    local exit_code=$?
    
    # 清除动画行
    printf "\r\033[K" >&2
    
    # 如果有错误输出，显示错误
    if [ -s "$output_file" ]; then
        if [ "$quiet_mode" = "quiet" ]; then
            # quiet 模式下显示所有输出（包括错误）
            cat "$output_file"
        else
            # 正常模式下只显示错误
            cat "$output_file" >&2
        fi
    fi
    
    # 清理临时文件
    rm -f "$output_file"
    
    return $exit_code
}

# 显示帮助信息
show_help() {
    echo "用法: rktool [命令] [参数]"
    echo ""
    echo "命令:"
    echo "  install <目录名>  安装 Libarclite 文件到指定目录"
    echo ""
    echo "选项:"
    echo "  -h, --help     显示此帮助信息"
    echo "  -v, --version  显示版本信息"
    echo ""
    echo "示例:"
    echo "  rktool install arc    安装 Libarclite 文件到 arc 目录"
    echo "  rktool -h             显示帮助信息"
    echo "  rktool -v             显示版本信息"
}

# 显示版本信息
show_version() {
    echo "rktool version $VERSION"
}

# 处理参数
if [ $# -eq 0 ]; then
    show_help
    exit 0
fi

case "$1" in
    -h|--help)
        show_help
        exit 0
        ;;
    -v|--version)
        show_version
        exit 0
        ;;
    install)
        # 检查是否提供了目录名参数
        if [ -z "$2" ]; then
            echo "错误: install 命令需要指定目录名"
            echo "用法: rktool install <目录名>"
            exit 1
        fi
        
        DIR_NAME="$2"
        echo "Welcome to use this tool!!!"
        echo "正在安装到目录: $DIR_NAME"
        
        # 1. 定义目标路径
        TARGET_DIR="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib"
        
        # 检查目标路径是否存在
        if [ ! -d "$TARGET_DIR" ]; then
            echo "错误: Xcode 工具链路径不存在: $TARGET_DIR"
            echo "请确保已安装 Xcode 并接受许可协议"
            exit 1
        fi
        
        # 切换到目标目录
        cd "$TARGET_DIR" || {
            echo "错误: 无法切换到目录 $TARGET_DIR"
            exit 1
        }
        
        # 检查目录是否存在且不为空
        if [ -d "$DIR_NAME" ] && [ "$(ls -A "$DIR_NAME" 2>/dev/null)" ]; then
            echo "错误: $DIR_NAME 文件夹已存在且不为空，请先删除或清空该文件夹后再运行此脚本。"
            exit 1
        fi

        # 如果目录不存在，则创建
        if [ ! -d "$DIR_NAME" ]; then
            if ! animate_command "正在创建目录 $DIR_NAME（需要管理员权限）..." "sudo mkdir \"$DIR_NAME\""; then
                echo "错误: 无法创建目录 $DIR_NAME（需要管理员权限）"
                echo "请确保有管理员权限（可能需要输入密码）"
                exit 1
            fi
        fi

        # 验证目录是否创建成功
        if [ ! -d "$DIR_NAME" ]; then
            echo "错误: 目录 $DIR_NAME 不存在，创建失败"
            exit 1
        fi

        # 2. 下载丢失的文件并使它们可执行
        if ! cd "$DIR_NAME"; then
            echo "错误: 无法切换到目录 $DIR_NAME"
            exit 1
        fi
        
        if ! animate_command "正在下载 Libarclite 文件（需要管理员权限和网络连接）..." "sudo git clone https://github.com/kamyarelyasi/Libarclite-Files.git ."; then
            echo "错误: git clone 失败（需要管理员权限和网络连接）"
            echo "请确保："
            echo "  1. 有管理员权限（可能需要输入密码）"
            echo "  2. 网络连接正常"
            exit 1
        fi
        
        # 验证 git clone 是否成功
        if [ ! -d ".git" ] && [ -z "$(ls -A . 2>/dev/null)" ]; then
            echo "错误: git clone 失败，目录为空"
            exit 1
        fi
        
        # 使文件可执行（如果目录不为空）
        if [ "$(ls -A . 2>/dev/null)" ]; then
            if ! animate_command "正在设置文件执行权限..." "sudo chmod +x *"; then
                echo "警告: 无法设置文件执行权限"
            fi
        fi
        
        echo "安装完成！"
        ;;
    *)
        echo "错误: 未知命令 '$1'"
        echo "使用 'rktool -h' 查看帮助信息"
        exit 1
        ;;
esac
