#!/bin/bash

export OMP_NUM_THREADS=$(nproc)
export MKL_NUM_THREADS=$(nproc)

OUTPUT1="cifar10_lr_range_finished.ipynb"
OUTPUT2="cifar10_lrtuned_T1_finished.ipynb"
OUTPUT3="cifar100_lr_range_T1_finished.ipynb"
OUTPUT4="cifar100_lr_range_T2_finished.ipynb"
OUTPUT5="cifar100_lrtuned_T1_finished.ipynb"
OUTPUT6="cifar100_lrtuned_T2_finished.ipynb"
# 启动六个后台任务
jupyter nbconvert --to notebook --execute "cifar10_lr_range.ipynb" --output "$OUTPUT1" --ExecutePreprocessor.timeout=-1 &
PID1=$!
jupyter nbconvert --to notebook --execute "cifar10_lrtuned_T1.ipynb" --output "$OUTPUT2" --ExecutePreprocessor.timeout=-1 &
PID2=$!
jupyter nbconvert --to notebook --execute "cifar100_lr_range_T1.ipynb" --output "$OUTPUT3" --ExecutePreprocessor.timeout=-1 &
PID3=$!
jupyter nbconvert --to notebook --execute "cifar100_lr_range_T2.ipynb" --output "$OUTPUT4" --ExecutePreprocessor.timeout=-1 &
PID4=$!
jupyter nbconvert --to notebook --execute "cifar100_lrtuned_T1.ipynb" --output "$OUTPUT5" --ExecutePreprocessor.timeout=-1 &
PID5=$!
jupyter nbconvert --to notebook --execute "cifar100_lrtuned_T2.ipynb" --output "$OUTPUT6" --ExecutePreprocessor.timeout=-1 &
PID6=$!
echo "等待文件生成: $OUTPUT1 和 $OUTPUT2 和 $OUTPUT3 和 $OUTPUT4 和 $OUTPUT5 和 $OUTPUT6 ..."

# 循环检查两个文件都存在且大小不为0（确保写入完成）
while true; do
    if [[ -f "$OUTPUT1" && -s "$OUTPUT1" && -f "$OUTPUT2" && -s "$OUTPUT2" && -f "$OUTPUT3" && -s "$OUTPUT3" && -f "$OUTPUT4" && -s "$OUTPUT4" && -f "$OUTPUT5" && -s "$OUTPUT5" && -f "$OUTPUT6" && -s "$OUTPUT6" ]]; then
        echo "✓ 六个文件都已生成且非空"
        break
    fi
    sleep 30  # 每秒检查一次
done

# 确保后台进程也结束了（清理）
wait $PID1 2>/dev/null
wait $PID2 2>/dev/null
wait $PID3 2>/dev/null
wait $PID4 2>/dev/null
wait $PID5 2>/dev/null
wait $PID6 2>/dev/null

echo "执行后续命令..."

shutdown