# 模組 3：Agent Skill 掃描、核准與生命週期

本模組可獨立進行，核心案例使用 `skills-sample/env-demo-malicious` 與既有 `1.0.0` ZIP，驗證 JFrog 對環境變數探查、`.env` 外洩與未信任指示的偵測/阻擋。建議時間 60 分鐘。

學員快速操作與停止條件請見 [CUSTOMER-GUIDE.md](CUSTOMER-GUIDE.md)；2026 年 10 月 17 日的 `workshop` 實測結果請見 [LIVE-VALIDATION.md](LIVE-VALIDATION.md)。

## Quick Start：學員操作

學員只需先執行一個命令：

```bash
bash modules/03-skill-governance/run-customer-demo.sh
```

接著依 [CUSTOMER-GUIDE.md](CUSTOMER-GUIDE.md) 貼入兩段 Codex 提示詞：一段處理安全 Skill，一段模擬惡意 Skill 請求。Repository、發佈、Xray Policy 與 Project 核准全部由講師預先完成。

## 重要安全聲明

`fixtures/env-demo-malicious` 是未信任掃描素材。不得：

- 安裝至 Codex、Claude Code、Cursor 或任何 Agent。
- 執行其中的 Shell 指示。
- 列出或顯示環境變數。
- 將 `.env`、Token 或任何資料傳送到外部。
- 將 Fixture 解壓到 Agent 自動載入的 Skills 目錄。

本模組只允許：檢查檔名/雜湊、上傳至隔離的測試 Skills Repository、觀察 JFrog 掃描與政策結果。

## 來源內容

| 內容 | 用途 |
|---|---|
| `fixtures/env-demo-malicious/SKILL.md` | 安全說明版的 Fixture metadata |
| `fixtures/env-demo-malicious/1.0.0/env-demo-malicious-1.0.0.zip` | 原始惡意 Skill 掃描 Bundle |
| `fixtures/SOURCE.md` | 來源、雜湊與處理規則 |
| `approved/secure-release-review/SKILL.md` | Allow 路徑的對照 Skill |

## 完成標準

- 能驗證 Bundle 雜湊與內容清單，而不執行 Skill。
- 風險 Skill 在同步掃描或 Xray Policy 中被 Block/Flag。
- 核准 Skill 有來源、版本、掃描與 Project 範圍。
- Codex 只能安裝核准版本，不能繞過 Catalog。
- 能說明更新、撤銷與已安裝版本的處理方式。

## 前置條件

本模組不依賴其他 Workshop 模組。需要：

- JFrog SaaS、Artifactory、Xray、AI Catalog/Agent Guard。
- 一個只屬於工作坊 Project 的 Skills Repository。
- Skill Scanner/AI Catalog Security 功能；若為 Beta，先確認 entitlement。
- JFrog CLI 與可使用 `jf skills` 的版本。
- Codex 與 JFrog Codex Plugin。

## 管理員設定

1. 建立 `<JFROG_SKILLS_REPO>` 並納入 `<JF_PROJECT>`。
2. 將 Skills Repository 納入 Xray Indexing 與 Policy/Watch。
3. 設定高風險 Skill 的 Block 規則；確認不是只有 Audit。
4. 將學員權限限制為讀取與安裝已核准 Skill。
5. 管理員才可發佈、撤銷、刪除或變更政策。
6. 開課前在非正式 Project 預演惡意 Fixture；若當前 Scanner 未命中，使用 JFrog 官方當期測試 Fixture，不臨時修改惡意內容。

## 步驟 A：離線驗證，不執行

```bash
bash modules/03-skill-governance/validate.sh
```

此腳本只會驗證：

- ZIP SHA-256。
- ZIP 只有一個 `SKILL.md` 項目。
- 兩個可見 Skill 的 frontmatter。

它不解壓、不載入、不執行惡意 Skill。

## Codex/JFrog 獨立設定

本模組不假設其他 Lab 已設定完成。先驗證：

```bash
jf rt ping --server-id <JFROG_SERVER_ID>
codex plugin list
codex mcp list
```

