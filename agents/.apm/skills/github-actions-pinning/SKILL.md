---
name: github-actions-pinning
description: GitHub Actions の workflow（`.github/workflows/`）を追加・変更するとき、編集を始める前に使う。action の追加・更新、reusable workflow と container image の参照、`.github/workflows/actions.lock` の更新を扱う。
---

# GitHub Actions の参照の固定

参照する版は、公開から7日以上たったものから選ぶ。

## action

- 公式・third party を問わず、条件を満たすリリースのうち最新のタグで参照する。`vX.Y.Z` の形のタグがあればそれを使う。公開日は `gh release list -R <owner>/<repo> --json tagName,publishedAt` で確かめる。
- workflow には `v4` のような部分的な ref ではなく、選んだタグをそのまま書く。`gh actions-lock` は部分的な ref を一致する最新の版に絞るので、公開から7日たっていない版が lockfile に入りうる。
- commit は workflow に書かず、`gh actions-lock` で `.github/workflows/actions.lock` に固定する。

## reusable workflow と container image

lockfile の対象外なので、workflow 側で固定する。

- `jobs.<job_id>.uses` で呼ぶ reusable workflow は、フルの commit SHA で参照する。
- container image は `@sha256:` の digest で参照する。

## lockfile の更新

workflow を追加・変更したら `gh actions-lock` を実行し、更新された lockfile を workflow と同じコミットに含める。
