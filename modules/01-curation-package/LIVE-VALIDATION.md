# 模組 1 Live Validation

## 驗證摘要

驗證時間：2026 年 10 月 17 日 19:09–19:13（Asia/Shanghai）。

| 檢查 | 實際結果 |
|---|---|
| JFrog CLI Server ID | `workshop`，Web Login 後驗證成功 |
| Platform | `https://alexwangtrial.jfrog.io/` |
| Artifactory | `7.174.0`，Curation entitlement 已啟用 |
| Project | 建立並驗證 `workshop` |
| Virtual Repository | `workshop-npm`，已指派給 Project `workshop` |
| Virtual 成員 | `workshop-npm-local`、`workshop-npm-remote` |
| npm Registry | `https://alexwangtrial.jfrog.io/artifactory/api/npm/workshop-npm/` |
| Public Catalog | Axios 共 147 個版本；`1.14.1`、`0.30.4` 均為 `knownToBeMalicious=true` |
| Public Catalog 最新版本 | `1.20.0` |
| 受治理版本清單 | `axios@1.14.1` 不可見；最高可見版本為 `1.20.0` |
| 風險版本安裝 | `axios@1.14.1` → `ETARGET / No matching version` |
| 合規版本安裝 | `axios@1.20.0` 成功，安裝 27 個套件 |
| lifecycle scripts | 兩次安裝皆使用 `--ignore-scripts` |
| Registry 繞道 | 無；未改用公用 Registry、其他 Server 或其他 Repository |

## Catalog 與解析階段證據

OneModel Public Catalog 查詢以 `workshop` 為唯一 Server，得到：

```text
PACKAGE=axios
TYPE=npm
LATEST_CATALOG_VERSION=1.20.0
VERSION_COUNT=147
HAS_NEXT_PAGE=false
VERSION=1.14.1 LISTED=true KNOWN_MALICIOUS=true DISCLOSED_BY_JFROG=false
VERSION=0.30.4 LISTED=true KNOWN_MALICIOUS=true DISCLOSED_BY_JFROG=false
```

npm 的本機版本篩選設定未造成阻擋：

```text
NPM_BEFORE=null
NPM_MIN_RELEASE_AGE=undefined
```

同一受治理 Registry 的版本清單不含 `1.14.1`，但 Catalog 明確列出該版本。因此本次 `ETARGET` 與 Curation 的解析階段／CVS filtering 行為一致，不是因版本從未存在，也不是 npm 本機版本年齡篩選。

## 實際阻擋輸出

安裝命令使用 `--ignore-scripts`：

```bash
npm install axios@1.14.1 --ignore-scripts --package-lock=false --no-audit --no-fund
```

實際結果：

```text
npm error code ETARGET
npm error notarget No matching version found for axios@1.14.1.
```

這是解析階段失敗，套件未進入下載階段；因此不能期待這次失敗本身產生 Package Download Audit Event。

## 合規版本建議與安裝

```bash
npm view axios version --json
```

結果：

```json
"1.20.0"
```

安裝：

```bash
npm install axios@1.20.0 --ignore-scripts --package-lock=false --no-audit --no-fund
```

驗證結果：

```json
{
  "name": "axios",
  "version": "1.20.0"
}
```

## Curation API 判讀

即時 `package_status/all_repos` 對 `axios@1.14.1` 與 `axios@1.20.0` 都顯示：

- `curation.enabled=true`。
- `not_found_in_catalog=false`。
- `workshop-npm-remote` 的下載 Gate 為 `approved / No policy violations`。
- 「所有 Repository」摘要為 `Partial Download Blocked`，但阻擋來自其他 Repository，不得拿來代表 `workshop-npm-remote`。

下載 Gate 為 approved 不會推翻解析階段結果；兩者是不同 Gate。`axios@1.14.1` 已在版本解析時不可見，因此 npm 先回傳 `ETARGET`，沒有下載該版本。

## 稽核限制

本工作階段沒有 `jfs_curation_query_cvs_audit_events` 與 `jfs_curation_get_cvs_audit_version_detail` MCP 工具，因此無法以工具取得這次解析結果對應的 CVS event ID、精確 policy name 與 condition name。不得用其他 Repository 的 policy 名稱替代，也不得猜測。

正式授課證據需在 JFrog **Curation → Audit Events → Compliant Version Selection** 補錄 `axios` 的最新歷史評估，至少保留：

- policy name 與 condition name；
- CVS event ID 與時間；
- `workshop-npm-remote`；
- `axios@1.14.1` 的 action；
- 選出的合規版本。

在補齊 CVS Audit 前，可以確認「Catalog 將版本標記為惡意、受治理 Registry 不回傳該版本、Live Demo 阻擋成功」，但不要宣稱已完成含 policy name 的完整 Curation RCA。

## 對外說法

> Codex/JFrog Agent 將 npm 請求導向 `workshop-npm`。JFrog Public Catalog 將 `axios@1.14.1` 標記為惡意，而同一受治理 Registry 不回傳該版本；npm 在解析階段以 `ETARGET` 停止。Agent 沒有繞道，並從相同來源取得及安裝最高可見版本 `1.20.0`。

不要說「Agent Guard 掃描並阻擋 Axios」；本案例的治理執行者是 JFrog Curation。

## 重跑前檢查

威脅情資與版本會變動。每次開課前重新確認：

1. Public Catalog 的 `knownToBeMalicious` 狀態。
2. `npm view axios versions --json` 是否仍不含 `1.14.1`。
3. `npm view axios version --json` 的最高可見版本。
4. `workshop-npm` 仍指派給 Project `workshop`，且只包含預期的 Local/Remote Repository。
5. CVS Audit 的 policy name、condition、event ID 與時間。
