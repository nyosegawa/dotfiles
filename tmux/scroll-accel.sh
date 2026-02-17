#!/bin/bash
# tmux スクロール加速: ホイールを速く回すほど多く動く
dir="$1"
state="/tmp/tmux-scroll-accel"
now=$(perl -MTime::HiRes=time -e 'printf "%.0f\n", time*1000')
last=0
[[ -f "$state" ]] && last=$(< "$state")
printf '%s' "$now" > "$state"

elapsed=$((now - last))
if   (( elapsed < 60  )); then n=25   # 連続高速 → 一気にスクロール
elif (( elapsed < 150 )); then n=10   # 中速
else                           n=3    # ゆっくり → 精密スクロール
fi

tmux send-keys -X -N "$n" "scroll-$dir"
