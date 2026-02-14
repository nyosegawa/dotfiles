# tmux + Ghostty 開発環境

1プロジェクト = 1ウィンドウ = 4ペイン固定レイアウトで、複数プロジェクトをウィンドウ単位で切り替える tmux 開発環境。

```
┌───────────┬───────┬───────┐
│ 1: Claude │ 3:srv │ 4:fnt │
├───────────┤       │       │
│ 2: free   │       │       │
└───────────┴───────┴───────┘
```

| ペイン | 用途 | 起動タイミング |
|--------|------|---------------|
| 1 (左上) | Claude Code など主作業 | セッション開始時 (PANE1_CMD) |
| 2 (左下) | git操作・自由ターミナル | セッション開始時 (PANE2_CMD) |
| 3 (中央) | サーバー (`npm run dev` 等) | `Option+R` で起動/再起動 |
| 4 (右)   | フロントエンド等 | `Option+R` で起動/再起動 |

## セットアップ

```bash
# スクリプト配置
cp dev-tmux ~/bin/
chmod +x ~/bin/dev-tmux

# tmux設定
cp tmux.conf ~/.tmux.conf

# Ghostty設定
mkdir -p ~/.config/ghostty
cp ghostty-config ~/.config/ghostty/config

# zshrc に追記
cat zshrc-dev.zsh >> ~/.zshrc
source ~/.zshrc
```

## クイックスタート

```bash
# プロジェクト登録 (カレントディレクトリの名前とパスで自動登録)
cd ~/src/myapp
dev add

# 名前やディレクトリを指定して登録することも可能
dev add myapp ~/src/myapp

# ペイン3,4のコマンドを設定 (tmux内なら名前省略可)
dev config
dev config myapp

# 起動
dev
```

## dev コマンド

```
dev                    全プロジェクトを開く (セッションあればアタッチ)
dev <name>             特定プロジェクトを開く
dev add [name] [dir]   プロジェクト作成 (省略=カレントdir名)
dev config [name]      ペイン3,4のコマンドを対話設定
dev edit <name>        エディタで設定ファイルを開く
dev rm <name>          プロジェクト削除
dev restart <name>     ペイン3,4を再起動
dev stop [name]        終了 (省略でセッション全体を終了)
dev ls                 プロジェクト一覧 (▶で実行中を表示)
dev status             実行中ウィンドウの一覧
dev clear [name]       全ペインのログクリア
```

## tmux キーバインド

Prefix は `Ctrl+]`。Emacs の `Ctrl+A/B/E/P/N/F` と干渉しない。

### Prefix 不要

| キー | 操作 |
|------|------|
| マウスクリック | ペイン移動 |
| `Shift+左/右` | ウィンドウ (プロジェクト) 切り替え |
| `Option+C` | 現在のペインをクリア |
| `Option+D` | 全ペインをクリア |
| `Option+R` | ペイン3,4を再起動 |
| `Option+S` | ペイン3,4を停止 (Ctrl+C送信) |

### Prefix (`Ctrl+]`) 後

| キー | 操作 |
|------|------|
| `q` | ペイン番号表示 → 番号でジャンプ |
| `\|` | 左右分割 |
| `-` | 上下分割 |
| `W/S/A/D` | ペインリサイズ (上/下/左/右) |
| `r` | 設定リロード |

## Ghostty 設定

`~/.config/ghostty/config` に配置する 3 項目:

```
macos-option-as-alt = true                        # Option+キーをtmuxに届ける (必須)
copy-on-select = clipboard                        # マウス選択で自動クリップボードコピー
shell-integration-features = ssh-terminfo,ssh-env  # SSH先でterminfo自動設定
```

`macos-option-as-alt = true` がないと `Option+C/D/R/S` がtmuxに届かず動作しない。

## プロジェクト設定ファイル

`~/.config/dev-tmux/<name>.conf` に配置。`dev add` で雛形が生成される。

```bash
# プロジェクト: myapp
PROJECT_DIR="~/src/myapp"

PANE1_CMD=""              # 左上 (空=手動起動)
PANE2_CMD=""              # 左下 (空=手動起動)
PANE3_DIR=""              # 中央ペインのサブディレクトリ (空=PROJECT_DIR)
PANE3_CMD="npm run dev"   # 中央 (Option+Rで起動)
PANE4_DIR=""              # 右ペインのサブディレクトリ
PANE4_CMD="npm run frontend"  # 右 (Option+Rで起動)
```

## 動作要件

- tmux 3.2+ (3.6 で動作確認済み)
- Ghostty (macos-option-as-alt 対応)
- macOS (pbcopy 使用)
