# 模組 1：Codex 套件治理與 JFrog Curation

本模組可獨立進行，使用已驗證的 `workshop`、`workshop-npm` 與 Axios 案例，讓 Codex 的套件取得只走 Artifactory，並重現一次 Curation Block 與一次合規版本安裝。建議時間 45 分鐘。

## 已驗證情境

| 項目 | 實際值 |
|---|---|
| JFrog Platform | `https://alexwangtrial.jfrog.io` |
| JFrog CLI Server ID | `workshop` |
| JFrog Project | `workshop` |
| npm Virtual Repository | `workshop-npm` |
| Curation Remote Repository | `workshop-npm-remote` |
| 惡意版本 | `axios@1.14.1` |
| 另一個 Catalog 惡意版本 | `axios@0.30.4` |
| 建議合規版本 | `axios@1.20.0` |

2026 年 10 月 17 日的實測證據與判讀位於 [LIVE-VALIDATION.md](LIVE-VALIDATION.md)。版本與威脅情資會變動，正式授課前仍需重新執行 Live Demo。

## 控制責任邊界

此情境的精確流程是：

```text
Codex / JFrog Agent 發出安裝需求
        ↓
Agent Package Resolution 將 npm 導向 workshop-npm
        ↓
JFrog Curation 在版本解析階段移除惡意版本
        ↓
Codex 停止安裝，讀取受治理版本清單並建議 axios@1.20.0
```

不要宣稱 Agent Guard 本身掃描 Axios。安全判斷與阻擋由 Curation 執行；Codex/JFrog Agent 負責使用受治理來源、解釋結果並且不繞過政策。

## 完成標準

- Codex、JFrog CLI 與 JFrog Plugin 可用。
- 專案綁定到講師指定的 npm Virtual Repository。
- 安全套件可取得，風險套件被 Curation 阻擋。
- Block 後沒有改用公用 Registry、其他 Repository 或替代版本。
- 保留 Curation/CVS 畫面或具時間戳的命令輸出；解析階段的 `ETARGET` 不要求出現 Package Download Audit Event。

## Quick Start：學員自助操作

以下流程由學員在專案根目錄自行執行。任何 Server、Project、Repository 或 Registry 不符合預期時都應停止，請講師確認；不可改用公用 Registry 或自行選擇其他 Repository。

### 1. 檢查必要工具

```bash
command -v jf
command -v node
command -v npm
command -v jq
```

四個命令都必須回傳可執行檔路徑。

### 2. 建立本機設定

```bash
cp modules/01-curation-package/module.env.example \
  modules/01-curation-package/.env.module
```

`.env.module` 只保存非敏感值，且已由 `.gitignore` 排除。不要加入 Token、密碼、API Key 或 Cookie。

### 3. 選擇並驗證 JFrog Server

```bash
jf c use workshop
jf rt ping --server-id workshop
```

預期 `ping` 回傳 `OK`。若收到 `401` 或 `403`，停止操作並對同一個 `workshop` Server 完成組織核准的登入流程；不要切換到其他 Server。

### 4. 綁定 npm Virtual Repository

```bash
jf setup npm \
  --server-id workshop \
  --repo workshop-npm \
  --project workshop
```

確認 npm 只指向指定的 Artifactory Virtual Repository：

```bash
npm config get registry
```

預期結果：

```text
https://alexwangtrial.jfrog.io/artifactory/api/npm/workshop-npm/
```

若結果不同，停止操作；不要執行安裝，也不要加入 `--registry` 繞過設定。

### 5. 執行本機完整性檢查

```bash
bash modules/01-curation-package/validate.sh
```

預期結果：

```text
Module 01 validation: PASS
```

### 6. 執行 Allow／Block Live Demo

```bash
bash modules/01-curation-package/run-live-demo.sh
```

腳本會在 `/private/tmp` 建立短期測試專案，並依序確認：

1. Registry 為 `workshop-npm`。
2. `axios@1.14.1` 不在受治理版本清單中。
3. 安裝 `axios@1.14.1` 時收到 `ETARGET` 或等價阻擋。
4. 同一 Registry 的最高可見版本為 `axios@1.20.0`。
5. 使用 `--ignore-scripts` 成功安裝 `axios@1.20.0`。

若 Registry 顯示 `1.14.1`、最高版本不再是 `1.20.0`，或阻擋原因不是 Curation 預期行為，腳本會安全停止。不要為了讓 Demo 成功而更換版本、Repository 或政策。

### 7. 保存稽核證據

到 JFrog **Curation → Audit Events → Compliant Version Selection**，記錄：

- 驗證時間與 Project `workshop`；
- Repository `workshop-npm-remote`；
- 套件與版本；
- policy name、condition name、action 與 event ID；
- Curation 選出的合規版本。

