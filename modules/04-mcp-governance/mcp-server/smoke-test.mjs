import assert from "node:assert/strict";
import { spawn } from "node:child_process";
import readline from "node:readline";

const child = spawn(process.execPath, [new URL("./server.mjs", import.meta.url).pathname], {
  stdio: ["pipe", "pipe", "inherit"]
});
const output = readline.createInterface({ input: child.stdout, crlfDelay: Infinity });
const pending = new Map();
output.on("line", (line) => {
  const message = JSON.parse(line);
  pending.get(message.id)?.(message);
  pending.delete(message.id);
});

let id = 0;
function request(method, params = {}) {
  const requestId = ++id;
  return new Promise((resolve, reject) => {
    const timer = setTimeout(() => reject(new Error(`Timed out: ${method}`)), 3000);
    pending.set(requestId, (message) => {
      clearTimeout(timer);
      resolve(message);
    });
    child.stdin.write(`${JSON.stringify({ jsonrpc: "2.0", id: requestId, method, params })}\n`);
  });
}

try {
  assert.equal((await request("initialize")).result.serverInfo.name, "governed-ops-mcp");
  assert.equal((await request("tools/list")).result.tools.length, 3);
  const safe = await request("tools/call", {
    name: "get_release_status",
    arguments: { release: "2026.10-demo" }
  });
  assert.match(safe.result.content[0].text, /ready for review/);
  const denied = await request("tools/call", {
    name: "deploy_to_production",
    arguments: { release: "2026.10-demo" }
  });
  assert.equal(denied.result.isError, true);
  console.log("Module 04 MCP smoke test: PASS");
} finally {
  child.kill();
}
