import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";

const packageJsonUrl = new URL("../package.json", import.meta.url);
const promptsUrl = new URL("../COPILOT_PROMPTS.md", import.meta.url);
const readmeUrl = new URL("../README.md", import.meta.url);
const devcontainerUrl = new URL("../../../.devcontainer/devcontainer.json", import.meta.url);
const setupScriptUrl = new URL("../../../.devcontainer/setup-jfrog-plugin.sh", import.meta.url);
const packageJson = JSON.parse(await readFile(packageJsonUrl, "utf8"));
const prompts = await readFile(promptsUrl, "utf8");
const readme = await readFile(readmeUrl, "utf8");
const devcontainer = JSON.parse(await readFile(devcontainerUrl, "utf8"));
const setupScript = await readFile(setupScriptUrl, "utf8");

assert.equal(
  packageJson.dependencies?.axios,
  "1.14.1",
  "axios 必须精确固定到恶意测试版本 1.14.1。",
);
assert.match(
  packageJson.scripts?.build ?? "",
  /\bjf npm install\b/,
  "build 脚本必须通过 JFrog CLI 执行 npm install。",
);
assert.match(
  packageJson.scripts?.build ?? "",
  /--ignore-scripts\b/,
  "build 脚本必须禁止执行依赖包的生命周期脚本。",
);
assert.match(prompts, /npm run validate/, "Copilot 提示词必须先运行静态检查。");
assert.match(prompts, /npm run build/, "Copilot 提示词必须通过 Copilot 启动实验构建。");
assert.match(prompts, /不要显示或回显任何 Secret/, "Copilot 提示词必须保护 Secret。");
assert.match(prompts, /不要绕过 Artifactory/, "Copilot 提示词必须禁止绕过 Artifactory。");
assert.match(prompts, /--ignore-scripts/, "Copilot 提示词必须限制恶意依赖脚本执行。");
assert.match(readme, /MCP: List Servers/, "README 必须提示学员打开 MCP Server 列表。");
assert.match(readme, /Start Server/, "README 必须提示学员启动 jfrog MCP Server。");
for (const secretName of ["JFROG_ACCESS_TOKEN", "JFROG_PLATFORM_URL", "JF_PROJECT"]) {
  assert.ok(devcontainer.secrets?.[secretName], `devcontainer 必须声明 ${secretName} Secret。`);
}
assert.equal(
  devcontainer.remoteEnv?.JFROG_PLATFORM_URL,
  "$JFROG_PLATFORM_URL",
  "devcontainer 必须将 JFROG_PLATFORM_URL 传给 VS Code 远程环境。",
);
assert.equal(
  devcontainer.remoteEnv?.JF_PROJECT,
  "$JF_PROJECT",
  "devcontainer 必须将 JF_PROJECT 传给 VS Code 远程环境。",
);
assert.match(
  devcontainer.postStartCommand ?? "",
  /setup-jfrog-plugin\.sh --plugin-only/,
  "Codespace 每次启动时都必须验证 JFrog Plugin。",
);
assert.deepEqual(
  devcontainer.customizations?.codespaces?.openFiles,
  ["modules/01/README.md"],
  "Codespace 启动后必须自动打开 Lab 1 README。",
);
assert.match(setupScript, /copilot plugin install jfrog@jfrog-agent-plugins/, "启动脚本必须安装 JFrog Plugin。");
assert.match(setupScript, /copilot plugin enable jfrog/, "启动脚本必须启用 JFrog Plugin。");
assert.ok(
  setupScript.indexOf("copilot plugin install jfrog@jfrog-agent-plugins") <
    setupScript.indexOf('if [ -z "${JFROG_ACCESS_TOKEN:-}" ]'),
  "Plugin 安装必须先于 Secret 校验，避免配置错误阻止 Plugin 安装。",
);
assert.match(setupScript, /JFROG_CLI_URL="https:\/\//, "启动脚本必须为 JFrog CLI 构造 HTTPS URL。");
assert.match(setupScript, /插件自带的 JFrog MCP 已配置/, "启动脚本必须报告 JFrog MCP 配置完成。");
assert.match(setupScript, /MCP: List Servers/, "启动脚本必须提示学员启动 jfrog MCP Server。");

console.log("Lab 1 静态检查通过：Copilot 将通过 JFrog npm 构建请求 axios@1.14.1。");
