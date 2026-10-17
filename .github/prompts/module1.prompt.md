---
name: module1
description: 執行 Curation 套件 Allow 與 Block Lab
agent: agent
---

請依照 [專案守則](../../AGENTS.md)、[Copilot 守則](../copilot-instructions.md) 與 [Module 1 指引](../../modules/01-curation-package/README.md)，代表工作坊學員完成 Module 1。

1. 只執行 `bash scripts/run-module.sh 1`，不要改寫腳本、版本或 Registry。
2. 確認 `axios@1.14.1` 被 Curation 阻擋，且同一個 `workshop-npm` 提供腳本預期的合規版本。
3. 阻擋後不得切換來源、版本、政策或建立 Waiver。
4. 若驗證失敗，安全停止並說明要由講師檢查的項目；不要要求學員把 Token 貼到 Chat。
5. 最後以簡短表格回報 Server、Project、Repository、測試版本、Allow/Block 結果與執行時間，不得顯示憑證。
