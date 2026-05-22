# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## このリポジトリについて

macOS/Linux（および一部 Windows）向けの個人 dotfiles コレクションです。ビルドシステム・テストスイート・リンターはなく、変更の確認はシェルファイルのソースや設定の再読み込みで行います。

## インストール

**macOS / Linux:**
```sh
bash install.sh
```
`~/.dotfiles` にリポジトリをクローンし、シェルのプロファイル/rc ファイルに `source` 行を追記、`.gemrc`・`.vimrc`・`.vim`・`.tmux.conf` のシンボリックリンクを作成します。vim-plug のインストールも行います。

**Windows:** `install.ps1`（シンボリックリンクの代わりにジャンクション/ハードリンクを作成）

## ファイル構成

| パス | 役割 |
|------|------|
| `shell/.zprofile` / `shell/.zshrc` | Zsh エントリーポイント — それぞれ対応する `common_*` をソース |
| `shell/.bash_profile` / `shell/.bashrc` | Bash 版 |
| `shell/common_profile` | 全シェル共通の環境変数（EDITOR、カラー設定） |
| `shell/common_rc` | エイリアス定義と `shell/docker`・`shell/aws` のソース |
| `shell/docker` | Docker ヘルパー関数・エイリアス（`dp`、`di`、`dr`、`dc` など） |
| `shell/aws` | AWS CLI ヘルパー関数（`ec2ssh`、`change-aws-profile`、`allow-me-ssh` など） |
| `.vimrc` | Vim/Neovim 設定（vim-plug プラグイン管理） |
| `.tmux.conf` | Tmux 設定（プレフィックス: `C-a`、vi キー、マウス有効） |
| `.gitconfig` | `[include]` 経由で取り込む Git 設定 — 同階層に `.gitconfig.local` が必要 |
| `.config/mise/config.toml` | mise で管理するグローバルツールバージョン |
| `Brewfile` | Homebrew パッケージ・cask 一覧 |
| `bin/` | ユーティリティスクリプト（コミット作者変更、Python パッケージ初期化） |
| `windows/` | Windows 固有のセットアップスクリプト |

## 主な規約

- 全シェルファイルは `vim:set et ts=2 sw=2 sts=2 ft=sh:` モードラインを使用 — インデントはスペース2つ。
- `common_profile` / `common_rc` の分割でログイン時の環境変数とインタラクティブシェルのエイリアスを分離。新しいエイリアスは `common_rc`、新しい環境変数は `common_profile` に追加。
- `.gitconfig` はマシン固有の設定（認証情報、ユーザー情報）を `[include] path = .gitconfig.local` で分離。マシン固有の値を `.gitconfig` 本体に直接書かない。
- `shell/aws` の一部の関数は `peco` を使ったインタラクティブな絞り込み選択を行うため、`peco` のインストールが必要。
- mise（`.config/mise/config.toml`）で aws-cli、node、python、uv、gh、ghq、lazygit、prettier、claude-code のグローバルバージョンを管理。

## 変更の確認方法

自動テストはありません。シェルの変更は修正したファイルをソースして確認します：
```sh
source shell/common_rc
source shell/aws
```
Vim の変更は vim を開いて `:source ~/.vimrc` を実行。Tmux の変更は `prefix + r`（リロードにバインド済み）で確認。
