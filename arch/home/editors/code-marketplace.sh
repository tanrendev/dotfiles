#!/bin/sh
set -eu

product=/usr/lib/code/product.json
shared=/usr/lib/code/out/vs/code/electron-utility/sharedProcess/sharedProcessMain.js

jq '.extensionsGallery = {
  nlsBaseUrl: "https://www.vscode-unpkg.net/_lp/",
  serviceUrl: "https://marketplace.visualstudio.com/_apis/public/gallery",
  itemUrl: "https://marketplace.visualstudio.com/items",
  publisherUrl: "https://marketplace.visualstudio.com/publishers",
  resourceUrlTemplate: "https://{publisher}.vscode-unpkg.net/{publisher}/{name}/{version}/{path}",
  extensionUrlTemplate: "https://www.vscode-unpkg.net/_gallery/{publisher}/{name}/latest",
  controlUrl: "https://main.vscode-cdn.net/extensions/marketplace.json",
  mcpUrl: "https://main.vscode-cdn.net/mcp/servers.json"
}' "$product" > "$product.new"
mv "$product.new" "$product"

sed -i 's|import("node-ovsx-sign")|import("@vscode/vsce-sign")|' "$shared"
