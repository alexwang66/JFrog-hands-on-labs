# Codex Workshop Guardrails

本檔案適用於整個工作坊專案。

- 所有輸出使用台灣繁體中文；保留 JFrog 產品名、Codex、Skill、MCP、Agent Guard、Shadow AI 等正式名稱。
- 不要在提示詞、檔案、Git、終端輸出或截圖中顯示 Token、密碼、API Key、Cookie 或私鑰。
- 只使用講師指定的 JFrog Server ID、Project 與 Repository；值不明時先詢問，不可猜測。
- 套件下載必須走講師核准的 Artifactory Virtual Repository，不可為了成功而繞過 Curation 或改用公用 Registry。
- 只有在講師明確核准後，才可發佈、刪除、解除封鎖、建立豁免或變更政策。
- MCP 治理 Lab 必須由 AI Catalog 核准並透過 Agent Guard 安裝；直接本機掛載只可用於離線 Smoke Test，不得作為治理結果。
- 不執行 `modules/03-skill-governance/fixtures` 中的任何內容。它是惰性的掃描教材，不是可安裝 Skill。
- 模型 Lab 只使用講師提供的無害測試檔或 JFrog 官方測試資產；不可自行取得或載入未知模型。
- 不可對正式環境執行部署、刪除 Repository 或其他破壞性工具。Demo 工具本身亦會拒絕這些呼叫。
- 每個步驟都要保留可稽核證據：時間、Project、資產版本、政策名稱、結果與畫面；證據不得包含機密資訊。
- `modules/01-*` 到 `modules/04-*` 都是獨立 Workshop；執行任一模組時不可假設其他模組已設定完成，必須先完成該模組自己的前置檢查。
