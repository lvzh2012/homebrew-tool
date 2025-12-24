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
    echo "  rktool install xarc   安装 Libarclite 文件到 xarc 目录"
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
        
        # 1. cd到指定文件夹并创建目录
        cd /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/

        # 检查目录是否存在且不为空
        if [ -d "$DIR_NAME" ] && [ "$(ls -A $DIR_NAME 2>/dev/null)" ]; then
            echo "错误: $DIR_NAME 文件夹已存在且不为空，请先删除或清空该文件夹后再运行此脚本。"
            exit 1
        fi

        # 如果目录不存在，则创建
        if [ ! -d "$DIR_NAME" ]; then
            sudo mkdir "$DIR_NAME"
        fi

        # 2. 下载丢失的文件并使它们可执行
        cd "$DIR_NAME"
        sudo git clone https://github.com/kamyarelyasi/Libarclite-Files.git .
        sudo chmod +x *
        echo "安装完成！"
        ;;
    *)
        echo "错误: 未知命令 '$1'"
        echo "使用 'rktool -h' 查看帮助信息"
        exit 1
        ;;
esac
