---
name: module4
description: 執行 MCP Catalog 與 Agent Guard 治理 Lab
argument-hint: "[run-block=true（僅限講師核准）]"
agent: agent
---

請依照 [專案守則](../../AGENTS.md)、[Copilot 守則](../copilot-instructions.md) 與 [Module 4 學員指引](../../modules/04-mcp-governance/CUSTOMER-GUIDE.md)，代表工作坊學員完成 Module 4 的安全檢查。

1. 只執行 `bash scripts/run-module.sh 4`。
2. 本機 MCP 只做無外部相依的 Smoke Test；不得直接掛載 `server.mjs` 作為治理結果。
3. MCP 只能由 Project `workshop` 的 AI Catalog 核准並透過 Agent Guard 安裝。
4. 若 Catalog 為空或只有表頭，立即停止並通知講師；不得從其他 Catalog、npm Registry、URL 或本機路徑補找。
5. 若 Catalog 明確提供並核准 `workshop-ops@1.0.0`，且 JFrog Agent Plugin/Agent Guard 工具可用，先檢查來源、Project Scope 與 Tool Policy，再透過 Agent Guard 加入；不得建立本機直連、HTTP 或 SSE 繞過設定。
6. 安裝成功後呼叫 `workshop-ops/get_release_status`，release 使用 `2026.10-demo`，並記錄 Allow 結果。
7. 不得呼叫真實部署或刪除。只有呼叫文字中同時包含 `run-block=true`，且講師已明確核准本次政策測試時，才能嘗試 `workshop-ops/deploy_to_production`；被 Agent Guard 阻擋後立即停止，不得改用 Shell、API 或本機 Server。
8. 若 JFrog Agent Plugin/Agent Guard 工具尚未啟用，停止並請講師完成課前設定，不得直接安裝外部 MCP。
9. 最後回報 Project、MCP 名稱與版本、Catalog、Smoke Test、Allow/Block 結果與執行時間，不得顯示憑證。
