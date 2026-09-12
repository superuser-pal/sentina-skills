#!/usr/bin/env node
// Copies package.json's version into .claude-plugin/plugin.json and .codex-plugin/plugin.json.

import { readFileSync, writeFileSync, existsSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const repo = join(dirname(fileURLToPath(import.meta.url)), "..");
const claudePluginPath = join(repo, ".claude-plugin", "plugin.json");
const codexPluginPath = join(repo, ".codex-plugin", "plugin.json");

const { version } = JSON.parse(readFileSync(join(repo, "package.json"), "utf8"));

for (const pluginPath of [claudePluginPath, codexPluginPath]) {
  if (!existsSync(pluginPath)) continue;
  const source = readFileSync(pluginPath, "utf8");
  const plugin = JSON.parse(source);

  if (plugin.version === version) {
    console.log(`${pluginPath} version is ${version} (already in sync)`);
    continue;
  }

  if (process.argv.includes("--check")) {
    console.error(
      `${pluginPath} version is ${plugin.version}, package.json is ${version}. Run \`node scripts/sync-plugin-version.mjs\`.`,
    );
    process.exit(1);
  }

  const updated = source.replace(
    /("version"\s*:\s*")[^"]*(")/,
    `$1${version}$2`,
  );

  writeFileSync(pluginPath, updated);
  console.log(`${pluginPath} version ${plugin.version} -> ${version}`);
}
