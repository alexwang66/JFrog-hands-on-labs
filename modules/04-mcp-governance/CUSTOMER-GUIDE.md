# Module 4 學員快速指引：MCP 與 Agent Guard

本 Lab 讓學員用一個命令檢查 MCP Server 並查詢 Project Catalog，再用三段 Codex 提示詞完成安裝、Allow 與 Block 驗證。學員不需要封裝、發佈、登錄 MCP 或設定 Tool Policy。

本機直接掛載僅可做離線 Smoke Test，不代表治理成功。

## 學員只做四件事

### 1. 執行一鍵檢查

從專案根目錄執行：

```bash
bash modules/04-mcp-governance/run-customer-demo.sh
```

腳本會自動：

1. 連線到 JFrog Server `workshop`。
2. 執行無外部相依的 MCP Smoke Test。
3. 查詢 Project `workshop` 可安裝的 MCP。

若 Catalog 只有以下表頭，立即停止並通知講師：

```text
name	type	version	description
```

不要直接執行或掛載本機 `server.mjs`，也不要從外部 Catalog 補找 MCP。

### 2. 請 Codex 安裝 MCP

只有一鍵檢查能看到 `workshop-ops@1.0.0` 時，才貼入：

```text
請只使用 JFrog Server workshop 與 Project workshop。確認 Catalog 中 workshop-ops 1.0.0 的套件來源、Project Scope 與 Tool Policy，然後透過 Agent Guard 安裝到目前的 Codex。不得建立本機直連、http 或 sse 繞過設定。完成後提醒我重新啟動 Codex，並確認至少能看到一個 Tool。
```

重新啟動 Codex 後執行：

```bash
codex mcp list
```

只有 connected、但看不到任何 Tool，仍視為失敗。

### 3. 執行 Allow 測試

貼入：

```text
請呼叫受 Agent Guard 管理的 workshop-ops/get_release_status，release 設為 2026.10-demo。回報結果與 Allow 決策，不要呼叫其他 Tool。
```

預期結果：

```text
Release 2026.10-demo is ready for review.
```

講師應同時看到 Agent Guard Allow 稽核事件。

### 4. 執行 Block 測試

只有講師明確指示時才貼入：

```text
這是工作坊政策測試。請嘗試呼叫受 Agent Guard 管理的 workshop-ops/deploy_to_production，release 設為 2026.10-demo。若被阻擋，立即停止並回報精確 Policy；不得改用其他 MCP、Shell、直接 API 或本機 server.mjs。
```

| 結果 | 判讀 |
|---|---|
| Agent Guard 在 Tool 到達 Server 前阻擋 | PASS |
| `Denied by the demo server's defense-in-depth policy.` | Server 有拒絕，但 Agent Guard 尚未攔截；FAIL |
| Tool 真正執行部署 | 立即停止並通知講師 |

## 學員完成畫面

向講師提交三張不含憑證的畫面：

1. 一鍵腳本結果，包含 Catalog 中的 `workshop-ops@1.0.0`。
2. `get_release_status` 結果與 Agent Guard Allow 事件。
3. `deploy_to_production` 的 Agent Guard Block 事件。

## 講師課前準備

講師需在上課前完成，學員不操作：

1. 明確指定 Module 4 的 npm Local Repository。
2. 發佈 `@workshop/governed-ops-mcp@1.0.0`，保存 Tarball SHA-256。
3. 在 MCP Registry 登錄 `workshop-ops@1.0.0`，Scope 只限 Project `workshop`。
4. 建立 Enforce Tool Policy：

```text
Allow: workshop-ops/get_release_status
Block: workshop-ops/deploy_to_production
Block: workshop-ops/delete_repository
```

5. 以學員權限預演，確認 Block 發生在 Tool 到達 Server 前。

發佈、刪除、解除封鎖、Project 核准與 Policy 變更都需要講師明確核准。

## 常見問題

| 畫面／錯誤 | 處理方式 |
|---|---|
| Catalog 只有表頭 | 停止，請講師完成 MCP 登錄與 Project Scope |
| `401`／`403` | 只修正 `workshop` 的核准登入，不切換 Server |
| connected 但 0 tools | 判定失敗，請講師檢查 MCP 套件與 Agent Guard |
| 只看到 Server 自身拒絕 | 檢查是否直接掛載或 Tool Policy 未生效 |
| Agent Guard 缺少 macOS ARM64 元件 | 腳本已使用隔離 Cache；若仍失敗，將錯誤交給講師 |

## 安全規則

- 不執行真實部署或刪除。
- 不直接掛載本機 MCP 作為治理結果。
- 不顯示或保存 Token、API Key、Cookie、密碼或私鑰。
- Catalog 為空即停止，不使用其他 Registry 或外部 MCP。

完整實測與尚未完成的平台條件見 [LIVE-VALIDATION.md](LIVE-VALIDATION.md)。
