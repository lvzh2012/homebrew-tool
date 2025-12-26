#!/bin/sh

VERSION="1.0.0"

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
            echo "正在创建目录 $DIR_NAME（需要管理员权限）..."
            if ! sudo mkdir "$DIR_NAME" 2>&1; then
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
        
        echo "正在下载 Libarclite 文件（需要管理员权限和网络连接）..."
        if ! sudo git clone https://github.com/kamyarelyasi/Libarclite-Files.git . 2>&1; then
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
            echo "正在设置文件执行权限..."
            if ! sudo chmod +x * 2>&1; then
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
