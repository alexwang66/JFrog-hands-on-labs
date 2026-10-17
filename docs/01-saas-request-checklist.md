# SaaS 申請與開課前檢查

## 給 JFrog Account Team / 平台管理員的申請文字

```text
用途：客戶教育用的非正式環境 JFrog AI Catalog × Codex Workshop。
期間：<開始日期> 至 <結束日期後 3 天>。
預估人數：<人數>；同時使用者：<人數>。
需要：Artifactory、Xray、Curation、JFrog Projects、AI Catalog、Agent Guard、
MCP Registry、Skill Registry/Scanner、Shadow AI 與模型安全掃描能力。
請確認 Skill Scanner 與 jf malicious-scan 的 Beta/授權可用性。
請提供一名平台管理員帳號，以及每位學員僅限指定 Project 的最小權限帳號。
本環境僅放置合成或公開測試資料，不放正式資料與真實機密。
```

## 必要能力

- JFrog SaaS 非正式租戶或獨立 Project。
- Artifactory 與 Xray 已啟用。
- Curation 可建立政策並套用到工作坊 Remote/Virtual Repository。
- AI Catalog 與 Agent Guard entitlement。
- MCP Registry 與 Project 級核准/工具政策。
- Skills Repository 與 Skill 掃描能力；若為 Beta，確認租戶已加入。
- 模型偵測、Shadow AI 與惡意模型掃描能力；確認支援的模型格式。
- JFrog CLI 使用權與足夠的 API Rate Limit。

## 建議資源

實際名稱由管理員決定並填入 `.env.workshop`，文件不猜測 Repository Key。

| 資源 | 類型 | 用途 |
|---|---|---|
| `<npm-remote>` | npm Remote | 代理外部套件來源並套用 Curation |
| `<npm-local>` | npm Local | 保存自製 MCP 教學套件 |
| `<npm-virtual>` | npm Virtual | Codex/學員唯一套件入口 |
| `<skills-local>` | Skills Local | Skill 版本、簽署與掃描 |
| `<model-repo>` | 租戶支援的模型或 Generic Repository | 安全模型與測試資產 |
| `<workshop-project>` | JFrog Project | 隔離角色、資產與政策 |

## 角色與最小權限

| 角色 | 需要的能力 | 不應有的能力 |
|---|---|---|
| 平台管理員 | 建立資源、設定 Xray/Curation、核准 MCP/Skill、檢視稽核事件 | 不使用個人 Token 給學員 |
| 講師 | 上傳測試資產、執行預演、讀取政策與事件 | 不更動租戶全域正式政策 |
| 學員 | 讀取指定 Project、安裝已核准資產、執行 Demo | 不可建立豁免、刪除、改政策或跨 Project |
| 稽核觀察員 | 唯讀檢視政策、掃描結果與事件 | 不可安裝或變更資產 |

## 開課前七天

- [ ] 確認租戶 URL、方案、到期日與支援窗口。
- [ ] 建立 Project、Repository 與角色；學員不可跨 Project。
- [ ] 啟用 Xray Indexing，確認模型與 Skills Repository 在掃描範圍。
- [ ] 建立 Curation 測試政策，確認不是 Dry Run。
- [ ] 建立模型 Allow/Block 決策流程與 Shadow AI 負責人。
- [ ] 在 AI Catalog 註冊 `workshop-ops`，但只核准給工作坊 Project。
- [ ] 設定 Tool Policy：允許 `get_release_status`，阻擋另外兩個工具。
- [ ] 發佈核准 Skill；將風險 Skill 保持在隔離/阻擋狀態。
- [ ] 以講師帳號完整預演四個 Lab。

## 開課前 24 小時

- [ ] 鎖定 `WORKSHOP_SAFE_PACKAGE` 與 `WORKSHOP_BLOCKED_PACKAGE` 的精確版本。
- [ ] 再次驗證 Block 版本確實被目前政策阻擋；不要依賴昨天的結果。
- [ ] 鎖定兩個模型測試資產與其雜湊。
- [ ] 確認掃描完成，避免學員看到長時間 Pending。
- [ ] 確認核准 Skill 與 MCP 的不可變版本。
- [ ] 建立一組乾淨學員帳號，從零驗證 Codex 設定。
- [ ] 將 UI 截圖、預錄影片及事件 ID 保存為 Demo 備援。
- [ ] 執行 `./scripts/validate-workshop.sh`。

## 開課當天 Go / No-Go

Go 必須同時滿足：

- `jf rt ping --server-id <JFROG_SERVER_ID>` 成功。
- Codex 看得到 JFrog Plugin 與 JFrog MCP。
- Curation Allow/Block 各成功一次。
- 模型與 Skill 掃描結果已就緒。
- Agent Guard 能允許讀取工具並阻擋限制工具。

任一核心能力不可用時，不要臨時放寬政策。改用預錄證據講解，並將實作標示為「租戶功能待開通」。
