---
name: codex-chrome
description: ブラウザを操作するとき、ほかのブラウザ操作より先に使う。ブラウザでページを開く、画面を確認する、ボタンをクリックする、フォームに入力するなどの依頼が対象。ブラウザの指定がなければユーザーの Chrome を使う。
---

# codex-chrome

「codex-chrome のブラウザ担当として実行」と依頼されたら、[ブラウザ担当の手順](#ブラウザ担当の手順)に進む。

## 親エージェントの手順

Chrome の操作はブラウザ担当に任せる。依頼は「codex-chrome のブラウザ担当として実行」で始め、対象ページやタブ、作業の目的、操作上の制約を渡す。

ブラウザ担当は、Herdr のペインで Codex として起動する。

1. 同じタブにペインを作る。

   ```sh
   test "${HERDR_ENV:-}" = 1 && herdr pane split --current --direction right --cwd "$PWD" --no-focus
   ```

2. 返った `.result.pane.pane_id` のペインでブラウザ担当を起動し、依頼する。

   ```sh
   herdr agent start "$agent_name" --kind codex --pane "$pane_id" -- \
     -m gpt-6.1-terra -c 'model_reasoning_effort="xhigh"'
   herdr agent prompt "$agent_name" "$request"
   ```

3. 完了は Codex のログで判定する。`herdr agent get "$agent_name"` の `.result.agent.agent_session.value` が ID で、`~/.codex/sessions` の `rollout-*<ID>.jsonl` に `task_complete` が出たら完了、その `last_agent_message` が報告になる。
4. 報告を受け取ったら `herdr pane close "$pane_id"` でペインを閉じる。承認や質問で止まった場合はペインを残し、ユーザーに状況を伝える。

1 のコマンドが失敗したら、Codex は[ブラウザ担当の手順](#ブラウザ担当の手順)を行い、Claude Code は Claude in Chrome を使い、Antigravity は `/browser` の実行をユーザーに案内する。

## ブラウザ担当の手順

Codex CLI では `cua_repl` のブラウザ操作が `The browser access host is unavailable` で失敗する（openai/codex#57641）。直るまでは、Chrome プラグイン同梱の公式クライアントを `node_repl` から呼ぶ。

1. `node_repl` の `js` ツールで最初に次を実行する。`cua_repl` は使わない。

   ```js
   const os = await import("node:os");
   const { setupBrowserRuntime } = await import(`${os.homedir()}/.codex/plugins/cache/openai-bundled/chrome/latest/scripts/browser-client.mjs`);
   globalThis.agent = await setupBrowserRuntime();
   const chrome = (await agent.browsers.list()).find((b) => b.family === "chrome");
   globalThis.browser = await agent.browsers.get(chrome.id);
   console.log(await browser.documentation());
   ```

2. 返ったドキュメントに載っている API だけを使い、`browser.tabs.new()` で自分のタブを作って操作する。

## 制約

- サイトへのアクセス承認が拒否されたら、別の手段で同じ結果を得ようとせず、拒否されたことを報告する。
- この手順で Chrome を検出できないときだけ Computer Use（`cua.getApp("Google Chrome")`）に切り替え、切り替える前に一言告げる。
