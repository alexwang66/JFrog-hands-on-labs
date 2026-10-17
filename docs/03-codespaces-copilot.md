# GitHub Codespaces 與 Copilot 學員操作

本頁提供最短的學員路徑：建立 Codespace、開啟 Copilot Chat、輸入一個 `/moduleN` 指令。所有治理邏輯仍受 JFrog Server `workshop`、Project `workshop` 與指定 Virtual Repository 約束。

## 講師課前設定

1. 確認 Repository 已啟用 GitHub Codespaces，學員帳號可建立 Codespace，並具 GitHub Copilot 使用權。
2. 確認 GitHub Organization 的 Copilot **Editor preview features** 已啟用，並依 JFrog 官方流程安裝/信任 [JFrog Agent Plugin for VS Code](https://docs.jfrog.com/ai-ml/docs/vs-code)。Repository 已加入官方 Plugin Marketplace 來源，但 VS Code 的信任動作仍需由組織或使用者完成；不得以直接本機 MCP 掛載取代。
3. 以 GitHub Repository 或 Organization Codespaces Secret 提供 `JFROG_ACCESS_TOKEN`：
   - 只授與 Project `workshop` 所需的最小讀取權限；
   - 使用短效 Token；
   - 將 Secret 限定給本 Repository；
   - 不把值寫入檔案、Issue、Chat、截圖或課程講義。
4. 完成各模組自己的平台端課前準備。Codespace 不會自動發佈資產、建立政策、建立豁免或解除封鎖。
5. 使用學員權限建立新的 Codespace 並預演四個指令；保存不含憑證的時間、Project、資產版本、政策與結果。

GitHub 也會在 **Code → Codespaces → New with options** 顯示 Repository 建議的 Secret。這只是提醒，不會把 Secret 值存進 Git。

## 學員操作

1. 在 GitHub Repository 選擇 **Code → Codespaces → Create codespace on main**。
2. 等待終端顯示 `Codespace 教材驗證：PASS`。
3. 開啟 **Copilot Chat**，確認使用 **Local Agent** 工作階段。
4. 輸入一個指令：

   ```text
   /module1
   ```

   其他獨立模組使用 `/module2`、`/module3` 或 `/module4`。

5. 首次執行時，Copilot 可能要求核准終端工具呼叫；檢查命令必須是 `bash scripts/run-module.sh <模組編號>` 才核准。
6. 依 Copilot 最終表格保存稽核證據；畫面不得包含憑證。

學員不需要輸入 `jf c use`、`jf setup` 或個別 Lab 命令。Codespace 會以 Secret 設定固定的 `workshop` Server，模組執行器會再次檢查 Server、Project 與 Repository。

## 模組行為

| 指令 | 自動執行 | 安全停止條件 |
|---|---|---|
| `/module1` | npm 綁定、Axios Curation Block、合規版本安裝 | Registry、惡意版本或建議版本不符合預期 |
| `/module2` | PyPI 綁定、兩個模型候選 Dry Run | 未取得講師對實際模型下載的明確核准 |
| `/module3` | 教材雜湊驗證、AI Catalog Skill 查詢；條件通過才安裝核准 Skill | Catalog 無資產、掃描中、未核准、evidence 失敗或被阻擋 |
| `/module4` | MCP 離線 Smoke Test、Agent Guard Catalog 查詢與安全 Allow 測試 | Catalog 無核准 MCP 或 JFrog Agent Plugin 未啟用；不得直接掛載本機 MCP |

## 疑難排解

- **看不到 `/module1`～`/module4`**：確認 Copilot Chat 使用 Local Agent，執行 **Developer: Reload Window**；Prompt Files 是 Preview 功能，組織政策也必須允許。
- **JFrog 401/403**：確認 Codespaces Secret 已關聯到此 Repository，然後 **Codespaces: Rebuild Container**。不要在 Chat 或終端參數貼 Token。
- **Module 1 Registry 不符**：停止，重建 Codespace；不得加上公用 `--registry`。
- **Module 3 或 4 Catalog 為空**：停止並通知講師完成平台端課前準備，不得從外部來源補找。
- **Module 4 找不到 Agent Guard 工具**：請講師確認 JFrog Agent Plugin 已安裝、信任並重新開啟 Copilot Chat；不要直接掛載本機 MCP。
- **Module 2 要求實際下載**：必須先由講師核准精確模型、Revision、容量與測試資產；預設課程只跑 Dry Run。

Prompt Files 目前是 GitHub Copilot Preview，且 VS Code 的 Prompt File slash command 只支援 Local harness。若組織政策停用此功能，學員可用終端備援：`bash scripts/run-module.sh <1|2|3|4>`；治理邊界完全相同。

## 官方參考

- [GitHub：Using GitHub Copilot in GitHub Codespaces](https://docs.github.com/en/codespaces/reference/using-github-copilot-in-github-codespaces)
- [GitHub：Specifying recommended secrets for a repository](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers/specifying-recommended-secrets-for-a-repository)
- [GitHub：Your first prompt file](https://docs.github.com/en/copilot/tutorials/customization-library/prompt-files/your-first-prompt-file)
- [Visual Studio Code：Use prompt files](https://code.visualstudio.com/docs/agent-customization/prompt-files)
