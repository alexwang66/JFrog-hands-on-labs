# Module 4 Live Validation

本文件記錄 2026 年 10 月 17 日以客戶身分對 `workshop` 執行的實測。它區分本機 Server 行為與 Agent Guard 治理結果；兩者不可混為一談。

## 驗證範圍

| 欄位 | 實測值 |
|---|---|
| 時間 | `2026-10-17 19:49–19:53 CST (+0800)` |
| JFrog CLI Server ID | `workshop` |
| JFrog Project | `workshop` |
| Node.js | `v20.20.2` |
| npm | `10.8.2` |
| MCP Catalog 名稱 | `workshop-ops` |
| npm 套件 | `@workshop/governed-ops-mcp@1.0.0` |

## 執行結果

### Server 與本機 Smoke Test

```text
jf rt ping --server-id workshop
OK

bash modules/04-mcp-governance/validate.sh
Module 04 MCP smoke test: PASS
Module 04 validation: PASS
```

Smoke Test 證明本機 Server：

- 暴露三個 Tool；
- `get_release_status` 可回傳模擬狀態；
- `deploy_to_production` 由 Server 防禦縱深拒絕。

這不是 Agent Guard 政策證據，也沒有將本機 Server 掛載到 Codex。

### 套件內容

執行 `npm pack --dry-run --ignore-scripts` 與隔離暫存目錄中的實際 Pack。Tarball 只包含：

```text
package/package.json
package/server.mjs
package/smoke-test.mjs
```

本次暫存 Tarball SHA-256：

```text
3e20eaa1fa0bb6704d1dce8a17e5f8a522e58f7f685504c44502d3e232e33d68
```

Tarball 只建立於系統暫存目錄，未發佈至 Artifactory。正式發佈時必須重新計算並記錄實際上傳檔案的 SHA-256。

### MCP Catalog 查詢

以 Agent Guard 對 Project `workshop` 執行可安裝 MCP 查詢，實際結果只有表頭：

```text
name	type	version	description
```

判讀：Project `workshop` 目前沒有可供客戶安裝的 MCP，包含 `workshop-ops`。客戶端停止，沒有直接掛載 `server.mjs`，也沒有從其他 Registry 或外部 Catalog 安裝替代 MCP。

## Repository 與政策狀態

平台唯讀盤點發現一個名為 `workshop-npm-local` 的 npm Local Repository，且 Repository 設定顯示 Xray Indexing 已開啟。但講師尚未在 Module 4 明確指定它為本 Lab 的核准發佈目標，因此本次沒有：

- 發佈 `@workshop/governed-ops-mcp@1.0.0`；
- 在 MCP Registry 建立 `workshop-ops`；
- 設定 Project Scope；
- 建立或修改 Tool Policy；
- 寫入 Codex MCP 設定；
- 呼叫受 Agent Guard 管理的 Tool。

因為 Catalog 沒有資產，本次無法取得精確 Tool Policy 名稱、Allow/Block Event 或「是否在到達 Server 前攔截」的證據。這些欄位不可由本機 Smoke Test 推論。

## 客戶模擬結論

| 檢查 | 結果 |
|---|---|
| Server 可連線 | PASS |
| MCP 本機 Smoke Test | PASS |
| Tarball 內容最小化 | PASS |
| `workshop-ops` 可從 Project Catalog 安裝 | NOT READY |
| Agent Guard Allow 事件 | NOT RUN－Catalog 無資產 |
| Agent Guard Block 事件 | NOT RUN－Catalog 無資產 |
| 客戶未直接掛載本機 MCP | PASS |
| 整體 Module 4 治理驗收 | BLOCKED－等待講師確認 Repository 並完成管理員設定 |

本次「Catalog 為空即停止」是正確的客戶端安全行為，但不等於已完成 Agent Guard Tool Policy 驗收。

## 簡化入口複驗

`2026-10-17 21:13 CST (+0800)` 執行：

```bash
bash modules/04-mcp-governance/run-customer-demo.sh
```

結果為 Server `OK`、MCP Smoke Test `PASS`，Catalog 只回傳表頭，腳本正確提示學員停止且不得直接掛載本機 MCP。

## 後續必要條件

1. 講師明確確認 Module 4 的 npm Local Repository。
2. 管理員在明確核准後發佈固定套件版本，並記錄實際 Tarball SHA-256。
3. 管理員將 `workshop-ops@1.0.0` 登錄 AI Catalog，Scope 只限 `workshop`。
4. 管理員建立 Enforce 模式的 Allow/Block Tool Policy。
5. 重新執行 [CUSTOMER-GUIDE.md](CUSTOMER-GUIDE.md) 的 Catalog、安裝、Allow 與 Block 路徑。
