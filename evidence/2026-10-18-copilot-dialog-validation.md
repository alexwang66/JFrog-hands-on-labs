# GitHub Copilot 逐步對話驗證紀錄

## 驗證環境

- 驗證日期：`2026-10-18`（Asia/Shanghai）
- Codespace：`workshop-validation-eastus-xrrp79qqx99h99pv`
- Repository：`alexwang66/ai-catalog-workshop`
- 基準 Commit：`9afdc33`
- GitHub Copilot CLI：`1.0.98`，安裝於 Codespace 暫存目錄
- 驗證方式：依各 Module `README.md` 的提示詞逐輪續接同一 Copilot 對話
- 機密處理：使用 Codespace 臨時 Keychain；未記錄或輸出 Token、密碼、API Key、Cookie 或私鑰

## 結果

| Module | 說明提示詞 | 執行提示詞 | 後續判讀與摘要 | 結果 |
|---|---|---|---|---|
| 1 | PASS；只說明，未執行命令 | PASS；唯一 Tool Call 為 `bash scripts/run-module.sh 1` | PASS；`axios@1.14.1` 回傳 `ETARGET`，`axios@1.20.0` 安裝成功 | PASS |
| 2 | PASS；只說明 Dry Run 邊界 | PASS；唯一 Tool Call 為 `bash scripts/run-module.sh 2` | PASS；兩個模型候選皆只做 Dry Run，未下載或載入模型 | PASS |
| 3 | PASS；明確禁止操作 Fixture | PASS；唯一 Tool Call 為 `bash scripts/run-module.sh 3` | PASS；兩個 Skill 都是 `skills:null`，未安裝且未宣稱已有平台 Block 證據 | PASS |
| 4 | PASS；正確區分 Smoke Test 與治理結果 | PASS；唯一 Tool Call 為 `bash scripts/run-module.sh 4` | PASS；Catalog 為空時拒絕 Allow 與 Block 呼叫，未直接掛載本機 MCP | PASS |

## 測試發現與修正

1. Copilot CLI 非互動模式的 `shell(...)` 權限依命令名稱比對；自動化測試使用 `shell(bash)` 核准，並以 Tool Call 輸出確認實際命令仍只有對應的 `bash scripts/run-module.sh N`。
2. 原始腳本未輸出明確時間，Copilot 因此以 UTC 對話時間補值。已將一鍵腳本改為輸出 `Asia/Shanghai` 時間，並要求摘要只能引用腳本時間；沒有證據時必須標示「未確認」。
3. Module 3 與 Module 4 的平台 Catalog 尚無核准資產，因此正確驗證結果是安全停止，不是安裝成功或政策 Block 成功。
