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

(($#)) || die "usage: update-debs PACKAGE_DIR..."

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
export GNUPGHOME="$tmp/gnupg"
mkdir -m 700 "$GNUPGHOME"

for dir in "$@"; do
  name=$(basename "$dir")
  source="$dir/source.json"
  work="$tmp/$name"
  mkdir "$work"

  repo=$(jq -er .repo "$source")
  suite=$(jq -er .suite "$source")
  component=$(jq -er .component "$source")
  package=$(jq -er .package "$source")
  current=$(jq -er .version "$source")
  current_hash=$(jq -er .hash "$source")

  gpg --batch --quiet --dearmor --output "$work/keyring.gpg" "$dir/key.asc"
  fetch "$repo/dists/$suite/InRelease" "$work/InRelease"
  gpgv --quiet --keyring "$work/keyring.gpg" --output "$work/Release" "$work/InRelease" ||
    die "$name: InRelease signature check failed"

  index="$component/binary-amd64/Packages"
  index_sha256=$(awk -v f="$index" '/^SHA256:/ { s = 1; next } /^[^ ]/ { s = 0 } s && $3 == f { print $1 }' "$work/Release")
  [[ $index_sha256 =~ ^[0-9a-f]{64}$ ]] || die "$name: $index not listed in the signed Release"
  fetch "$repo/dists/$suite/$index" "$work/Packages"
  echo "$index_sha256  $work/Packages" | sha256sum --check --quiet --strict ||
    die "$name: $index does not match the signed Release"

  latest=$(awk -v p="$package" '
    BEGIN { RS = ""; FS = "\n" }
    {
      delete f
      for (i = 1; i <= NF; i++)
        if (match($i, /^[A-Za-z0-9-]+: /))
          f[substr($i, 1, RLENGTH - 2)] = substr($i, RLENGTH + 1)
      if (f["Package"] == p && f["Architecture"] == "amd64")
        print f["Version"], f["Filename"], f["SHA256"]
    }' "$work/Packages" | sort --version-sort --key=1,1 | tail -n 1)
  [[ -n $latest ]] || die "$name: $package not found in $index"
  read -r version filename sha256 <<<"$latest"

  [[ $version =~ ^[0-9][0-9A-Za-z.+~-]*$ ]] || die "$name: unexpected version '$version'"
  [[ $filename =~ ^pool/[A-Za-z0-9._+/-]+\.deb$ && $filename != *..* ]] ||
    die "$name: unexpected filename '$filename'"
  [[ $sha256 =~ ^[0-9a-f]{64}$ ]] || die "$name: unexpected SHA256 '$sha256'"
  hash=$(sri "$sha256")

  if [[ $version == "$current" ]]; then
    [[ $hash == "$current_hash" ]] || die "$name: $version was republished with a different hash"
    echo "$name: $current is current"
    continue
  fi
  [[ $(printf '%s\n' "$current" "$version" | sort --version-sort | tail -n 1) == "$version" ]] ||
    die "$name: repo offers $version, older than the pinned $current"

  jq --arg version "$version" --arg url "$repo/$filename" --arg hash "$hash" \
    '.version = $version | .url = $url | .hash = $hash' "$source" >"$work/source.json"
  mv "$work/source.json" "$source"
  echo "$name: $current to $version"
done
