# 模組 4：MCP 統一管理與 Agent Guard Tool Policy

本模組可獨立進行，將一個無外部相依的 MCP Server 封裝進 Artifactory、登錄 AI Catalog，透過 Agent Guard 安裝至 Codex，並驗證 Tool Call 的 Allow/Block。建議時間 60 分鐘。

學員快速操作與停止條件請見 [CUSTOMER-GUIDE.md](CUSTOMER-GUIDE.md)；2026 年 10 月 17 日的 `workshop` 實測結果請見 [LIVE-VALIDATION.md](LIVE-VALIDATION.md)。

## Quick Start：學員操作

學員只需先執行一個命令：

```bash
bash modules/04-mcp-governance/run-customer-demo.sh
```

Catalog 出現 `workshop-ops@1.0.0` 後，依 [CUSTOMER-GUIDE.md](CUSTOMER-GUIDE.md) 貼入安裝、Allow 與 Block 三段 Codex 提示詞。套件發佈、MCP 登錄、Project Scope 與 Tool Policy 全部由講師預先完成。

## 完成標準

- MCP 套件以固定版本保存於 Artifactory。
- AI Catalog 只將 Server 核准給指定 Project。
- Codex 透過 Agent Guard 安裝，不直接掛載本機 Server。
- `get_release_status` 可呼叫。
- `deploy_to_production` 與 `delete_repository` 被 Agent Guard 阻擋。
- 每次 Tool Call 都有可稽核決策。

## 前置條件

本模組不依賴 Curation、模型或 Skill 模組。需要：

- JFrog SaaS 的 Artifactory、AI Catalog、MCP Registry、Agent Guard 與 Project。
- 一個工作坊 npm Local Repository，用於內部 MCP 套件。
- Codex、Node.js 18+、npm、JFrog CLI 與 JFrog Codex Plugin。
- 平台管理員能登錄 MCP Server 並設定 Project 級 Tool Policy。

## MCP 工具

| Tool | 行為 | 政策 |
|---|---|---|
| `get_release_status` | 回傳模擬版本狀態 | Allow |
| `deploy_to_production` | 不執行部署；Server 端也會拒絕 | Block |
| `delete_repository` | 不執行刪除；Server 端也會拒絕 | Block |

## 步驟 A：獨立本機驗證

```bash
bash modules/04-mcp-governance/validate.sh
```

預期看到 MCP Smoke Test 與模組驗證 PASS。這只證明 Server 行為，不代表 Agent Guard 已生效。

## 步驟 B：封裝（管理員）

```bash
cd modules/04-mcp-governance/mcp-server
npm pack --dry-run --ignore-scripts
npm pack --ignore-scripts
```

檢查 Tarball 只有 `package.json`、`server.mjs` 與測試檔。不要加入 Token、`.npmrc`、Log 或客戶資料。

## 步驟 C：發佈到 Artifactory（管理員）

1. 在 Artifactory UI 對 `<JFROG_NPM_LOCAL_REPO>` 使用 **Set Me Up**。
2. 取得精確 Publish URL；不可猜測，也不可使用公用 npm。
3. 以組織核准的認證流程發佈 `@workshop/governed-ops-mcp@1.0.0`。
4. 記錄 Repository、版本、SHA-256、發佈者與時間。

若發佈收到 401/403，停止並修正同一個 Server ID 的權限，不得切換其他 Server 或 Registry。

## 步驟 D：AI Catalog 登錄（管理員）

1. 開啟 MCP Registry，新增 `workshop-ops`。
2. Source 指向 Artifactory 中的固定套件版本。
3. 驗證三個 Tool 的名稱與 Schema。
4. Scope 只選 `<JF_PROJECT>`。
5. 核准 Server；不要核准到全組織。

介面欄位可能因 SaaS 版本不同，以當前租戶為準。

## 步驟 E：Tool Policy（管理員）

建立 Project 級政策：

```text
Allow: workshop-ops/get_release_status
Block: workshop-ops/deploy_to_production
Block: workshop-ops/delete_repository
```

確認模式為 Enforce，而非 Audit。保存 Policy 名稱與適用範圍。

## 步驟 F：Codex/Agent Guard 設定（學員）

```bash
jf rt ping --server-id <JFROG_SERVER_ID>
codex plugin list
codex mcp list
```

在 Codex `/skills` 執行 `jfrog-init`，指定 Server ID 與 Project；在 `/hooks` 確認 JFrog Hook 信任。

```text
請只使用 JFrog Server <JFROG_SERVER_ID> 與 Project <JF_PROJECT>。列出可核准安裝的 MCP Servers。找到 workshop-ops 1.0.0，說明來源、Project Scope 與 Tool Policy；未經我確認不要安裝。
```

確認後：

```text
請透過 JFrog AI Catalog/Agent Guard 安裝已核准的 workshop-ops 1.0.0。不要建立直接連到本機程式或其他 Registry 的 MCP 設定。
```

重新啟動 Codex，再執行 `codex mcp list`。不應存在同名的未受治理 Server。

## 步驟 G：Allow

```text
請呼叫 workshop-ops 的 get_release_status，release 設為 2026.10-demo，並回報 Agent Guard 的允許證據。
```

預期回覆 `Release 2026.10-demo is ready for review.`，並有 Agent Guard Allow 事件。

## 步驟 H：Block

只有講師明確指示時執行：

```text
這是工作坊政策測試。請嘗試呼叫 workshop-ops 的 deploy_to_production，release 設為 2026.10-demo。若被阻擋，請停止並回報政策；不要繞過或改用其他工具。
```

預期 Agent Guard 在 Tool 到達 Server 前阻擋。若回覆是 Server 自身的 `Denied by the demo server's defense-in-depth policy.`，代表防禦縱深生效，但 Agent Guard 尚未攔截；修正安裝路徑或 Tool Policy 後重測。

## 驗收

| 項目 | 預期 |
|---|---|
| 套件來源 | Artifactory 固定版本 |
| Server 核准 | 只限工作坊 Project |
| 安裝路徑 | AI Catalog → Agent Guard → Codex |
| Read Tool | Allow 且成功 |
| Deploy/Delete | Agent Guard Block |
| 稽核 | Server、Tool、使用者、Project、Policy 與時間完整 |

## 常見問題

- Codex 看不到 MCP：確認 Plugin、JFrog MCP Login、Project 與重新啟動。
- Tool Policy 沒生效：檢查是否直接掛載了本機 MCP、名稱/版本是否匹配、模式是否 Enforce。
- 同名 Server：移除未受治理設定，只保留 Agent Guard 版本。
- 套件無法執行：確認 Node.js 版本與 Artifactory Package metadata。

## 清理

1. 學員透過 Codex/Agent Guard 管理流程移除 `workshop-ops`。
2. 管理員撤銷 Project 核准與 Tool Policy。
3. 匯出稽核證據後，才可刪除精確的測試套件版本。
4. 不刪除共用 Repository、Service User 或全域政策。
