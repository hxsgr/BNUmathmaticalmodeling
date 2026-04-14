#!/bin/bash

export OMP_NUM_THREADS=$(nproc)
export MKL_NUM_THREADS=$(nproc)

PIDS=()
OUTPUT_FILES=()

# 遍历当前目录下所有.ipynb文件（排除已完成的避免重复处理）
for notebook in *.ipynb; do
    # 检查文件是否存在（处理没有匹配到的情况）
    [ -e "$notebook" ] || continue
    # 跳过已完成的文件
    [[ "$notebook" == *_finished.ipynb ]] && continue
    
    # 生成输出文件名: xxx.ipynb -> xxx_finished.ipynb
    output="${notebook%.ipynb}_finished.ipynb"
    
    echo "启动转换: $notebook -> $output"
    
    jupyter nbconvert --to notebook --execute "$notebook" --output "$output" --ExecutePreprocessor.timeout=-1 &
    PIDS+=($!)
    OUTPUT_FILES+=("$output")
done

# 检查是否有文件需要处理
if [ ${#OUTPUT_FILES[@]} -eq 0 ]; then
    echo "没有找到需要处理的 .ipynb 文件"
    exit 0
fi

echo ""
echo "等待 ${#OUTPUT_FILES[@]} 个文件生成: ${OUTPUT_FILES[*]} ..."

# 循环检查所有文件都存在且大小不为0（确保写入完成）
while true; do
    all_ready=true
    for output in "${OUTPUT_FILES[@]}"; do
        if [[ ! -f "$output" || ! -s "$output" ]]; then
            all_ready=false
            break
        fi
    done
    
    if $all_ready; then
        echo "✓ 所有文件都已生成且非空 (${#OUTPUT_FILES[@]} 个)"
        break
    fi
    sleep 30
done

# 确保所有后台进程也结束了（清理）
echo "等待后台进程完成..."
for pid in "${PIDS[@]}"; do
    wait $pid 2>/dev/null
done

echo "执行后续命令..."

shutdown