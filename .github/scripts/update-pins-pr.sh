#!/usr/bin/env bash
set -euo pipefail

branch=update-pins

claude_code_version() {
  local ref
  ref=$(jq -er '.nodes["claude-code"].locked | "github:\(.owner)/\(.repo)/\(.rev)"')
  nix eval --raw "$ref#packages.x86_64-linux.default.version"
}

mapfile -t changed < <(git diff --name-only -- 'pkgs/*/source.json' home/editors/extensions.json flake.lock)
if ((${#changed[@]} == 0)); then
  echo "No updates"
  exit 0
fi

names=()
body=""
for file in "${changed[@]}"; do
  case $file in
    pkgs/*/source.json)
      name=$(basename "$(dirname "$file")")
      names+=("$name")
      body+="$name: $(git show "HEAD:$file" | jq -er .version) to $(jq -er .version "$file")"$'\n'
      ;;
    home/editors/extensions.json)
      names+=("vscode extensions")
      body+=$(jq -nr --slurpfile old <(git show "HEAD:$file") --slurpfile new "$file" '
        ($old[0] | map({key: "\(.publisher).\(.name)", value: .version}) | from_entries) as $before
        | $new[0][]
        | "\(.publisher).\(.name)" as $id
        | select($before[$id] != .version)
        | "\($id): \($before[$id] // "new") to \(.version)"')$'\n'
      ;;
    flake.lock)
      names+=("claude-code")
      body+="claude-code: $(git show "HEAD:$file" | claude_code_version) to $(claude_code_version <"$file")"$'\n'
      ;;
  esac
done

if ((${#names[@]} == 1)); then
  subject="chore: update ${names[0]}"
else
  printf -v list '%s, ' "${names[@]:0:${#names[@]}-1}"
  subject="chore: update ${list%, } and ${names[-1]}"
fi
((${#subject} <= 60)) || subject="chore: update pinned packages"

gh auth setup-git

if git fetch --quiet --depth=1 origin "+refs/heads/$branch:refs/remotes/origin/$branch" 2>/dev/null &&
  git diff --quiet "origin/$branch" -- "${changed[@]}"; then
  echo "$branch already carries these updates"
  exit 0
fi

git switch --quiet --force-create "$branch"
git add -- "${changed[@]}"
git -c user.name="github-actions[bot]" \
  -c user.email="41898282+github-actions[bot]@users.noreply.github.com" \
  commit --quiet --message "$subject"
git push --quiet --force origin "$branch"

if [[ $(gh pr list --head "$branch" --state open --json number --jq length) != 0 ]]; then
  gh pr edit "$branch" --title "$subject" --body "$body"
else
  gh pr create --head "$branch" --title "$subject" --body "$body" --label dependencies
fi
