# Lab 1 Copilot 输入与预期输出

启动 `jfrog` MCP Server 后，将以下内容粘贴到 Codespace 的 Copilot Chat，并选择 **Agent** 模式。

## Copilot 输入

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

## 预期输出

| 字段 | 预期值 |
|---|---|
| Package | `axios@1.14.1` |
| Repository | `${JF_PROJECT}-npm-virtual` |
| Build result | `Failed (expected)` |
| Block stage | `CVS / dependency resolution` 或 `Download` |
| Conclusion | `Blocked by JFrog Curation` |

可能出现的原始错误：

- `ETARGET` 或 `No matching version found`：依赖解析阶段阻断。
- `E403`、`403 Forbidden` 或 Curation block：下载阶段阻断。

如果构建成功，不要运行或导入 `axios`，立即停止并报告安全配置异常。
