---
name: grilling
description: Interview the user relentlessly about a plan or design. Use when the user wants to stress-test a plan before building, or uses any 'grill' trigger phrases.
license: MIT
metadata:
  source-repo: github.com/mattpocock/skills
  source-path: skills/productivity/grilling
  source-rev: 42396a51d66f07d2f521d728108e7a6c0a1b32c2
  source-retrieved: "2026-06-23"
  source-copyright: Copyright (c) 2026 Matt Pocock
  local-changed: "2026-07-31"
  local-changes: ask via AskUserQuestion instead of free-form prose
---

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask through AskUserQuestion, so each question can be answered by picking an option rather than by typing. Offer the plausible answers as options; the tool appends its own free-text choice, so there is no need to add one.

Put in a single call only the questions that stand on their own. A question whose framing depends on an earlier answer goes in a later call, once that answer is in — asking it upfront is bewildering.

If a question can be answered by exploring the codebase, explore the codebase instead.
