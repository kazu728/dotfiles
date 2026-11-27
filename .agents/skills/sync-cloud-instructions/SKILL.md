---
name: sync-cloud-instructions
description: この dotfiles の AGENTS.md と skill を Claude Code on the web の個人用 Cloud 環境に、AGENTS.md を Codex Cloud の個人指示に同期する。クラウドの個人指示や skill の反映・同期を利用者が頼んだときに使う。
---

# クラウドの個人指示と skill を同期する

このスキルがある dotfiles リポジトリのルートで `bash scripts/render-claude-cloud-setup.sh` の出力と `AGENTS.md` の全文を取得する。スクリプトが未コミットや未 push の変更で止まったら、同期を始めずにそのメッセージを報告する。ログイン済みの設定画面は `codex-chrome` スキルで操作する。

- **Claude Code on the web**。Setup script が空でない個人用 Cloud 環境のそれぞれで、**Setup script** をスクリプトの出力と照合する。既存の本文に、このリポジトリの生成物（APM で dotfiles の `agents` を入れる処理や、`~/.claude/CLAUDE.md` を書く処理）以外が含まれる環境は更新せず、報告する。
- **Codex Cloud**。ChatGPT の **設定 → パーソナライズ → カスタム指示 → Codex → 編集** を開き、Codex Cloud に適用される欄を `AGENTS.md` と照合する。

改行コードと末尾の改行を除いて同じ内容なら保存を省く。入力が切り詰められていないことを確かめてから保存する。開き直した画面で原本と一致すれば同期完了。各環境とサービスについて、更新したか、すでに一致していたか、またはどこで止まったかを報告する。

環境の新規作成や、Setup script 以外の設定の変更は同期の対象外。
