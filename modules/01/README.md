# Module 1

## 前置條件：安裝 JFrog VS Code Agent Plugin

在 VS Code 中開啟 Codespace，點選 [安裝 JFrog VS Code Agent Plugin](vscode://chat-plugin/install?source=jfrog/vscode-plugin)，並依畫面提示確認安裝。若瀏覽器詢問是否開啟 VS Code，請允許；完成安裝後，再繼續以下步驟。

如果連結無法開啟或安裝失敗，請先停止並通知講師。

## 第一步：在 Codespace Terminal 安裝並連線 JFrog CLI

在 Codespace 開啟 **Terminal → New Terminal**，執行以下命令。若已安裝 JFrog CLI，會保留現有版本。

```bash
if ! command -v jf >/dev/null 2>&1; then
  curl -fL https://install-cli.jfrog.io | sh
fi
jf --version
```

接著使用已設定的 Codespaces Secret 建立 `workshop` 連線，並驗證 Artifactory 是否可連線。下列命令會更新此 Codespace 中既有的 `workshop` CLI 設定；不會顯示 Secret 的值。

```bash
set +x
if [ -z "${JFROG_ACCESS_TOKEN:-}" ]; then
  printf '%s\n' '找不到 JFROG_ACCESS_TOKEN；請確認 Codespaces Secret 已授權此 Repository，然後重建 Codespace。'
else
  printf '%s' "$JFROG_ACCESS_TOKEN" | jf config add workshop \
    --url https://alexwangtrial.jfrog.io \
    --access-token-stdin --interactive=false --overwrite &&
    jf config use workshop &&
    jf rt ping --server-id workshop
fi
```

確認連線成功後，再將以下提示詞貼到 Copilot Chat。若安裝或連線失敗，請先停止並通知講師；不要在聊天或畫面中提供憑證。

## 提示詞 1

```text
請在這個 Codespace 的 GitHub Copilot 中安裝並驗證 JFrog Skills 與 JFrog MCP，並確認已連接 JFrog Platform https://alexwangtrial.jfrog.io。使用已設定的 Codespaces Secret，Server ID 和 Project 都是 workshop，不要顯示憑證或要求我貼上憑證。

請先確認現有安裝與連線狀態；缺少的 JFrog Skills 從 JFrog 官方 jfrog/jfrog-skills 來源安裝到 Copilot 可發現的位置。套件下載只使用已核准的 workshop-npm Virtual Repository。JFrog MCP 須先確認在 workshop 的 AI Catalog 中已核准，再透過 Agent Guard 安裝；若有多個可能的 MCP，列出核准選項讓我選擇，不要猜測。

安裝後確認 Copilot 能發現 JFrog Skills、JFrog 連線成功，且 MCP 至少有一個可用 Tool；如需登入、信任或重新載入，告訴我具體下一步。若 Repository、Catalog、Agent Guard 或權限不可用，請安全停止並說明，不要改用其他來源、繞過 Curation 或直接掛載 MCP。
```