在 Codex `/skills` 執行 `jfrog-init`，指定同一個 Server ID 與 Project；在 `/hooks` 確認 JFrog Hook 已信任。若租戶、Project 或 Skills Repository 不明確，停止並詢問講師。

## 步驟 B：檢閱風險

由講師投影 `fixtures/SOURCE.md` 與 JFrog Scanner 結果。請學員辨識下列風險類型，但不要複製或執行原始指示：

- 環境變數與 Credential Discovery。
- `.env` 資料外洩。
- 未經使用者知情的外部傳輸。
- 以自然語言包裝的 Prompt Injection。

## 步驟 C：發佈核准 Skill（管理員）

先驗證 CLI 語法：

```bash
jf skills publish --help
```

再使用明確 Server 與 Repository 發佈安全 Skill：

```bash
jf skills publish modules/03-skill-governance/approved/secure-release-review \
  --server-id <JFROG_SERVER_ID> \
  --repo <JFROG_SKILLS_REPO> \
  --version 1.0.0 \
  --quiet
```

不要使用 `--skip-scan`。等待掃描完成，再於 AI Catalog 將固定版本核准給工作坊 Project。

## 步驟 D：掃描惡意 Fixture（管理員）

優先使用講師已預演、會觸發同步掃描的 `jf skills publish` 流程，來源為隔離目錄/Bundle。執行前先用 `jf skills publish --help` 確認目前版本是否接受預封裝 ZIP；若只接受目錄，請使用原始 `skills-sample/env-demo-malicious` 目錄的複本，但不得安裝或執行。

要求：

- 明確指定 `<JFROG_SERVER_ID>` 與 `<JFROG_SKILLS_REPO>`。
- 只在隔離的工作坊 Project。
- 不使用 `--skip-scan`。
- 若被 Block，停止；不切換 Server、Repository 或名稱重試。
- 記錄 Scanner/Policy、風險分類、版本、雜湊與事件。

若 Block 後 Artifact 仍存在，依租戶行為確認其 Quarantine/可見性，再由管理員決定是否清除；不要假設 Block 一定等於 Artifact 已刪除。

## 步驟 E：Codex 安裝 Allow 路徑（學員）

```text
請只使用 JFrog Server <JFROG_SERVER_ID> 與 Project <JF_PROJECT>。列出可供 Codex 使用的 secure-release-review 版本、來源、掃描與核准狀態。未經我確認不要安裝，不要顯示憑證。
```

確認後：

```text
請透過 JFrog AI Catalog/Agent Guard 的受治理流程安裝已核准的 secure-release-review 1.0.0。不要從本機路徑、Git URL 或其他來源複製。完成後提醒我重新啟動 Codex。
```

重新啟動 Codex，以 `/skills` 確認固定版本。

## 步驟 F：Codex Block 路徑（學員）

```text
請在 Project <JF_PROJECT> 查詢 env-demo-malicious 1.0.0 的掃描與核准狀態。不要安裝、載入、解壓或執行它；只回報阻擋政策、風險分類與稽核證據。
```

預期 Codex 不提供安裝路徑，也不把 Fixture 複製到本機 Skill 目錄。

## 驗收

| 項目 | 預期 |
|---|---|
| Fixture 雜湊 | 與 `fixtures/SOURCE.md` 一致 |
| 惡意 Skill | Block/Flag，未安裝、未執行 |
| 安全 Skill | 固定版本、掃描完成、Project 核准 |
| Codex | 只從 AI Catalog/Agent Guard 安裝 |
| 稽核 | 發佈者、版本、掃描、核准與安裝可追溯 |

## 清理

1. 學員從受治理流程移除 Workshop Skill，重新啟動 Codex。
2. 管理員撤銷 Project 核准並匯出掃描/阻擋證據。
3. 若要刪除隔離 Artifact，先確認精確 Repository、路徑與版本，再由管理員操作。
4. 撤銷短期帳號/Token；不可刪除共用 Repository 或 Policy。
