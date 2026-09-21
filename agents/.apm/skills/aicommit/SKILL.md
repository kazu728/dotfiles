---
name: aicommit
description: コミットまたは件名案の生成を明示的に頼まれたとき、staged 変更を対象に現在のエージェントで処理する。件名指定と amend も扱う。
---

# aicommit

`git aicommit` は使わず、現在のエージェントで処理する。

## 対象の確認

- リポジトリの状態と `git diff --cached` を確認し、コミット対象を staged の変更に限定する。
- unstaged や未追跡の変更を自動で stage しない。staged の変更がない通常の commit、件名案、件名を指定しない amend は中止し、先に stage するよう伝える。件名を指定した amend はメッセージのみ変更する操作として実行できる。
- 件名案の生成が必要なときは [subject-policy.md](./subject-policy.md) と直近のコミット件名を読み、staged diff を要約する。

## 依頼に応じた処理

- 件名案だけを求められたら、件名を1行だけ返し、commit しない。
- 件名を指定されたら、その件名を変えずに使い、自動生成しない。
- 通常の commit では、件名指定がなければポリシーに従って件名を生成し、`git commit -m` を実行する。
- amend では、指定された件名があれば `git commit --amend -m` を使う。件名の指定がなければ既存の件名を保ち、`git commit --amend --no-edit` を使う。
- 1回の依頼で commit 操作を実行するのは1回だけにする。ユーザーが指定した Git のオプションやフック制御も保持し、要求された操作を通常の commit に読み替えない。

## 結果

- commit が成功したら、作成または更新した commit を確認して結果を伝える。
- commit コマンドが失敗したら、その状態を変更せず理由を伝えて停止する。失敗後に commit コマンドをもう一度実行してはならない。読み取り専用の `git status` や `git diff --cached` で原因を確認することはできるが、`--no-verify`、別の件名、reset、設定変更などで成功させようとしたり、`git aicommit` に切り替えたりしない。
