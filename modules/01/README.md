# Lab 1：使用 JFrog Curation 阻断恶意 npm 包

本实验由学员在 GitHub Codespaces 的 Copilot Chat 中驱动。Copilot Agent 通过 JFrog Artifactory npm Virtual Repository 请求 `axios@1.14.1`，并解释 JFrog Curation 如何在恶意包进入开发环境之前将其阻断。

## Quick Start

1. 使用已配置三个 Codespaces Secret 的仓库创建或重建 Codespace，等待 `postCreateCommand` 显示 `Setup completed`。如果 Codespace 创建于本次配置更新之前，请先运行 **Codespaces: Rebuild Container**；仅重新启动旧容器不会补跑历史的 `postCreateCommand`。
2. 在 VS Code 中打开 **Copilot Chat**，从聊天面板底部的模式选择器中选择 **Agent**。
3. 打开 [`COPILOT_PROMPTS.md`](COPILOT_PROMPTS.md)，将“提示词 1”完整粘贴到 Copilot Chat。
4. 审阅 Copilot 提出的检查命令并确认执行。Copilot 不应显示任何 Secret 的值，也不应安装 npm 依赖。
5. JFrog MCP 第一次使用时会打开浏览器执行一次 OAuth。完成授权；如果工具没有自动刷新，请打开新的 Copilot Chat，再在同一 Lab 上下文中继续。
6. Copilot 确认 Plugin、JFrog MCP、CLI 和 npm Virtual Repository 均已就绪后，将“提示词 2”粘贴到聊天。
7. 审阅 Copilot 提出的命令，只允许它在 `modules/01` 中运行静态检查和实验构建。构建失败是预期结果。

Copilot 执行的 `npm run build` 会通过 `jf npm install` 从 `${JF_PROJECT}-npm-virtual` 请求精确版本 `axios@1.14.1`。构建脚本包含 `--ignore-scripts`，即使仓库策略配置错误，也不会运行依赖包的生命周期脚本。

## Configuration

| Codespaces Secret / 环境变量 | 必填 | 格式或默认值 | 用途 |
|---|---:|---|---|
| `JFROG_ACCESS_TOKEN` | 是 | Secret | 配置 JFrog CLI 和 Agent Guard；不要打印或提交该值。 |
| `JFROG_PLATFORM_URL` | 是 | 仅主机名，例如 `acme.jfrog.io` | JFrog Plugin 将其解析为 `https://<host>/mcp`；不要包含 `https://` 或路径。 |
| `JF_PROJECT` | 是 | JFrog Project Key | 生成 `${JF_PROJECT}-npm-virtual`，并为 Agent Guard 提供项目上下文。 |
| `JFROG_SERVER_ID` | 否 | `workshop` | JFrog CLI Server ID。 |

## 自动启动配置

Codespace 的 `postCreateCommand` 会运行 [`.devcontainer/setup-jfrog-plugin.sh`](../../.devcontainer/setup-jfrog-plugin.sh)，并自动完成：

1. 检查 Node.js 和三个 Codespaces Secret，但不输出 Secret 内容。
2. 安装并配置 JFrog CLI，连接到 `https://${JFROG_PLATFORM_URL}`。
3. 添加 JFrog Plugin Marketplace，安装并启用 `jfrog@jfrog-agent-plugins`。
4. 由 Plugin 自动附加其自带的 `jfrog` 远程 MCP，地址为 `https://${JFROG_PLATFORM_URL}/mcp`。
5. 为 Agent Package Resolution 写入 `${JF_PROJECT}-npm-virtual` 绑定。
6. 为 `modules/01` 写入 `jf npm` 项目配置。

JFrog MCP 使用 OAuth，不使用 `JFROG_ACCESS_TOKEN` 直接登录 MCP。安装和地址配置会自动完成，但每位学员第一次使用 MCP 时仍需在浏览器完成一次授权。

此外，`postStartCommand` 会在每次 Codespace 启动时以 `--plugin-only` 模式重新检查 Plugin；该模式是幂等的，不会重新配置 JFrog CLI 或 npm。如果 Plugin 未安装或未启用，它会自动修复并验证最终状态。

## 预期结果

构建必须以非零状态结束，并且 `axios@1.14.1` 不应成功安装。根据 Curation 的处理阶段，npm 可能显示：

- `ETARGET` 或 `No matching version found`：Compliant Version Selection 已从 npm 元数据中移除被阻断版本。
- `E403`、`403 Forbidden` 或明确的 Curation policy block：版本已解析，但下载被 Curation 阻断。

在 JFrog Platform 中打开 **Application → Curation → Audit Events**：

- 如果 npm 显示 `ETARGET`，将 **Inspection** 切换为 **CVS**。
- 如果 npm 显示 `E403/403`，将 **Inspection** 切换为 **Downloads**，再打开 **Blocked**。

确认事件包含：

| 字段 | 预期值 |
|---|---|
| Package | `axios` |
| Version | `1.14.1` |
| Policy | `Block Malicious Packages` |
| Condition | `Malicious package` |
| Action | `Blocked` |

如果安装成功，请停止实验，不要运行或导入该依赖。删除 `node_modules` 和 `package-lock.json`，然后由讲师检查 Virtual Repository 与 Curation 策略。

## API Reference

本实验不提供应用 API。学员通过 Copilot Chat Agent 发起操作；Agent 使用 JFrog MCP 做平台只读检查，并在 Codespace Terminal 中调用 `jf npm install` 完成 Curation 实验。

## Project Structure

```text
modules/01/
├── README.md                 # 自动启动配置、Copilot 流程和预期阻断结果
├── COPILOT_PROMPTS.md        # 学员依次粘贴到 Copilot Chat 的两轮提示词
├── package.json              # 固定 axios@1.14.1，并定义安全的实验构建命令
└── scripts/
    └── validate-lab.mjs      # 不下载依赖的静态配置检查
```

## Documentation

- [GitHub Codespaces Secrets](https://docs.github.com/en/codespaces/managing-your-codespaces/managing-your-account-specific-secrets-for-github-codespaces)
- [JFrog Plugin for VS Code](https://github.com/jfrog/vscode-plugin)
- [JFrog：使用 MCP Registry 与 Agent Guard](https://docs.jfrog.com/ai-ml/docs/configure-coding-agents)
- [JFrog：各软件包管理器的 Curation 行为](https://docs.jfrog.com/security/docs/behavior-by-package)

## Running Tests

本节供讲师或维护者验证 Lab 文件；学员实验流程全部通过 Copilot Chat 完成。运行不会访问 npm registry 的静态检查：

```bash
cd modules/01
npm run validate
```

`npm run build` 是预期失败的安全策略实验，不属于成功路径测试。
