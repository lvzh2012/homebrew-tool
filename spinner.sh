#!/bin/sh

# 通用脚本动画函数库
# 用法: source spinner.sh 然后在脚本中使用动画函数

# 旋转加载动画函数
# 用法: spinner "提示信息" "要执行的命令" [quiet]
# 参数:
#   $1: 提示信息
#   $2: 要执行的命令（可以是需要引用的复杂命令）
#   $3: 可选，如果设置为 "quiet"，则隐藏命令输出（仅显示错误）
# 返回值: 命令的退出码
# 示例: 
#   spinner "正在下载文件..." "wget https://example.com/file"
#   spinner "正在处理..." "some_command" "quiet"
spinner() {
    local message="$1"
    local cmd="$2"
    local quiet_mode="$3"
    local pid
    local spinner_chars="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
    local spinner_idx=0
    local output_file="/tmp/spinner_output_$$.log"
    
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

# 点动画函数（更简单的动画效果）
# 用法: dots "提示信息" "要执行的命令" [quiet]
dots() {
    local message="$1"
    local cmd="$2"
    local quiet_mode="$3"
    local pid
    local dot_count=0
    local max_dots=3
    local output_file="/tmp/dots_output_$$.log"
    
    # 根据 quiet_mode 决定输出重定向方式
    if [ "$quiet_mode" = "quiet" ]; then
        eval "$cmd" > "$output_file" 2>&1 &
    else
        eval "$cmd" 2> "$output_file" &
    fi
    pid=$!
    
    # 显示动画
    while kill -0 $pid 2>/dev/null; do
        local dots_str=$(printf "%*s" $dot_count "" | tr ' ' '.')
        printf "\r%s %s" "$message" "$dots_str" >&2
        dot_count=$(( (dot_count + 1) % (max_dots + 1) ))
        sleep 0.3
    done
    
    # 等待命令完成并获取退出码
    wait $pid
    local exit_code=$?
    
    # 清除动画行
    printf "\r\033[K" >&2
    
    # 如果有错误输出，显示错误
    if [ -s "$output_file" ]; then
        if [ "$quiet_mode" = "quiet" ]; then
            cat "$output_file"
        else
            cat "$output_file" >&2
        fi
    fi
    
    # 清理临时文件
    rm -f "$output_file"
    
    return $exit_code
}

# 进度条动画函数（适用于已知时长的任务）
# 用法: progress_bar "提示信息" "要执行的命令" [quiet]
progress_bar() {
    local message="$1"
    local cmd="$2"
    local quiet_mode="$3"
    local pid
    local bar_chars="▁▂▃▄▅▆▇█"
    local bar_idx=0
    local output_file="/tmp/progress_output_$$.log"
    
    # 根据 quiet_mode 决定输出重定向方式
    if [ "$quiet_mode" = "quiet" ]; then
        eval "$cmd" > "$output_file" 2>&1 &
    else
        eval "$cmd" 2> "$output_file" &
    fi
    pid=$!
    
    # 显示动画
    while kill -0 $pid 2>/dev/null; do
        local bar_char="${bar_chars:$bar_idx:1}"
        printf "\r%s [%s]" "$message" "$bar_char" >&2
        bar_idx=$(( (bar_idx + 1) % ${#bar_chars} ))
        sleep 0.15
    done
    
    # 等待命令完成并获取退出码
    wait $pid
    local exit_code=$?
    
    # 清除动画行
    printf "\r\033[K" >&2
    
    # 如果有错误输出，显示错误
    if [ -s "$output_file" ]; then
        if [ "$quiet_mode" = "quiet" ]; then
            cat "$output_file"
        else
            cat "$output_file" >&2
        fi
    fi
    
    # 清理临时文件
    rm -f "$output_file"
    
    return $exit_code
}

