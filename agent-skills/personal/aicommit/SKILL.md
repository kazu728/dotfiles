---
name: aicommit
description: staged 済みの変更からコミット件名を生成して commit する。git diff --cached を読み、直近コミットの件名から文体（言語・prefix・トーン・長さ）を推定して1行の件名に合わせ、git commit する。「staged をコミットして」「コミットメッセージを作って」と頼まれたときに使う。
---

# aicommit

staged 済みの変更を読み、リポジトリの既存スタイルに沿ったコミット件名を1行作って commit する。
エージェント自身が diff を読んで件名を作る。外部の生成ツールは呼ばない。
件名の作法は `./subject-policy.md` に従う。

## 手順

1. `git diff --cached --quiet` で staged の有無を確認する。何も staged されていなければ、コミットせず「先に `git add` して」と伝えて止まる。
2. `git diff --cached` で変更内容を読む。
3. `git log --no-merges -n 20 --pretty=format:'%s'` で直近の件名を読み、支配的なスタイルを推定する。
4. `git commit -m "<件名>"` でコミットする。
