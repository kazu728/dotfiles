---
name: codex-chrome
description: Codex CLI（codex-tui・codex exec）からユーザーの Chrome を操作するとき（ページを開く、内容を確認する、フォームを操作するなど）に使う。Claude Code では使わない。
---

# codex-chrome

Codex CLI では、`cua_repl` のブラウザ操作（`cua.createBrowserTab("chrome", …)`・`cua.getTab`・`cua.getState` のブラウザ一覧）が `The browser access host is unavailable` で失敗する（openai/codex#57641）。そのまま進むと Chrome アプリ全体を Computer Use で操作することになり、ユーザーの Chrome 操作とぶつかる。#57641 が直るまでは、Chrome プラグイン同梱の公式クライアントを `node_repl` から呼び、タブ単位で操作する。

## 手順

1. `node_repl` の `js` ツールで最初に次を実行する。`cua_repl` は使わない。

   ```js
   const os = await import("node:os");
   const { setupBrowserRuntime } = await import(`${os.homedir()}/.codex/plugins/cache/openai-bundled/chrome/latest/scripts/browser-client.mjs`);
   globalThis.agent = await setupBrowserRuntime();
   const chrome = (await agent.browsers.list()).find((b) => b.family === "chrome");
   globalThis.browser = await agent.browsers.get(chrome.id);
   console.log(await browser.documentation());
   ```

2. 返ったドキュメントに載っている API だけを使う。作業の始めに `browser.nameSession("🔎 <作業名>")` でセッション名を付け、`browser.tabs.new()` で自分のタブを作って操作する。
3. 以降の呼び出しでは `agent` と `browser` を使い回し、import や setup をやり直さない。
4. 作ったタブは作業の終わりに閉じる。

## 制約

- サイトへのアクセス承認が拒否されたら、別の手段で同じ結果を得ようとせず、拒否されたことを報告する。
- この手順で Chrome を検出できないときだけ Computer Use（`cua.getApp("Google Chrome")`）に切り替え、切り替える前に一言告げる。
