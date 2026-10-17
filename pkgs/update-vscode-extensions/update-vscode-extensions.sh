die() {
  echo "$*" >&2
  exit 1
}

fetch() {
  curl --fail --silent --show-error --location --proto '=https' --tlsv1.2 --output "$2" "$1"
}

sri() {
  printf 'sha256-%s' "$(printf '%s' "${1^^}" | basenc --base16 --decode | base64 --wrap=0)"
}

version_le() {
  [[ $(printf '%s\n' "$1" "$2" | sort --version-sort | head -n 1) == "$1" ]]
}

engine_ok() {
  [[ $1 == "*" ]] && return 0
  [[ $1 =~ ^(\^|>=|~)?([0-9]+)\.([0-9]+|x)(\.([0-9]+|x))? ]] || die "$id: unsupported engine '$1'"
  local minor=${BASH_REMATCH[3]} patch=${BASH_REMATCH[5]:-0}
  version_le "${BASH_REMATCH[2]}.${minor/x/0}.${patch/x/0}" "$vscode"
}

(($# == 2)) || die "usage: update-vscode-extensions EXTENSIONS_JSON VSCODE_SOURCE_JSON"
extensions=$1
vscode=$(jq -er .version "$2")
vscode=${vscode%%-*}
default_min_age_days=${MIN_AGE_DAYS:-7}

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

count=$(jq -er length "$extensions")
for ((i = 0; i < count; i++)); do
  publisher=$(jq -er ".[$i].publisher" "$extensions")
  name=$(jq -er ".[$i].name" "$extensions")
  current=$(jq -r ".[$i].version // empty" "$extensions")
  current_arch=$(jq -r ".[$i].arch // empty" "$extensions")
  min_age_days=$(jq -r ".[$i].minAgeDays // empty" "$extensions")
  min_age_days=${min_age_days:-$default_min_age_days}
  cutoff=$(date --utc --date="-$min_age_days days" +%s)
  id="$publisher.$name"

  jq -n --arg id "$id" '{filters: [{criteria: [{filterType: 7, value: $id}]}], flags: 19}' >"$tmp/query.json"
  curl --fail --silent --show-error --proto '=https' --tlsv1.2 \
    --header 'Content-Type: application/json' \
    --header 'Accept: application/json;api-version=7.2-preview.1' \
    --data @"$tmp/query.json" \
    --output "$tmp/versions.json" \
    https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery

  best=""
  best_arch=""
  while IFS=$'\t' read -r version platform engine; do
    [[ $version =~ ^[0-9][0-9A-Za-z.+-]*$ ]] || die "$id: unexpected version '$version'"
    engine_ok "$engine" || continue
    [[ $platform == universal ]] && platform=""
    if [[ -z $best ]] || ! version_le "$version" "$best"; then
      best=$version
      best_arch=$platform
    elif [[ $version == "$best" && $platform == linux-x64 ]]; then
      best_arch=$platform
    fi
  done < <(jq -r --argjson cutoff "$cutoff" '
    .results[0].extensions[0].versions // [] | .[]
    | select((.targetPlatform // "") as $p | $p == "" or $p == "linux-x64")
    | select([.properties[]? | select(.key == "Microsoft.VisualStudio.Code.PreRelease" and .value == "true")] | length == 0)
    | select((.lastUpdated | sub("\\.[0-9]+"; "") | fromdateiso8601) <= $cutoff)
    | [.version, (.targetPlatform // "universal"), ([.properties[]? | select(.key == "Microsoft.VisualStudio.Code.Engine") | .value][0] // "*")]
    | @tsv' "$tmp/versions.json")

  [[ -n $best ]] || die "$id: no release older than $min_age_days days that supports VS Code $vscode"

  if [[ $best == "$current" && $best_arch == "$current_arch" ]]; then
    echo "$id: $current is current"
    continue
  fi
  if [[ -n $current ]] && version_le "$best" "$current"; then
    echo "$id: $current is newer than $min_age_days days or unavailable, pinning $best"
  fi

  asset="https://$publisher.gallery.vsassets.io/_apis/public/gallery/publisher/$publisher/extension/$name/$best/assetbyname"
  query=${best_arch:+?targetPlatform=$best_arch}
  fetch "$asset/Microsoft.VisualStudio.Services.VSIXPackage$query" "$tmp/extension.vsix"
  fetch "$asset/Microsoft.VisualStudio.Services.VsixSignature$query" "$tmp/extension.sigzip"
  "$VSCE_SIGN" verify --package "$tmp/extension.vsix" --signaturearchive "$tmp/extension.sigzip" >/dev/null ||
    die "$id: $best failed Marketplace signature verification"

  hash=$(sri "$(sha256sum "$tmp/extension.vsix" | cut -d ' ' -f 1)")
  jq --argjson i "$i" --arg version "$best" --arg arch "$best_arch" --arg hash "$hash" \
    '.[$i].version = $version | .[$i].arch = $arch | .[$i].hash = $hash' "$extensions" >"$tmp/extensions.json"
  mv "$tmp/extensions.json" "$extensions"
  echo "$id: ${current:-none} to $best${best_arch:+ ($best_arch)}"
done
