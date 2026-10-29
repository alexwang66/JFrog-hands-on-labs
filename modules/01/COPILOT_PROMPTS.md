# Lab 1 Copilot 提示词

启动 `jfrog` MCP Server 后，将以下提示词粘贴到 Codespace 的 Copilot Chat。使用 **Agent** 模式，并在执行前审阅 Agent 提出的每条 Terminal 命令。

## 构建 npm 项目并解释 Curation 阻断

```text
请执行 JFrog Curation Lab 1 的 npm 项目构建。

- 不要显示或回显任何 Secret 的值。
- 不要修改 package.json、package-lock.json、JFrog 配置、npm registry 或 Curation 策略。
- 不要绕过 Artifactory，不要改用公共 npm registry，不要请求 waiver，也不要尝试其他下载地址。
- 不要直接运行、导入或执行 axios@1.14.1；只能运行 package.json 中带 --ignore-scripts 的实验构建。
- Curation 阻断后不要换源重试。

先阅读 modules/01/README.md 和 modules/01/package.json，然后在 modules/01 中依次运行：
1. npm run validate
2. npm run build

npm run build 预期以非零状态结束。请保留并分析原始错误：
- 如果是 ETARGET 或 No matching version found，说明 Compliant Version Selection 已在依赖解析阶段排除该版本。
- 如果是 E403、403 Forbidden 或 Curation policy block，说明 Curation 已在下载阶段阻断该版本。

如果构建意外成功，请立即停止，不要运行或导入 axios，并明确报告安全配置可能存在问题。

最后请用简短表格报告：请求的软件包和版本、使用的 JFrog Virtual Repository、命令退出结果、阻断阶段、策略结论，以及学员应在 JFrog Platform 的哪个 Audit Events 视图中查看证据。不要修改任何文件。
```
