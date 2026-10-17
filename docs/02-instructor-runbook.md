# 講師執行手冊

## 課前準備

1. 完成 [SaaS 申請清單](01-saas-request-checklist.md)。
2. 選擇要教授的獨立模組，複製該模組的 `module.env.example`，只填非敏感值。
3. 以密碼管理器或 `jf login` 管理登入，不發送 Token 給學員。
4. 執行本機驗證：

   ```bash
   ./scripts/validate-workshop.sh
   ```

5. 逐一完成四個 Lab 的「管理員預先設定」。
6. 用學員角色重新登入並預演；管理員成功不代表學員權限正確。

## 教學敘事

用同一個問題串起四個 Lab：

> 當 Codex 為了完成任務而取得套件、模型、Skill 與 MCP 時，企業如何知道它用了什麼、來源是否可信、允許做什麼，以及事後如何證明？

每個 Lab 都遵循：

1. Discover：找到資產與來源。
2. Analyze：產生掃描或風險證據。
3. Decide：由政策做 Allow/Block/Needs Review。
4. Enforce：在下載或 Tool Call 時執行決策。
5. Audit：保存可稽核事件。

## Demo 安全規則

- 所有資產都使用合成名稱、固定版本與非正式 Project。
- Block 情境不使用真實惡意程式；只使用 JFrog 官方測試資產或本專案惰性教材。
- 不在投影畫面開啟含 Token 的終端或設定檔。
- 不示範繞過 Curation、停用 Xray、切到公用 Registry 或放寬全域政策。
- `workshop-ops` 的限制工具即使被直接呼叫，也只回覆拒絕，不執行任何外部動作。

## 課堂節奏

每個 Lab 建議：

- 5 分鐘：講清楚風險與責任邊界。
- 8 分鐘：講師示範正確路徑。
- 15–20 分鐘：學員依步驟操作。
- 5 分鐘：對照預期結果與稽核證據。
- 2 分鐘：說明常見誤解。

## 證據保存

每組建立一張表，欄位沿用 `templates/policy-matrix.md`：

- Project、資產、版本/雜湊。
- 來源與 Repository。
- 掃描結果與政策名稱。
- Agent Guard 或 Curation 決策。
- 事件時間與去識別化畫面。

不要保存 Token、Cookie、使用者私人路徑或客戶正式資料。

## 講師口訣

- 「能找到」不代表「已核准」。
- 「掃描完成」不代表「允許使用」。
- 「Agent 說安全」不等於「平台政策允許」。
- 「MCP Server 已核准」不代表「其中每個 Tool 都可呼叫」。
- 「被阻擋」後的正確動作是查看理由與走審核流程，不是換來源。

## 備援方案

若網路或租戶服務異常：

1. 先展示本機 `validate-workshop.sh` 與 MCP Smoke Test，說明這只驗證教材。
2. 使用課前保留的 Allow/Block 截圖與事件 ID。
3. 由學員閱讀所選模組內的 Codex 提示詞，標出每段提示詞中的政策邊界。
4. 不把本機直接掛載 MCP 當成 Agent Guard 成功證據。
