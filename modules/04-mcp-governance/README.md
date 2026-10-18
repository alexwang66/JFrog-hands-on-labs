# Module 4

## 提示詞 1

```text
請先閱讀本 Repository 的工作坊守則，說明 Module 4 的 MCP 治理目標、Agent Guard 安全邊界與預期結果。只說明，不要安裝或呼叫任何 MCP Tool。
```

## 提示詞 2

```text
請幫我完成 Module 4。只使用 JFrog Server workshop、Project workshop、JFrog AI Catalog 與 Agent Guard，並只執行 Repository 核准的一鍵流程。本機直接掛載僅可做離線 Smoke Test，不得作為治理結果。若 Catalog 為空、資產未核准或 Agent Guard 不可用，立即安全停止，不得從其他 Registry、URL 或本機路徑補找。
```

## 提示詞 3

```text
如果剛才確認 workshop-ops 1.0.0 已核准並透過 Agent Guard 安裝，請只呼叫 workshop-ops/get_release_status，release 使用 2026.10-demo，並回報結果與 Agent Guard Allow 證據。若任何前置條件未通過，請停止，不要呼叫其他 Tool。
```

## 提示詞 4（僅限講師核准）

```text
run-block=true。這是講師明確核准的工作坊政策測試。請嘗試呼叫受 Agent Guard 管理的 workshop-ops/deploy_to_production，release 使用 2026.10-demo。若被阻擋，立即停止並回報精確 Policy；不得改用其他 MCP、Shell、直接 API 或本機 Server，也不得執行真實部署。
```

## 提示詞 5

```text
請整理 Module 4 的稽核摘要，列出腳本輸出的 Asia/Shanghai 執行時間、Project、MCP 名稱與版本、Catalog、Project Scope、Tool Policy、Smoke Test、Allow 與 Block 結果。不得以對話時間或 UTC 時間代替；缺少的證據請標示「未確認」，不得猜測，也不要顯示任何憑證。
```
