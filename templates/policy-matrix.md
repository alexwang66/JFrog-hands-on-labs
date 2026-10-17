# 工作坊政策矩陣

請在開課前以租戶中的實際名稱取代尖括號內容。

| 治理物件 | 進入點 | 偵測/判斷 | 執行點 | Demo 預期 |
|---|---|---|---|---|
| 開源套件 | Codex 安裝請求 | Curation 政策與 Xray 情資 | Artifactory Remote/Virtual | 安全版本允許；指定版本阻擋 |
| 模型 | Artifactory/模型來源 | Xray 模型掃描、Shadow AI | Curation 後續下載政策 | 核准模型允許；未核准模型阻擋 |
| Skill | Skills Repository | Skill Scanner、Xray 政策與 Watch | AI Catalog/Agent Guard | 核准 Skill 可用；風險 Skill 不可用 |
| MCP Server | MCP Registry | 管理員審核、Project 範圍 | Agent Guard | 核准 Server 可安裝 |
| MCP Tool | 已核准 MCP Server | Tool Policy | Agent Guard 每次呼叫 | 讀取允許；部署與刪除阻擋 |

## 建議的最小政策

| 政策代號 | 範圍 | 動作 | 備註 |
|---|---|---|---|
| `CUR-BLOCK-KNOWN-MALICIOUS` | 工作坊套件來源 | Block | 務必以預驗證測試版本示範 |
| `CUR-BLOCK-DISALLOWED-LICENSE` | 工作坊套件來源 | Block | 使用法務核准的授權清單 |
| `MODEL-REQUIRE-APPROVAL` | 模型資產 | Block/Allow | 透過 Shadow AI 進行核准決策 |
| `SKILL-BLOCK-HIGH-RISK` | Skills Repository | Block | Skill Scanner 為 Beta 時先確認租戶資格 |
| `MCP-READ-ONLY` | `workshop-ops` | Allow read; Block write/delete | Project 層級套用 |

## 稽核證據欄位

- 時間與操作人員
- JFrog Project
- 資產名稱與不可變版本
- Repository 或 Registry
- 命中的政策與原因
- Agent Guard 決策
- 最終結果（Allow/Block）
- 去識別化畫面或事件連結
