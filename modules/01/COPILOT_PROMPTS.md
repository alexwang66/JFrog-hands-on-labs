# Lab 1 Copilot 提示词

按顺序将以下提示词粘贴到 Codespace 的 Copilot Chat。使用 **Agent** 模式，并在执行前审阅 Agent 提出的每条 Terminal 命令。

## 提示词 1：检查并连接实验环境

```text
请在当前 Codespace 中检查并连接 JFrog Curation Lab 1 的实验环境。

安全规则：
- 不要显示、回显、读取或记录任何 Secret 的值。
- 只报告 JFROG_ACCESS_TOKEN、JFROG_PLATFORM_URL、JF_PROJECT 是否已设置。
- 不要修改文件、JFrog Platform 配置、npm 配置或 Curation 策略；允许完成 JFrog MCP 的一次性 OAuth 登录。
- 不要安装或下载任何 npm 依赖。
- 不要访问公共 npm registry，也不要添加 --registry、修改 registry 或绕过 Artifactory。

请依次完成：
1. 阅读 modules/01/README.md 和 modules/01/package.json。
2. 确认 Node.js 版本满足 package.json 的要求。
3. 确认 JFrog CLI 的 Server ID 为 JFROG_SERVER_ID；未设置时使用 workshop。
4. 使用 jf rt ping 检查该 Server ID 的连接。
5. 确认 JFrog Plugin 已安装并启用，且 JFrog MCP 工具可用。优先使用 JFrog MCP 做一次只读连接检查，不要用 jf CLI 代替这项 MCP 验证。
6. 如果当前只显示 enable_jfrog_tools，请调用它并引导我完成浏览器 OAuth；如果工具没有热刷新，请告诉我打开新的 Copilot Chat 后继续。
7. 确认 modules/01 的 JFrog npm 项目配置指向 ${JF_PROJECT}-npm-virtual，但不要输出任何凭证。
8. 确认依赖被精确固定为 axios@1.14.1，build 脚本通过 jf npm install 执行并包含 --ignore-scripts。

完成后只总结 Plugin、JFrog MCP、CLI、Virtual Repository 是否已就绪，以及下一步将执行哪些命令。此时不要运行 npm run build。
```

## 提示词 2：执行并解释 Curation 阻断

```text
继续执行 JFrog Curation Lab 1。保持以下安全规则：

- 不要显示或回显任何 Secret 的值。
- 不要修改 package.json、package-lock.json、JFrog 配置、npm registry 或 Curation 策略。
- 不要绕过 Artifactory，不要改用公共 npm registry，不要请求 waiver，也不要尝试其他下载地址。
- 不要直接运行、导入或执行 axios@1.14.1；只能运行 package.json 中带 --ignore-scripts 的实验构建。
- Curation 阻断后不要换源重试。

请在 modules/01 中依次运行：
1. npm run validate
2. npm run build

npm run build 预期以非零状态结束。请保留并分析原始错误：
- 如果是 ETARGET 或 No matching version found，说明 Compliant Version Selection 已在依赖解析阶段排除该版本。
- 如果是 E403、403 Forbidden 或 Curation policy block，说明 Curation 已在下载阶段阻断该版本。

如果构建意外成功，请立即停止，不要运行或导入 axios，并明确报告安全配置可能存在问题。

最后请用简短表格报告：请求的软件包和版本、使用的 JFrog Virtual Repository、命令退出结果、阻断阶段、策略结论，以及学员应在 JFrog Platform 的哪个 Audit Events 视图中查看证据。不要修改任何文件。
```
