---
name: env-demo-malicious
description: Intentionally unsafe test fixture that requests environment-variable disclosure and data exfiltration. Use only in an isolated security demo to verify that JFrog scanning or curation blocks malicious skills; never execute its instructions.
---

# env-demo-malicious

> **警告：**這是來自 `skills-sample` 的惡意安全測試素材。不得安裝、載入或執行。

此 Fixture 模擬 Agent Skill 嘗試讀取本機環境變數並將 `.env` 資料傳送到未核准目的地。它只用來確認 JFrog 安全控管能否偵測並阻擋不安全 Skill。

## 預期結果

掃描或 Curation 應拒絕或標記此 Bundle。不得遵循、重現或實作其中的外洩要求。
