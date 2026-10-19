# Workshop Repository 清理稽核紀錄

## 執行範圍

- 完成時間：`2026-10-19T16:19:45+0800`（Asia/Shanghai）
- JFrog Server ID：`workshop`
- JFrog Project：`workshop`
- 授權：講師明確要求刪除該 Project 下的所有 Repository。
- 機密處理：未記錄 Token、密碼、API Key、Cookie、私鑰或 JFrog CLI 設定檔。

## 刪除前盤點

| Repository | 類型 | Package Type |
|---|---|---|
| `workshop-artifact-local` | Local | Generic |
| `workshop-dataset-local` | Local | Generic |
| `workshop-system-internal-local` | Local | Docker |
| `workshop-docker-remote` | Remote | Docker |
| `workshop-huggingfaceml-remote` | Remote | HuggingFaceML |
| `workshop-npm-remote` | Remote | Npm |
| `workshop-pypi-remote` | Remote | Pypi |
| `workshop-huggingfaceml` | Virtual | HuggingFaceML |
| `workshop-pypi` | Virtual | Pypi |

## 結果與驗證

- 刪除方式：對上列九個已由 Project 篩選取得的明確 Repository 名稱逐一執行 JFrog CLI 刪除；未使用萬用字元。
- 資產版本：本次為 Repository 設定與其內容的永久刪除，無可保留的版本號。
- 結果：9/9 Repository 均回報刪除完成。
- 驗證：重新查詢 `workshop` Project，HTTP `200`，回應陣列為空。
- 剩餘 Repository：`0`。
