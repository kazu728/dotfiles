---
name: aicommit
description: コミットまたは件名案の生成を明示的に頼まれたとき、現在のエージェントで処理する。staged 変更のコミットと必要に応じた分割、amend による変更の追加と件名の変更・再生成を扱う。
---

# aicommit

`git aicommit` は使わず、現在のエージェントで処理する。

## 対象の確認

- リポジトリの状態と `git diff --cached` を確認する。通常の commit と変更を追加する amend では staged の変更だけを取り込み、unstaged や未追跡の変更を自動で stage しない。
- 通常の commit とその件名案、変更を追加する amend は、staged の変更がなければ中止し、先に stage するよう伝える。直前のコミットの件名だけを変更・再生成する場合は staged の有無を問わない。amend の対象となる HEAD がなければ中止する。
- amend で変更も取り込むか、件名だけを変えるかは依頼から判断する。件名が指定されたことだけで対象を決めず、不明なら確認する。
- 件名を生成するときは [subject-policy.md](./subject-policy.md) と直近のコミット件名を読む。通常の commit ではその commit に入れる staged diff、amend では更新後のコミット全体を要約する。件名だけの再生成では HEAD の変更内容、変更を追加する場合は HEAD の変更内容と staged の変更を合わせて確認する。

## 依頼に応じた処理

- 件名案だけを求められたら、件名を1行だけ返し、commit しない。
- 件名を指定されたら、その件名を変えずに使い、自動生成しない。
- 通常の commit では、件名指定がなければポリシーに従って件名を生成し、`git commit -m` を実行する。staged の変更が目的の異なる複数の変更を含むなら、目的ごとに件名を生成し、「分割」の手順で commit する。1つにまとめるよう求められた場合、件名を指定された場合、HEAD がない場合は分けない。
- amend で変更を追加する場合は `git commit --amend`、件名だけを変更する場合はパス指定なしの `git commit --amend --only` を使う。後者では staged の変更を取り込まない。
- amend の件名は、指定があればそれを使い、再生成を求められたら生成する。どちらもなければ `--no-edit` で既存メッセージを保つ。件名を変える場合は `-m` を使い、既存の本文がある場合は本文を保持したメッセージを一時ファイルに書いて `-F` で渡す。
- commit 操作は、作成または更新する commit 1つにつき1回だけ実行する。ユーザーが指定した Git のオプションやフック制御も保持し、要求された操作を通常の commit に読み替えない。

## 分割

- ファイル単位で分け、`git diff --cached --no-renames --name-only` の全パスをいずれかの commit に割り当てる。rename の移動元と移動先は同じ commit に入れる。
- 次の手順を1回のコマンドで実行し、index だけを組み替える。失敗したら index を元の staged 状態 `$T` に戻す。

  ```sh
  if T=$(git write-tree) &&
     git read-tree HEAD && git diff --binary HEAD "$T" -- <paths> | git apply --cached && git commit -m "<件名>" &&
     git read-tree HEAD && git diff --binary HEAD "$T" -- <paths> | git apply --cached && git commit -m "<件名>"
  then git diff --stat HEAD "$T"
  else git read-tree "$T"
  fi
  ```

- `git reset` 後の `git add` や `git commit -- <paths>` は、部分的に stage したファイルで working tree の内容を取り込むため使わない。シェル変数はコマンド間で引き継がれず、`set -e` もホストの実行方法によって効かないため、手順を複数のコマンドに分けたり `&&` を外したりしない。
- 成功しても index は戻さず、表示された差分が空でなければ、フックによる書き換えか割り当て漏れとしてその差分を伝える。戻すと、フックが commit 時に書き換えた内容を打ち消す差分が staged に残る。

## 結果

- commit が成功したら、作成または更新した commit を確認して結果を伝える。
- commit コマンドが失敗したら、その状態を変更せず理由を伝えて停止する。分割中なら作成済みの commit も伝える。失敗後に commit コマンドをもう一度実行してはならない。読み取り専用の `git status` や `git diff --cached` で原因を確認することはできるが、`--no-verify`、別の件名、reset、設定変更などで成功させようとしたり、`git aicommit` に切り替えたりしない。
