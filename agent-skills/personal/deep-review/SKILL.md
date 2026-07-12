---
name: deep-review
description: 差分を subagent 並列で多観点レビューし、検証を通った指摘だけ返す。/code-review high・/security-review・/prune-review を subagent で並列実行し、集約した指摘を検証パスで再現・裏取りして false positive を落とす。「深くレビューして」「マージ前に徹底的に見て」「ultra 相当をローカルで」と頼まれたときに使う。
---

# deep-review

ultra のローカル版。並列の多観点レビューと、指摘の検証の2段で構成する。
レビューの観点・ロジックは既存 skill に任せ、この skill は配線と検証だけを持つ。

## Phase 1 — 並列レビュー

general-purpose subagent を4体並列で起動し、それぞれに1つの skill を実行させる。

- /code-review high
- /security-review
- /prune-review
- /adversarial-review

各 subagent への指示は「対象 skill を実行し、指摘を file:line 付きで列挙して返す。修正はしない」。

## Phase 2 — 検証

指摘を集約して重複をまとめ、subagent に検証させる。件数が多ければ複数体で分担させる。

- 正しさ・セキュリティの指摘 — コードパスを実際に追う。必要なら既存テストや再現コードを実行する
- 過剰・冗長・残骸の指摘 — 使用箇所の検索、ツールのデフォルト挙動の確認で裏取りする

検証で working tree を変更したまま残さない。一時ファイルを作ったら消す。
再現・裏取りできなかった指摘は落とす。

## 出力

検証を通った指摘だけを、file:line と検証根拠つきで返す。修正はしない。
何も残らなければ「指摘なし」と書く。ひねり出さない。
