# Lab 1：使用 JFrog Curation 阻断恶意 npm 包

本实验通过 Codespaces 中的 Copilot 构建 npm 项目，验证 JFrog Curation 阻断恶意版本 `axios@1.14.1`。

## Quick Start

1. 等待 Codespace 显示 `Setup completed`。旧 Codespace 先运行 **Codespaces: Rebuild Container**。
2. 运行 **MCP: List Servers**，选择 `jfrog`，然后选择 **Start Server**。
3. 首次启动时，接受信任提示并在浏览器中完成 JFrog OAuth。
4. 打开 **Copilot Chat**，选择 **Agent** 模式并提交下方输入。
5. 审阅 Copilot 提出的命令。`npm run build` 失败是预期结果。

### Copilot 输入

```text
请执行 JFrog Curation Lab 1：

1. 在 modules/01 运行 npm run validate。
2. 在 modules/01 运行 npm run build。

要求：
- 不要显示任何 Secret，也不要修改文件、JFrog 配置、npm registry 或 Curation 策略。
- 不要绕过 Artifactory、换源或请求 waiver。
- 只能运行 package.json 中带 --ignore-scripts 的构建；不要运行或导入 axios。
- npm run build 失败是预期结果，请保留并解释原始错误。
- 如果构建成功，立即停止并报告安全配置异常。

最后用表格输出：Package、Repository、Build result、Block stage、Conclusion。
```

### 预期输出

| 字段 | 预期值 |
|---|---|
| Package | `axios@1.14.1` |
| Repository | `${JF_PROJECT}-npm-virtual` |
| Build result | `Failed (expected)` |
| Block stage | `CVS / dependency resolution` 或 `Download` |
| Conclusion | `Blocked by JFrog Curation` |

Copilot 应根据原始错误说明阻断阶段：

- `ETARGET` 或 `No matching version found`：Curation 在依赖解析阶段过滤了该版本。
- `E403`、`403 Forbidden` 或 Curation block：Curation 在下载阶段阻断了该版本。

在 JFrog Platform 的 **Application → Curation → Audit Events** 中查看证据。解析阶段阻断选择 **CVS**；下载阶段阻断选择 **Downloads → Blocked**。

## Configuration

| Codespaces Secret / 环境变量 | 必填 | 值 |
|---|---:|---|
| `JFROG_ACCESS_TOKEN` | 是 | JFrog Access Token |
| `JFROG_PLATFORM_URL` | 是 | 纯主机名，例如 `acme.jfrog.io`；不要包含 `https://` 或路径 |
| `JF_PROJECT` | 是 | JFrog Project Key |
| `JFROG_SERVER_ID` | 否 | 默认值 `workshop` |

Codespace 自动安装并启用 JFrog Plugin、配置 JFrog CLI，并将 npm 解析绑定到 `${JF_PROJECT}-npm-virtual`。学员只需启动 `jfrog` MCP Server，然后提交 Copilot 输入。

## API Reference

本实验不提供应用 API。构建脚本通过 `jf npm install --ignore-scripts` 请求依赖。

## Project Structure

```text
modules/01/
├── README.md                 # 学员步骤、Copilot 输入和预期输出
├── COPILOT_PROMPTS.md        # 可单独复制的 Copilot 输入
├── package.json              # 固定 axios@1.14.1 并定义实验构建
└── scripts/
    └── validate-lab.mjs      # 不下载依赖的静态检查
```

## Documentation

- [JFrog Plugin for VS Code](https://github.com/jfrog/vscode-plugin)
- [JFrog Curation 行为](https://docs.jfrog.com/security/docs/behavior-by-package)

## Running Tests

运行不下载依赖的静态检查：

```bash
cd modules/01
npm run validate
```

`npm run build` 是预期失败的 Curation 实验，不属于成功路径测试。
