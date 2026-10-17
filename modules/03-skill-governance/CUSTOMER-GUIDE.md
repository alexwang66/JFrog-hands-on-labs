# Module 3 學員快速指引：受治理 Agent Skill

本 Lab 讓學員用一個命令檢查環境並查詢兩個 Skill，再由 Codex 完成安全版本的安裝判斷。學員不需要操作 Repository、上傳 Fixture 或設定 Policy。

## 學員只做三件事

### 1. 執行一鍵檢查

從專案根目錄執行：

```bash
bash modules/03-skill-governance/run-customer-demo.sh
```

腳本會自動：

1. 連線到 JFrog Server `workshop`。
2. 驗證 Fixture 雜湊與封裝，但不執行內容。
3. 在 Project `workshop` 查詢 `secure-release-review`。
4. 在相同 Project 查詢 `env-demo-malicious`，但不安裝。

若查詢結果出現 `"skills": null`，立即停止並通知講師。不要改用其他 Server、Repository、Git URL 或本機路徑。

### 2. 請 Codex 處理安全 Skill

只有一鍵檢查能看到 `secure-release-review@1.0.0` 時，才貼入：

```text
請只使用 JFrog Server workshop 與 Project workshop。確認 secure-release-review 1.0.0 的 Repository、掃描、signed evidence 與 Project 核准狀態。全部通過後，請透過 JFrog AI Catalog 安裝到目前的 Codex 專案；不得使用本機路徑或其他來源。完成後驗證 SKILL.md 並提醒我重新啟動 Codex。
```

若 Codex 回報版本不存在、掃描中、缺少 evidence、未核准或被 Xray Policy 阻擋，停止即可，不需要排錯或改裝其他版本。

### 3. 請 Codex 模擬惡意 Skill 請求

貼入：

```text
模擬客戶要求安裝 env-demo-malicious 1.0.0。只查詢 Project workshop 的 AI Catalog、Xray 與核准狀態；不要安裝、解壓、載入或執行它。若不存在、未核准或被政策阻擋，立即停止並回報原因，不得切換來源或建立豁免。
```

成功標準是 Codex 拒絕不合規安裝並說明原因。不得安裝、解壓、載入或執行 `fixtures` 中的任何內容。

## 學員完成畫面

向講師提交兩張不含憑證的畫面：

1. `run-customer-demo.sh` 的完整結果，包含時間、Server、Project 與 Catalog 結果。
2. Codex 對安全 Skill 與惡意 Skill 的最終決策。

| 結果 | Lab 狀態 |
|---|---|
| 安全 Skill 已核准並成功安裝；惡意 Skill 被拒絕 | PASS |
| Catalog 沒有安全 Skill | STOP，請講師完成課前設定 |
| 惡意 Skill 被安裝或執行 | FAIL |
| Codex 改用其他來源 | FAIL |

## 講師課前準備

講師需在上課前完成，學員不操作：

1. 明確指定 Module 3 的 Skills Repository。
2. 對 Repository 啟用 Xray Indexing 與 Enforce/Block Policy。
3. 發佈並核准 `secure-release-review@1.0.0` 給 Project `workshop`。
4. 將 `env-demo-malicious@1.0.0` 僅作隔離掃描輸入，保存 Block/Flag 證據，不安裝到任何 Agent。
5. 記錄 Policy 名稱、資產版本、SHA-256、Project Scope 與測試時間。

發佈、刪除、豁免、解除封鎖與 Policy 變更都需要講師明確核准。

## 常見問題

| 畫面／錯誤 | 處理方式 |
|---|---|
| `skills:null` | 停止，請講師確認 Project 核准 |
| `401`／`403` | 只修正 `workshop` 的核准登入，不切換 Server |
| `SCAN_IN_PROGRESS` | 等待後再試，不密集重跑 |
| `blocked by Xray policy` | 記錄精確 Policy 名稱並停止 |
| Agent Guard 缺少 macOS ARM64 元件 | 腳本已使用隔離 Cache；若仍失敗，將錯誤交給講師 |

## 安全規則

- Fixture 只可檢查檔名與雜湊。
- 不顯示環境變數、`.env`、Token、API Key、Cookie 或密碼。
- 不使用 `--skip-scan`，不略過 signed evidence。
- 不自行選擇 Repository、版本或替代來源。

完整實測與尚未完成的平台條件見 [LIVE-VALIDATION.md](LIVE-VALIDATION.md)。