命令結果與判讀範例見 [LIVE-VALIDATION.md](LIVE-VALIDATION.md)。畫面與輸出不得包含 Token、Cookie 或其他憑證。

## 角色

| 角色 | 工作 |
|---|---|
| 平台管理員 | 建立 Repository、Project、Curation 政策與學員權限 |
| 講師 | 預選安全/阻擋版本並完整預演 |
| 學員 | 綁定套件來源、操作 Codex、保存 Allow/Block 證據 |

## 前置條件

本模組不依賴其他 Workshop 模組。開始前必須具備：

- JFrog SaaS 的 Artifactory、Xray、Curation 與 Project。
- 一組 npm Remote、Local、Virtual Repository；學員只使用 Virtual。
- Codex、Node.js、npm、JFrog CLI 與 JFrog Codex Plugin。
- 本模組已預設 `axios@1.14.1` 與 `axios@1.20.0`；講師需在開課前重新驗證。

## 管理員設定

1. 確認 `workshop-npm` 指派給 Project `workshop`，且包含 `workshop-npm-remote`。
2. 對 Remote/Virtual 入口啟用 Curation 政策。
3. 確認政策為 Enforce/Block，而非 Dry Run。
4. 重新確認 JFrog Public Catalog 仍將 `axios@1.14.1` 標記為惡意，且受治理 Registry 建議 `axios@1.20.0`。
5. 使用學員角色預演；將名稱與版本交給學員，不交付管理員 Token。

## Codex 整合檢查

```bash
codex plugin list
codex mcp list
```

確認 `.jfrog/local/package-resolution.json` 的 npm binding 為 `workshop-npm`，並在 Codex `/hooks` 信任 JFrog Plugin 的 Session Hook。重新開啟 Codex 工作階段。

## 實作 A：Allow

將下列提示詞貼入 Codex：

```text
請只使用 JFrog Server workshop、Project workshop 與 npm Repository workshop-npm。檢查 axios@1.20.0 的來源與 Curation 狀態。在我確認之前不要安裝，也不要顯示憑證。
```

確認資訊正確後允許 Codex 執行取得。記錄套件、版本、Repository、政策結果、時間與 Project。

預期結果：從 Artifactory 成功取得，Curation 結果為 Approved/Passed。

## 實作 B：Block

```text
請透過 workshop-npm 嘗試取得 axios@1.14.1，安裝時停用 lifecycle scripts。若 Curation 在解析或下載階段阻擋，請回報錯誤與階段；不要改用公用 Registry、鏡像、其他版本或建立豁免。接著讀取同一受治理 Registry 的最高可見 Axios 版本，說明為何建議該版本，經我確認後才可安裝。
```

預期結果：`axios@1.14.1` 回傳 `ETARGET / No matching version`，Codex 停止而不繞道；`npm view axios version` 回傳 `1.20.0`，經確認後可成功安裝。

`ETARGET` 是 Curation 版本解析階段的結果，失敗本身不會產生 Package Download Audit Event。請在 JFrog **Curation → Audit Events** 檢查 Compliant Version Selection/CVS 的歷史評估；不要因 Package Download Audit 沒有事件就誤判為 Curation 未生效。

## 一鍵 Live Demo

確認 npm Registry 已由 `jf setup` 設定後執行：

```bash
bash modules/01-curation-package/run-live-demo.sh
```

腳本只在 `/private/tmp` 建立短期專案，所有安裝都使用 `--ignore-scripts`，並在結束時清除。它會驗證 Registry、惡意版本不可解析、建議版本以及合規安裝結果。

## 驗收

| 檢查 | 預期 |
|---|---|
| 套件來源 | 指定 Artifactory Virtual Repository |
| 安全版本 | `axios@1.20.0` 可取得 |
| 風險版本 | `axios@1.14.1` 回傳 `ETARGET` |
| Codex 行為 | 不繞過、不自行建立 Waiver |
| 稽核 | 有 Project、版本、政策、時間與解析階段證據 |

## 常見問題

- 沒有阻擋：確認版本為 `1.14.1`、Registry 是 `workshop-npm`，並檢查 Curation/CVS 當前情資。
- 401/403：停止操作，對同一個 Server ID 重新完成組織核准的登入流程。
- Hook 未生效：在 `/hooks` 檢查信任，重新開啟 Codex。
- 套件已在本機 Cache：以乾淨工作目錄/Cache 重新預演，不要改政策。

## 清理

1. 刪除本機 `.env.module` 與 Lab 產生的測試專案檔。
2. 不刪除共用 npm Cache 或 Repository。
3. 管理員匯出 Audit Event 後，再依課程範圍撤銷短期政策與學員權限。

## 本機驗證

```bash
bash modules/01-curation-package/validate.sh
```
