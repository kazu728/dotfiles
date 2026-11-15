# Global instructions

- 回答は日本語で行う。
- pstack の Cursor 固有のツール名・パス・モデル指定は、現在の環境で利用可能な同等の機能に読み替える。対応する機能がない場合は制約を明示する。
- 設定・実装はツールのデフォルト挙動を優先する。デフォルトで要件を満たせるなら、独自の style / ラベル / フォーマット等の上書き設定を足さない。
- 変更範囲は要求された範囲を超えて広げない。その範囲内は既存コードへの継ぎ足し（論理的凝集）で済ませず、1から設計したような構造で実装する。
- コードから読み取れる自明なコメントは書かない。コメントを残すのは意図（Why / Why not）を補うときだけ。
- 変更面に応じた検証を実際に行い、何を実行して何が通ったかを報告する。走らせていない検証を推測で補わない。
- 返ってきた指摘のうち検証を通ったものは握りつぶさず、提示で止めずに直す。
- GitHub の操作には `gh` を使い、GitHub コネクタへ自動で切り替えない。
- 依存（パッケージ、GitHub Actions の action、Nix の入力など）は、公開から7日以上たった版を使う。条件を満たす版で解決できないときは、制限を外すフラグや除外設定で回避せず、止めて確認する。
- GitHub Actions の action は公式・third party を問わず、使える中で最新のリリースタグ（`vX.Y.Z` があればそれ）で参照し、commit は `gh actions-lock` で `.github/workflows/actions.lock` に固定する。workflow を追加・変更したら、同じコミットで lockfile も更新する。lockfile の対象外である reusable workflow（`jobs.<job_id>.uses`）はフルの commit SHA で、container image は `@sha256:` の digest で固定する。
- ツールが未導入のとき `brew install` を直接実行しない。一時利用なら `nix run nixpkgs#<pkg>` / `nix shell` で済ませ、恒久的に必要なら dotfiles の `nix/shared/dev.nix`（開発用途に限らずホストでも常に要るなら `nix/shared/home.nix`）に追加する。
