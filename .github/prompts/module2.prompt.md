---
name: module2
description: 執行 Hugging Face 模型治理安全 Dry Run
agent: agent
---

請依照 [專案守則](../../AGENTS.md)、[Copilot 守則](../copilot-instructions.md) 與 [Module 2 指引](../../modules/02-model-governance/README.md)，代表工作坊學員完成 Module 2 的安全檢查。

1. 只執行 `bash scripts/run-module.sh 2`。
2. 僅做 Dry Run，確認 Endpoint 固定為 `workshop-huggingfaceml`，並比較安全模型候選與阻擋模型候選。
3. 不得下載、載入或執行任何模型；不得關閉 TLS 驗證或改用公用 Hugging Face。
4. 沒有講師明確核准的模型 ID、Revision、容量與測試資產時，到 Dry Run 即停止。
5. 最後回報 Server、Project、Repository、模型候選、Revision、Dry Run 結果與執行時間，不得顯示憑證。
