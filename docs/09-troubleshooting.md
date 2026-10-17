# 疑難排解

## 快速診斷順序

1. 本機工具是否存在？
2. JFrog CLI 是否連到正確 Server ID？
3. 使用者是否在正確 Project 且權限足夠？
4. Repository 是否已納入 Project、Xray 與 Curation？
5. Codex Plugin、MCP 與 Hook 是否載入？
6. 資產是否已完成掃描並被核准？
7. Agent Guard 是否為實際執行路徑？

## `ls: .: Operation not permitted`

這通常是 macOS 隱私權/TCC 對 Terminal、Codex 或其宿主程式的資料夾存取限制，不是 Unix 檔案權限本身。

1. 確認錯誤發生在哪個資料夾，避免直接調整整個家目錄權限。
2. 到「系統設定 → 隱私權與安全性」檢查「檔案與檔案夾」或「完整磁碟存取權」。
3. 只對實際使用的 App 授權，完全退出並重新開啟 App。
4. 不要使用 `sudo chmod -R` 或關閉系統保護來處理。

## `jf rt ping` 失敗

```bash
jf config show
jf rt ping --server-id <JFROG_SERVER_ID>
```

- 401/403：重新走組織核准的 `jf login`/SSO，不使用 `npm login` 或把 Token 寫入檔案。
- 找不到 Server ID：請講師提供正確 ID；不可臨時切到其他租戶。
- TLS/Proxy：交由企業網路管理員檢查；不要停用憑證驗證。

## JFrog Plugin 或 MCP 不見了

```bash
codex plugin list
codex mcp list
```

確認已安裝 `jfrog@codex-plugin`、`.mcp.json` 的 host 正確，並執行 `codex mcp login jfrog`。重新啟動 Codex。仍失敗時依 [JFrog Codex Plugin](https://github.com/jfrog/codex-plugin) 的目前版本說明重新檢查。

## Agent Package Resolution 沒生效

- 在 `/hooks` 確認 JFrog Hook 已信任。
- 確認 `.jfrog/local/package-resolution.json` 存在。
- 重新執行明確綁定：

  ```bash
  jf setup npm --server-id <JFROG_SERVER_ID> --repo <JFROG_NPM_VIRTUAL_REPO>
  ```

- 開啟新的 Codex 工作階段。
- 不用 `--registry` 或公用 Registry 繞過。

## Curation 沒有阻擋

檢查：

- 政策是否為 Enforce/Block，而非 Dry Run/Audit。
- 實際下載是否走受政策涵蓋的 Remote/Virtual Repository。
- 套件與版本是否完全匹配講師預驗證值。
- 是否因既有 Cache 或 Local Repository 而沒有觸發預期流程。
- 使用者/Project 是否在政策範圍。

不要為了 Demo 成功而臨時擴大全域 Block；改用預錄證據。

## 模型不出現在 Shadow AI

- 確認資產是目前支援的模型套件/格式。
- 確認 Repository 已納入 Xray Indexing。
- 等待分析完成並重新整理。
- 確認 Project 與權限範圍。
- 若租戶未啟用相應能力，記錄為 entitlement 問題。

## Skill 掃描一直 Pending 或無結果

- 確認 Skill bundle 根目錄有有效 `SKILL.md`。
- 確認 Skills Repository 與 Xray Policy/Watch。
- 確認租戶已開通 Skill Scanner/AI Catalog Security Beta。
- 使用講師預演成功的固定版本；不要在課中反覆發佈新版本。

## MCP 安裝後 Tool Policy 沒攔截

- 確認 MCP 是從 AI Catalog 經 Agent Guard 安裝，不是本機直接設定。
- 移除或停用同名的未受治理 MCP 設定，避免呼叫走錯 Server。
- 確認 Tool 名稱、Server 版本、Project 與 Policy Scope 完全一致。
- 確認政策為 Enforce，不是 Audit。
- 若限制工具到達 Server 並收到 Server 自身的 `Denied`，表示 Agent Guard 尚未攔截；修正後重測。

## 問題回報最小資料

- 時間、使用者角色、Project、Server ID（非 Token）。
- 資產名稱與版本。
- 操作步驟與去識別化錯誤。
- 政策/Watch 名稱與事件 ID。
- `codex --version`、`jf --version`、Plugin 版本。
