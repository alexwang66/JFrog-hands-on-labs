#!/usr/bin/env node

import readline from "node:readline";

const tools = [
  {
    name: "get_release_status",
    description: "Return a simulated, read-only release status.",
    inputSchema: { type: "object", properties: { release: { type: "string" } }, required: ["release"] }
  },
  {
    name: "deploy_to_production",
    description: "Training-only deployment tool. The server always refuses it.",
    inputSchema: { type: "object", properties: { release: { type: "string" } }, required: ["release"] }
  },
  {
    name: "delete_repository",
    description: "Training-only destructive tool. The server always refuses it.",
    inputSchema: { type: "object", properties: { repository: { type: "string" } }, required: ["repository"] }
  }
];

const ok = (id, result) => ({ jsonrpc: "2.0", id, result });
const fail = (id, code, message) => ({ jsonrpc: "2.0", id, error: { code, message } });

function handle(message) {
  const { id, method, params = {} } = message;
  if (method === "initialize") {
    return ok(id, {
      protocolVersion: "2024-11-05",
      capabilities: { tools: {} },
      serverInfo: { name: "governed-ops-mcp", version: "1.0.0" }
    });
  }
  if (method === "notifications/initialized") return null;
  if (method === "ping") return ok(id, {});
  if (method === "tools/list") return ok(id, { tools });
  if (method === "tools/call") {
    const name = params.name;
    const args = params.arguments ?? {};
    if (name === "get_release_status") {
      return ok(id, { content: [{ type: "text", text: `Release ${args.release ?? "unknown"} is ready for review.` }] });
    }
    if (name === "deploy_to_production" || name === "delete_repository") {
      return ok(id, {
        isError: true,
        content: [{ type: "text", text: "Denied by the demo server's defense-in-depth policy." }]
      });
    }
    return fail(id, -32601, `Unknown tool: ${name}`);
  }
  return id === undefined ? null : fail(id, -32601, `Unknown method: ${method}`);
}

const input = readline.createInterface({ input: process.stdin, crlfDelay: Infinity });
input.on("line", (line) => {
  if (!line.trim()) return;
  let response;
  try {
    response = handle(JSON.parse(line));
  } catch (cause) {
    response = fail(null, -32700, `Parse error: ${cause.message}`);
  }
  if (response) process.stdout.write(`${JSON.stringify(response)}\n`);
});
