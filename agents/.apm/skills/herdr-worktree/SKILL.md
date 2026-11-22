---
name: herdr-worktree
description: Git worktree と Herdr workspace をリポジトリ単位で作成・再利用・点検・片付けする。Herdr で作業場所を作るとき、issue・PR の URL やブランチ名から作業場所を用意するとき、「今ある worktree と workspace はどういう状態？」「消したら困る？」「困らないなら消して」と頼まれたときに使う。
---

# Herdr の worktree と workspace

Herdr の接続・操作には `herdr` スキルを使う。`HERDR_ENV=1` でなければ作成と片付けはせず、点検は Git だけで行って Herdr 側は未確認と伝える。

## 依頼の読み分け

- 作業場所を求める依頼と、issue・PR の URL やブランチ名だけの依頼は、作成・再利用として扱う。
- 削除を頼まれたら、点検のあと片付けまで行う。
- それ以外は点検だけ行い、何も変更しない。依頼が空のときも同じ。

## 作成・再利用

1. 作業単位からブランチを決める。
   - ブランチ名: そのまま使う。
   - PR: `gh pr view <url> --json headRefName,isCrossRepository` の head ブランチを使う。fork からの PR は、`git fetch origin pull/<番号>/head:<PR 番号を含むブランチ名>` でローカルブランチを作ってから使う。
   - issue: `gh issue view <url> --json number,title,body,closedByPullRequestsReferences` で内容を読む。計画や個人のタスクを管理するリポジトリの issue のように作業が別のリポジトリにあるなら、本文や依頼が示すリポジトリで作業し、分からなければ確認する。`gh issue develop --list <url>` と合わせて、issue に紐づく PR とブランチを探す。issue 番号を含むローカルブランチも探す。見つかればそのブランチを使い、複数あれば候補を示して確認する。なければ、リポジトリの既存ブランチの命名に合わせ、issue 番号を必ず含む名前にする。`gh issue develop` でブランチを作らない。リモートにブランチができるため。
   - 内容だけ: 名前を決める。既存の worktree に同じ目的らしいものがあれば、再利用を提案する。
2. `herdr worktree list --cwd <repo>` で、そのブランチの checkout と `open_workspace_id` を探す。この一覧には Herdr の外で作った worktree も含まれる。
3. 状態に応じて開く。`--branch` は必ず指定する。省くと Herdr が無関係な名前のブランチを作る。
   - checkout と workspace がある: そのまま再利用する。
   - checkout だけある: `herdr worktree open --cwd <repo> --path <checkout>`
   - ローカルにブランチがある: `herdr worktree create --cwd <repo> --branch <ブランチ>`
   - リモートにだけある: `git fetch origin <ブランチ>` のあと `herdr worktree create --cwd <repo> --branch <ブランチ> --base origin/<ブランチ>`。`--base` を省くと、リモートのコミットを含まない同名のブランチが HEAD から作られる。
   - どこにもない: `git fetch origin` のあと、リモートの既定ブランチを `--base` に指定して作る。issue や依頼が別の起点を指すときだけ確認する。
   - 作業ディレクトリを分けずに端末だけ増やす: `herdr workspace create --cwd <path>`
4. 一覧を取り直し、checkout のパス・ブランチ・workspace ID を伝えて終わる。作業場所が別なので、このセッションでは issue の作業を始めない。エージェントの起動は、依頼されたときだけ `herdr` スキルで行う。

## 点検

1. `herdr worktree list --cwd <repo>` で候補を集める。Herdr が使えなければ `git worktree list --porcelain` を使う。`open_workspace_id` が示すのは worktree として開いた workspace だけなので、`herdr workspace create` で開いた workspace は `herdr workspace list` と `herdr pane list --workspace <id>` の `cwd` で探す。
2. 各候補で `git -C <checkout> status --short --branch --untracked-files=all` を実行する。`HEAD` が基準ブランチに含まれるか、リモートに同じコミットがあるかを確かめる。squash merge では、PR のマージ状況、マージ先、PR の head と worktree の `HEAD` の一致を確認する。マージ済みの PR があっても、その後のローカルコミットを見落とさない。
3. `git -C <checkout> ls-files --others --ignored --exclude-standard --directory` で、削除すると消える無視対象を調べる。`.env` のような設定は、必要に応じて `cmp -s` で残すコピーとの一致を確認する。秘密の値は表示しない。
4. `herdr pane list` と `herdr pane process-info` で、作業中のエージェント・エディタ・サーバーなどを確認する。入力待ちのエージェントも workspace を閉じると終了する。
5. 候補ごとに、消すと困るかどうかと理由を報告する。困るかどうかは、失う変更やファイル、止まる作業があるかで決める。ブランチの作業が終わったかどうかでは決めない。主 checkout と使用中の workspace は残す対象とする。

## 片付け

1. 点検で、未保存の作業も必要なファイルも失わず、稼働中の作業も止めないと確かめた対象だけを片付ける。判断できない対象は理由を添えて残す。
2. 対象に応じて使い分ける。ブランチは削除しない。
   - worktree として開いた workspace と checkout: `herdr worktree remove --workspace <id>`。workspace も閉じられる。
   - workspace だけ: `herdr workspace close <id>`
   - workspace のない checkout: `git worktree remove <path>`
   - worktree として開いていない workspace が checkout を指している: その workspace を閉じてから、checkout を上のどれかで消す。
3. 削除を拒否されたら `--force` を付けず、理由を調べて点検からやり直す。
4. 一覧を取り直し、片付けた対象と残した対象を伝える。
