# GitHub Codespaces 端到端驗證紀錄

## 驗證範圍

- 完成時間：`2026-10-18T06:26:48Z`
- GitHub Repository：`alexwang66/ai-catalog-workshop`
- Commit：`5183dc9`
- Codespace：`workshop-validation-eastus-xrrp79qqx99h99pv`
- Region：`EastUs`
- JFrog Server ID：`workshop`
- JFrog Project：`workshop`
- 機密處理：未記錄 Token、密碼、Cookie、API Key 或私鑰；未輸出 npmrc 或 pip.conf。

## 前置檢查

| 檢查 | 結果 | 證據摘要 |
| --- | --- | --- |
| Git 狀態 | PASS | `main` 位於 `5183dc9`，工作區乾淨 |
| JFrog 連線 | PASS | `jf rt ping --server-id workshop` 回傳 `OK` |
| npm 綁定 | PASS | `.jfrog/local/package-resolution.json`：`npm=workshop-npm` |
| PyPI 綁定 | PASS | `.jfrog/local/package-resolution.json`：`pypi=workshop-pypi` |
| 教材驗證 | PASS | Module 01–04 validation 全部通過；Module 3 fixture 未執行 |
| Copilot Prompt Files | PASS | `.github/prompts/module1.prompt.md` 至 `module4.prompt.md` 共 4 個 |

## Module 1：npm Curation

| 欄位 | 值 |
| --- | --- |
| Repository | `workshop-npm` |
| 測試資產 | `axios@1.14.1` |
| 阻擋結果 | PASS；npm 回傳 `ETARGET` / `No matching version found` |
| Curated listing 最高版本 | `axios@1.20.0` |
| 合規安裝 | PASS；安裝 `axios@1.20.0` |
| 政策名稱 | 無法由本次環境確認；MCP Gateway 未提供 `jfs_curation_*` Audit 工具，不猜測政策名稱 |

判讀：客戶透過 `workshop-npm` 要求教材指定的惡意／封鎖版本時，該版本未出現在 curated listing；客戶改用 listing 提供的合規版本後安裝成功。未改用公共 Registry，也未建立豁免或修改政策。

## Module 2：模型治理

| 欄位 | 值 |
| --- | --- |
| PyPI Repository | `workshop-pypi` |
| Hugging Face Repository | `workshop-huggingfaceml` |
| Endpoint | `https://alexwangtrial.jfrog.io/artifactory/api/huggingfaceml/workshop-huggingfaceml` |
| 安全候選 | `openai-community/gpt2`，revision `main`，Dry Run PASS |
| 阻擋候選 | `glockr1/ballr7`，revision `main`，Dry Run PASS |
| 實際模型下載 | 未執行；未取得講師對精確模型與 revision 的額外核准 |

## Module 3：Skill 治理

| 檢查 | 結果 |
| --- | --- |
| Fixture 完整性 | PASS；只檢查，未執行或安裝 |
| `secure-release-review` | `skills:null` |
| `env-demo-malicious` | `skills:null`；只查詢，未安裝 |
| 安全決策 | 依教材停止；未從其他來源取得 Skill |

## Module 4：MCP 治理

| 檢查 | 結果 |
| --- | --- |
| MCP 離線 Smoke Test | PASS |
| Module 4 validation | PASS |
| Project `workshop` 可安裝 MCP | 清單只有表頭，沒有核准項目 |
| 安全決策 | 依教材停止；未直接掛載本機 MCP |

## Module 1 一句式入口重測

- 完成時間：`2026-10-18T11:05:19Z`
- Commit：`3986d06`
- 客戶提示詞：`請幫我完成 Module 1`
- Copilot 規則：PASS；Repository 全域指令將提示詞映射到唯一核准的 `bash scripts/run-module.sh 1`，且不要求客戶自行輸入終端命令。
- Codespace Git 狀態：PASS；測試前 `HEAD` 與 `origin/main` 一致，測試後工作區乾淨。
- npm 綁定：PASS；`workshop-npm`。
- Curation Block：PASS；`axios@1.14.1` 回傳 `ETARGET`／`No matching version found`。
- 合規版本：PASS；同一個 `workshop-npm` 顯示並成功安裝 `axios@1.20.0`。
- 安全邊界：未改用公共 Registry、未建立 Waiver、未修改政策、未記錄任何憑證。

## Copilot UI 驗證限制

SSH 可驗證 Prompt File、腳本與完整治理行為，但遠端 `code --list-extensions` 不會列出 GitHub Codespaces 瀏覽器客戶端的擴充套件，因此無法在 headless CLI 中證明 Copilot Chat 已顯示 `/module1`～`/module4`。講師最終畫面驗收應開啟 [測試 Codespace](https://workshop-validation-eastus-xrrp79qqx99h99pv.github.dev)，確認 Local Agent 可選取四個 Prompt File；不要在畫面或 Chat 中顯示 Secret。
