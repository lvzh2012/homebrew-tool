#!/bin/sh

VERSION="1.0.1"

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
        
        # 检查目标路径是否存在（不依赖写权限）
        if [ ! -d "$TARGET_DIR" ]; then
            echo "错误: Xcode 工具链路径不存在: $TARGET_DIR"
            echo "请确保已安装 Xcode 并接受许可协议"
            exit 1
        fi
        
        # 检查目录是否已存在且不为空（用 sudo 以便能读 root 属主目录）
        if sudo test -d "$TARGET_DIR/$DIR_NAME" && [ -n "$(sudo ls -A "$TARGET_DIR/$DIR_NAME" 2>/dev/null)" ]; then
            echo "错误: $DIR_NAME 文件夹已存在且不为空，请先删除或清空该文件夹后再运行此脚本。"
            echo "可执行: sudo rm -rf $TARGET_DIR/$DIR_NAME"
            exit 1
        fi

        # 所有写操作在单次 sudo 下完成，避免权限混用
        echo "正在安装到 $TARGET_DIR/$DIR_NAME（需要管理员权限，可能提示输入密码）..."
        if ! sudo /bin/sh -c "
            set -e
            cd \"$TARGET_DIR\" || { echo '错误: 无法进入 Xcode 工具链目录'; exit 1; }
            rm -rf \"$DIR_NAME\"
            mkdir -p \"$DIR_NAME\"
            cd \"$DIR_NAME\"
            git clone https://github.com/kamyarelyasi/Libarclite-Files.git .
            [ -n \"\$(ls -A . 2>/dev/null)\" ] && chmod +x *
            echo '安装完成！'
        "; then
            echo "错误: 安装失败（权限或网络问题）"
            echo "请确保："
            echo "  1. 当前用户有管理员权限（sudo 时会提示输入密码）"
            echo "  2. 网络可访问 github.com"
            echo "  3. 若仍报错，可尝试: sudo rktool install $DIR_NAME"
            exit 1
        fi
        ;;
    *)
        echo "错误: 未知命令 '$1'"
        echo "使用 'rktool -h' 查看帮助信息"
        exit 1
        ;;
esac
