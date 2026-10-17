# 端對端 Live Demo 腳本

## 目標

用 20 分鐘展示同一個 Codex 任務如何經過套件、模型、Skill 與 MCP 四層治理。Demo 使用預先驗證的固定資產，不在台上臨時選版本。

## 開場（2 分鐘）

投影片重點：

> AI Agent 不只產生程式碼，也會主動取得套件、模型、Skill，並呼叫 MCP 工具。治理必須同時回答「來源可信嗎、內容安全嗎、誰核准、實際允許做什麼、能否稽核」。

顯示 `docs/00-workshop-overview.md` 的架構，但不要開啟任何憑證畫面。

## 場景 1：套件 Curation（4 分鐘）

1. 在 Codex 提問安全套件版本；確認來源是指定 Artifactory Virtual Repository。
2. 經使用者確認後取得安全版本，展示 Allow 證據。
3. 改查預先選定的 Block 版本。
4. 展示 Curation 阻擋原因與事件。

講者句：

> Codex 可以解釋風險，但真正不可繞過的決策在受治理的下載入口。被阻擋後不換 Registry，才是控制生效。

## 場景 2：模型安全（4 分鐘）

1. 在 AI Catalog 顯示安全模型與風險測試模型。
2. 對照來源、雜湊、掃描狀態與 Shadow AI 決策。
3. 展示安全模型 Allow、風險模型 Block 或 Needs Review。
4. 顯示後續 Pull 受 Curation 限制的證據。

講者句：

> 模型「被發現」、「掃描完成」與「允許使用」是三件不同的事；治理需要把它們串成有責任人的流程。

## 場景 3：Skill 供應鏈（4 分鐘）

1. 在 AI Catalog 顯示 `secure-release-review` 的固定版本與掃描結果。
2. 對照風險教材的提示注入、機密存取與未信任下載指標。
3. 透過受治理流程安裝核准 Skill，重啟 Codex 後以 `/skills` 驗證。
4. 要求風險 Skill，展示 Block，而不是把檔案直接複製到本機。

講者句：

> Skill 是可執行工作流程的供應鏈元件。Prompt 本身也要有來源、版本、掃描、核准與撤銷。

## 場景 4：MCP 與 Agent Guard（5 分鐘）

1. 顯示 AI Catalog 中的 `workshop-ops@1.0.0` 與 Project 範圍。
2. 顯示 Tool Policy：Read Allow，Deploy/Delete Block。
3. 由 Codex 呼叫 `get_release_status`，展示成功。
4. 依講師提示測試 `deploy_to_production`，展示 Agent Guard Block 事件。

講者句：

> 核准 MCP Server 不等於核准所有能力。Agent Guard 在每一次 Tool Call 套用政策，將「能連線」與「能做什麼」分開。

## 收尾（1 分鐘）

用 Codex 產出不含機密的稽核表：

| 資產 | 掃描/政策 | 執行點 | 結果 |
|---|---|---|---|
| 安全套件 | Curation Allow | Artifactory | Downloaded |
| 風險套件 | Curation Block | Artifactory | Denied |
| 模型 | Xray + Shadow AI | Curation | Allow/Block |
| Skill | Skill Scanner + 核准 | AI Catalog | Installed/Denied |
| MCP Tool | Tool Policy | Agent Guard | Called/Denied |

## Demo 前最後檢查

- [ ] 關閉通知與含客戶資料的視窗。
- [ ] 終端歷史沒有 Token。
- [ ] 固定資產、版本、政策與帳號已驗證。
- [ ] 清空非必要的 Codex 上下文。
- [ ] 準備 Allow/Block 截圖與錄影備援。
- [ ] 計時器設定為 20 分鐘。
