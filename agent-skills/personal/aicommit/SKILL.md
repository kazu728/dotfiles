---
name: aicommit
description: staged 済みの変更からコミット件名を生成して commit する。git diff --cached を読み、直近コミットの件名から文体（言語・prefix・トーン・長さ）を推定して1行の件名に合わせ、git commit する。「staged をコミットして」「コミットメッセージを作って」と頼まれたときに使う。
---

# aicommit

staged 済みの変更を読み、リポジトリの既存スタイルに沿ったコミット件名を1行作って commit する。
エージェント自身が diff を読んで件名を作る。外部の生成ツールは呼ばない。

## 手順

1. `git diff --cached --quiet` で staged の有無を確認する。何も staged されていなければ、コミットせず「先に `git add` して」と伝えて止まる。
2. `git diff --cached` で変更内容を読む。
3. `git log --no-merges -n 20 --pretty=format:'%s'` で直近の件名を読み、支配的なスタイルを推定する。
4. `git commit -m "<件名>"` でコミットする。

## 件名の作法

直近の件名からスタイルが読み取れるなら、それに寄せる:

- 同じ言語を使う。
- `feat:` `fix:` `chore:` `docs:` `refactor:` などの prefix を踏襲する。
- トーン・大文字小文字・句読点・長さを揃える。

スタイルが混在している、または手がかりがないときは、英語・命令形（imperative mood）の件名を1行で書く。
何が・なぜ変わったかを要約する。

件名は1行のみ。引用符・マークダウン・箇条書き・コードフェンス・説明は付けない。
