# 清理與復原

## 學員本機

1. 結束所有工作坊 Codex 工作階段。
2. 透過 Codex 的 Plugin/MCP 管理介面移除或停用 `workshop-ops`；不要手動刪除其他 MCP。
3. 若講師要求，移除工作坊安裝的 Skill；保留稽核紀錄。
4. 刪除本機 `.env.workshop` 與產生的 `.tgz`。
5. 若 JFrog Server ID 僅供短期工作坊，使用 `jf config` 的目前說明移除；先確認不被其他專案共用。
6. 從 `/hooks` 檢查是否還有不需要的工作坊 Hook 信任。

## 平台端（僅管理員）

按依賴相反順序處理，並先匯出稽核證據：

1. 撤銷學員 Token/Session 與 Project Membership。
2. 停用 `workshop-ops` 的 Project 核准與 Tool Policy。
3. 撤銷工作坊 Skill 版本；記錄已安裝端的處理方式。
4. 將模型決策與 Curation 事件匯出後，移除短期測試政策。
5. 清除只屬於工作坊的測試資產與 Repository。
6. 最後刪除工作坊 Project。

任何刪除前都要確認資源名稱、Project 與擁有者。若租戶與其他活動共用，不要刪除共用 Repository、政策、金鑰或 Service User。

## 保留項目

- 經去識別化的政策與掃描畫面。
- Workshop 版本與 Git Commit。
- 資產版本/雜湊與政策名稱。
- Allow/Block 事件 ID。
- 問題清單與改善項目。

不保留：Token、Cookie、私鑰、學員私人設定、客戶正式資料與完整終端歷史。

## 結案檢查

- [ ] 所有短期帳號與 Token 已失效。
- [ ] 學員無法再存取工作坊 Project。
- [ ] MCP/Skill 的核准狀態已撤銷或歸檔。
- [ ] 測試政策未影響其他 Project。
- [ ] 證據已去識別化並依保存期限管理。
- [ ] 清理結果由第二位管理員複核。
