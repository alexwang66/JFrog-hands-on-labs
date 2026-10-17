# 工作坊總覽與架構

## 目標

完成後，學員能夠：

1. 說明 JFrog Curation 如何在 Codex 取得套件前做政策判斷。
2. 透過 Xray、Shadow AI 與 Curation 建立模型的發現、掃描、核准與阻擋流程。
3. 將 Skill 視為有版本、來源與風險的供應鏈資產，而非單純提示詞檔案。
4. 在 AI Catalog 統一管理 MCP Server，並由 Agent Guard 對每次 Tool Call 套用政策。
5. 以可稽核證據說明「為何允許」或「為何阻擋」。

## 建議時程（3 小時 30 分）

| 時間 | 單元 | 產出 |
|---:|---|---|
| 20 分 | 開場與威脅模型 | 共同治理語言 |
| 25 分 | Codex 與 JFrog 設定 | 可用的受治理 Agent |
| 35 分 | Lab 1：Curation | 一次 Allow、一次 Block |
| 10 分 | 休息 | — |
| 35 分 | Lab 2：模型治理 | 掃描與 Shadow AI 決策 |
| 35 分 | Lab 3：Skill 治理 | 掃描、版本與核准流程 |
| 40 分 | Lab 4：MCP 治理 | Server 核准與 Tool Policy |
| 20 分 | 端對端 Demo 與討論 | 稽核摘要 |
| 10 分 | 清理 | 租戶與本機復原 |

## 責任分工

| 能力 | 主要責任 |
|---|---|
| Artifactory | 儲存、代理、版本化並提供受控的資產來源 |
| Xray | 掃描與產生安全/授權風險證據 |
| Curation | 在套件或後續模型取得流程中做 Allow/Block 政策決策 |
| AI Catalog | 統一檢視模型、Skill、Plugin、MCP 與 Shadow AI 資產 |
| Agent Guard | 在 Codex 端代理已核准的 MCP，對 Tool Call 執行 Project 政策 |
| Codex | 依使用者意圖執行工作，但不取代平台政策、掃描與核准 |

重要：不要把「掃描」與「執行控管」混為一談。Agent Guard 不等於掃描器；它執行 AI Catalog 與 Project 所定義的核准範圍與 Tool Policy。Curation 也不是 Agent Guard 的別名，而是供應鏈進入點的政策閘道。

## 端對端流程

```text
外部來源 / 內部開發
        │
        ▼
Artifactory 儲存與代理 ──► Xray / Skill Scanner / 模型安全分析
        │                              │
        ├── Curation：下載前 Allow/Block│
        │                              ▼
        └────────────────────────► AI Catalog 核准與 Project 範圍
                                       │
                                       ▼
                               Agent Guard 執行 Tool Policy
                                       │
                                       ▼
                                     Codex
```

## 工作坊成功標準

- 所有學員只連到指定的 JFrog Project。
- 套件 Allow 與 Block 都能重現，且 Block 後沒有繞道下載。
- 模型結果能區分「已掃描」、「已核准」與「可執行」三種不同狀態。
- 風險 Skill 無法進入學員使用路徑；核准 Skill 有明確版本。
- MCP Server 只能從 AI Catalog 的核准清單取得。
- `get_release_status` 可呼叫，`deploy_to_production` 與 `delete_repository` 被 Agent Guard 阻擋。
- 最後可匯出不含機密資訊的稽核摘要。

## 產品版本提醒

Skill Scanner 與 `jf malicious-scan` 可能仍屬 Beta 或依方案開放；介面名稱與功能可用性可能隨租戶版本調整。開課前必須在實際租戶逐步驗證，並準備錄影或截圖作為備援。以 [官方參考資料](references.md) 為準。
