---
name: aicommit
description: staged 済みの変更を `git aicommit` で commit する。「staged をコミットして」「commit して」「aicommit」と頼まれたときに使う。件名案だけを求められた場合は使わない。
---

# aicommit

`git aicommit` を1回実行する。
件名生成や `git commit` を別途行わない。
コマンドが失敗したら理由を伝えて止まり、別の方法で commit しない。
