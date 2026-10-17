# Module 3 Live Validation

本文件記錄 2026 年 10 月 17 日以客戶身分對 `workshop` 執行的實測。它只保存不含機密的結果；Catalog、掃描與政策狀態可能變動，正式授課前必須重新驗證。

## 驗證範圍

| 欄位 | 實測值 |
|---|---|
| 時間 | `2026-10-17 19:49–19:53 CST (+0800)` |
| JFrog CLI Server ID | `workshop` |
| JFrog Project | `workshop` |
| JFrog CLI | `2.125.0` |
| 客戶 Agent | Codex |
| 安全 Skill | `secure-release-review@1.0.0` |
| 惡意測試 Skill | `env-demo-malicious@1.0.0` |

## 執行結果

### Server 與教材完整性

```text
jf rt ping --server-id workshop
OK

bash modules/03-skill-governance/validate.sh
Module 03 validation: PASS (fixture inspected, never executed)
```

Fixture ZIP SHA-256：

```text
8a909f1d232a9748936904ed903d64410ae8557811fd2cb92dba00789742b417
```

雜湊與 `fixtures/SOURCE.md` 一致。驗證只讀取 ZIP metadata，未解壓、未載入、未安裝、未執行 Fixture。

### 安全 Skill Catalog 查詢

以 Agent Guard 對 Project `workshop` 搜尋 `secure-release-review`：

```json
{
  "skills": null,
  "exhausted": true
}
```

判讀：Project 目前沒有可供客戶安裝的 `secure-release-review`。客戶端停止，沒有嘗試從本機 `approved` 目錄或其他來源安裝。

### 惡意 Skill Catalog 查詢

以 Agent Guard 對 Project `workshop` 搜尋 `env-demo-malicious`：

```json
{
  "skills": null,
  "exhausted": true
}
```

判讀：Project 目前沒有可供客戶安裝的 `env-demo-malicious`。客戶端停止，沒有安裝、解壓、載入或執行惡意 Fixture。

## Repository 與政策狀態

平台唯讀盤點發現一個名為 `workshop-skills-local` 的 Skills Local Repository，且 Repository 設定顯示 Xray Indexing 已開啟。但講師尚未在 Module 3 明確指定它為本 Lab 的核准發佈目標，因此本次沒有：

- 發佈安全 Skill；
- 上傳惡意 Fixture；
- 建立或修改 Policy/Watch；
- 核准 Project 可見版本；
- 安裝任何 Skill。

由於兩個 Skill 都不在 Project Catalog 中，本次無法取得資產層級的掃描狀態、signed evidence、Policy/Watch 名稱或 Block Event。這些欄位不可臆測。

## 客戶模擬結論

| 檢查 | 結果 |
|---|---|
| Server 可連線 | PASS |
| Fixture 完整性 | PASS |
| Fixture 未執行 | PASS |
| 安全 Skill 可從 Project Catalog 安裝 | NOT READY |
| 惡意 Skill 有平台 Block/Flag 證據 | NOT READY |
| 客戶未繞過 Catalog | PASS |
| 整體 Module 3 治理驗收 | BLOCKED－等待講師確認 Repository 並完成管理員設定 |

本次「沒有核准項目即停止」是正確的客戶端安全行為，但不等於已完成 Allow/Block 的平台治理驗收。

## 簡化入口複驗

`2026-10-17 21:13 CST (+0800)` 執行：

```bash
bash modules/03-skill-governance/run-customer-demo.sh
```

結果為 Server `OK`、教材驗證 `PASS`，兩個 Skill 查詢均回傳 `skills:null`，腳本正確提示學員停止且不改用其他來源。

## 後續必要條件

1. 講師明確確認 Module 3 的 Skills Repository。
2. 管理員在明確核准後發佈安全 Skill，完成掃描與 signed evidence，再只核准給 `workshop`。
3. 管理員依課程設計掃描惡意 Fixture，保存精確 Policy/Watch 與 Block/Flag 證據。
4. 重新執行 [CUSTOMER-GUIDE.md](CUSTOMER-GUIDE.md) 的 Allow 與 Block 路徑。
