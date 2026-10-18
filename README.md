# JFrog AI Catalog × GitHub Copilot / Codex 治理實戰工作坊

以 GitHub Copilot 或 Codex 為 AI Agent，完成套件、模型、Skill 與 MCP 的端對端供應鏈治理實作。

本工作坊採用 JFrog SaaS 沙盒環境。核心定位是：Artifactory 管理資產，Xray 負責掃描，Curation 在下載前做政策判斷，AI Catalog 管理 AI 資產，Agent Guard 將核准的 MCP、Skill 與工具政策落實到 Codex。所有會改動 SaaS 的步驟均區分「平台管理員」與「學員」。

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/alexwang66/ai-catalog-workshop?quickstart=1)

## Quick Start

學員建議使用 GitHub Codespaces；環境建立完成後，只需在 Copilot Chat 的 **Local Agent** 輸入一句提示詞：

```text
請幫我完成 Module 1
```

Copilot 會自動呼叫唯一核准的 `bash scripts/run-module.sh 1`，客戶不需開啟終端或自行輸入命令。`/module1` 是等價快捷方式；其他獨立模組仍可使用 `/module2`、`/module3` 或 `/module4`。完整流程：

1. 講師完成 [SaaS 申請與開課前檢查](docs/01-saas-request-checklist.md)及 [Codespaces/Copilot 課前設定](docs/03-codespaces-copilot.md)，包含一次性的 JFrog Agent Plugin 信任設定。
2. 講師將短期、最小權限的 `JFROG_ACCESS_TOKEN` 設為 GitHub Codespaces Secret；不得寫入 Repository 或貼到 Chat。
3. 學員在 GitHub 選擇 **Code → Codespaces → Create codespace on main**。
4. 等待 `Codespace 教材驗證：PASS`，開啟 Copilot Chat 的 Local Agent，輸入「請幫我完成 Module 1」。
5. 若 Copilot 要求終端工具權限，只核准精確的 `bash scripts/run-module.sh 1`；不需自行輸入任何命令。

Codespace 會固定使用 Server `workshop` 與 Project `workshop`，並綁定課程指定的 Virtual Repository。學員不需自行輸入 `jf c use`、`jf setup` 或各 Lab 的命令。

每個模組都能獨立執行：

   - [模組 1：Curation 套件治理](modules/01-curation-package/README.md)
   - [模組 2：Hugging Face 模型治理](modules/02-model-governance/README.md)
   - [模組 3：Skill 掃描與管理](modules/03-skill-governance/README.md)
   - [模組 4：MCP 統一管理](modules/04-mcp-governance/README.md)

Prompt Files 目前是 GitHub Copilot Preview，且 Slash Command 需要 VS Code/Codespaces 的 Local Agent。若組織政策停用 Prompt Files，備援命令為：

```bash
bash scripts/run-module.sh <1|2|3|4>
```

## Configuration

| 模組 | 設定檔 | 主要設定 |
|---|---|---|
| Curation | `modules/01-curation-package/module.env.example` | Server、Project、npm Virtual、Allow/Block 套件 |
| 模型 | `modules/02-model-governance/module.env.example` | Hugging Face Endpoint、模型與 PyPI Virtual |
| Skill | `modules/03-skill-governance/module.env.example` | Skills Repository、Skill 名稱與版本 |
| MCP | `modules/04-mcp-governance/module.env.example` | npm Local、MCP Server 與版本 |

不要把 `JFROG_ACCESS_TOKEN`、密碼或 API Key 寫入設定檔、提示詞、截圖或 Git。

## API Reference

模組 4 的 MCP Server 提供三個無副作用工具，供 Agent Guard 政策測試：

| Tool | 用途 | 預期政策 |
|---|---|---|
| `get_release_status` | 讀取模擬版本狀態 | Allow |
| `deploy_to_production` | 模擬正式環境部署 | Block |
| `delete_repository` | 模擬刪除儲存庫 | Block |

Server 使用 MCP JSON-RPC over stdio，不需要外部套件；本機測試不等於 Agent Guard 治理證明，正式 Lab 必須從 AI Catalog 核准並透過 Agent Guard 安裝。

## Project Structure

```text
.
├── .devcontainer/                  # GitHub Codespaces 環境與 JFrog 安全設定
├── .github/
│   ├── copilot-instructions.md     # Copilot 全域治理守則
│   └── prompts/                    # /module1 到 /module4
├── AGENTS.md                       # Codex 在本專案中的安全邊界
├── README.md
├── docs/                           # 講師、Demo、排錯與清理手冊
├── modules/                        # 四個可獨立執行的 Workshop 模組
├── scripts/                        # 一鍵模組執行器與完整性測試
└── templates/policy-matrix.md      # 政策與稽核矩陣
```

## Documentation

- [工作坊總覽與架構](docs/00-workshop-overview.md)
- [SaaS 申請與開課前檢查](docs/01-saas-request-checklist.md)
- [講師執行手冊](docs/02-instructor-runbook.md)
- [GitHub Codespaces 與 Copilot 學員操作](docs/03-codespaces-copilot.md)
- [獨立模組 1：Curation 與 Agent Package Resolution](modules/01-curation-package/README.md)
- [獨立模組 2：模型掃描與 Shadow AI](modules/02-model-governance/README.md)
- [獨立模組 3：Skill 掃描與管理](modules/03-skill-governance/README.md)
- [獨立模組 4：MCP 統一管理與工具政策](modules/04-mcp-governance/README.md)
- [端對端 Live Demo 腳本](docs/08-end-to-end-demo.md)
- [疑難排解](docs/09-troubleshooting.md)
- [清理與復原](docs/10-cleanup.md)
- [官方參考資料](docs/references.md)

## Running Tests

執行全部本機檢查：

```bash
./scripts/validate-workshop.sh
```

或只測試 MCP 模組：

```bash
bash modules/04-mcp-governance/validate.sh
```

本機測試會驗證檔案、JSON、Skill frontmatter、敏感資料防護與 MCP 工具行為；SaaS 的權限、Curation、Xray、Skill Scanner、Shadow AI 與 Agent Guard 必須依講師手冊在租戶中另行驗證。

## Security

- Token 只放在 GitHub Codespaces Secret；不要貼入 Copilot Chat、命令參數、檔案或截圖。
- 套件與模型只走講師指定的 Artifactory Virtual Repository，不得改用公用 Registry。
- Module 3 fixture 永遠不執行、不安裝、不解壓；Module 2 未經講師核准只做 Dry Run。
- 發佈、刪除、解除封鎖、建立豁免與變更政策均不屬於學員一鍵流程。
