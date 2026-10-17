---
name: module3
description: 執行受治理 Agent Skill 查詢與阻擋 Lab
agent: agent
---

請依照 [專案守則](../../AGENTS.md)、[Copilot 守則](../copilot-instructions.md) 與 [Module 3 學員指引](../../modules/03-skill-governance/CUSTOMER-GUIDE.md)，代表工作坊學員完成 Module 3。

1. 只執行 `bash scripts/run-module.sh 3`。
2. 絕對不要執行、安裝、解壓或載入 `modules/03-skill-governance/fixtures`。
3. 查詢 Project `workshop` 中 `secure-release-review` 與 `env-demo-malicious` 的治理狀態。
4. 若 `secure-release-review@1.0.0` 明確存在、掃描通過、signed evidence 驗證成功且已核准給 Project，才可額外執行：

   `jf agent skills install secure-release-review --harness github-copilot --project-dir "$PWD" --version 1.0.0 --server-id workshop --quiet`

   安裝後只以 `test -f .github/skills/secure-release-review/SKILL.md` 驗證檔案存在，不執行 Skill。JFrog CLI 若拒絕安裝，保留原始原因並停止，不可停用 evidence 驗證。
5. 若 Catalog 回傳 `skills:null`、資產不存在、未核准、掃描中或被政策阻擋，立即停止；不得改用本機路徑、Git URL 或其他來源。
6. 只根據 AI Catalog、掃描、signed evidence 與 Project 核准結果做判讀。任何發佈、豁免或政策變更都留給講師。
7. 最後回報資產版本、Project、Catalog/掃描/核准結果、安裝或阻擋結果與執行時間，不得顯示憑證。
