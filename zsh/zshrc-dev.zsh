# =============================================================================
# .zshrc に追加する dev-tmux 設定
# =============================================================================

export PATH="$HOME/bin:$PATH"

dev() { dev-tmux "$@"; }

alias devls='dev-tmux ls'
alias devs='dev-tmux status'
alias devq='dev-tmux stop'
devr() { ssh wsl -t 'dev-tmux attach'; }

# --- zsh補完 ---
_dev_tmux_complete() {
  local conf_dir="$HOME/.config/dev-tmux"
  local subcmds=(add edit config rm restart stop ls status clear help)

  if (( CURRENT == 2 )); then
    local projects=()
    if [[ -d "$conf_dir" ]]; then
      for f in "$conf_dir"/*.conf(N); do
        projects+=("${f:t:r}")
      done
    fi
    compadd "${subcmds[@]}" "${projects[@]}"
  elif (( CURRENT == 3 )); then
    local projects=()
    if [[ -d "$conf_dir" ]]; then
      for f in "$conf_dir"/*.conf(N); do
        projects+=("${f:t:r}")
      done
    fi
    compadd "${projects[@]}"
  fi
}
compdef _dev_tmux_complete dev dev-tmux
