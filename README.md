# JFrog Copilot Workshop

在 GitHub Codespaces 中使用 Copilot 練習 JFrog Skills 與 MCP。

## 開始使用

1. 在此 GitHub Repository 選擇 **Fork → Create fork**，將專案 Fork 到自己的 GitHub 帳號。
2. 依照 [JFrog Access Token 官方文件](https://docs.jfrog.com/administration/docs/access-tokens)，在講師指定的 JFrog Platform 建立 Access Token。使用完成工作坊所需的最小權限及適當的有效期限；若無建立權限，請洽講師。
3. 在 GitHub 點選個人頭像 → **Settings → Codespaces → New secret**：
   - **Name**：`JFROG_ACCESS_TOKEN`。
   - **Value**：貼上剛建立的 Access Token。
   - **Repository access**：選擇剛 Fork 的 Repository，然後按 **Add secret**。詳見 [GitHub Codespaces Secret 文件](https://docs.github.com/en/codespaces/managing-your-codespaces/managing-your-account-specific-secrets-for-github-codespaces)。
4. 回到自己 Fork 的 Repository，選擇 **Code → Codespaces → Create codespace on main**。
5. 開啟 Copilot Chat，再開啟 [Module 1](modules/01/README.md)，先在 Codespace Terminal 安裝並設定 JFrog CLI，再將提示詞貼到 Copilot Chat。

不要將 Access Token 貼到聊天、終端機或檔案，也不要提交至 Git。

## 設定

| 項目 | 值 |
|---|---|
| JFrog Platform | `https://alexwangtrial.jfrog.io` |
| Server ID | `workshop` |
| Project | `workshop` |
| 核准的 npm Virtual Repository | `workshop-npm` |

JFrog Skills 與 MCP 的實際安裝及驗證由 Module 1 提示詞引導；若必要 Repository 或 Catalog 資產不可用，應安全停止並由講師處理。
