#!/usr/bin/env bash
set -euo pipefail

branch=update-debs

mapfile -t changed < <(git diff --name-only -- 'pkgs/*/source.json')
if ((${#changed[@]} == 0)); then
  echo "No updates"
  exit 0
fi

names=()
body=""
for file in "${changed[@]}"; do
  name=$(basename "$(dirname "$file")")
  old=$(git show "HEAD:$file" | jq -er .version)
  new=$(jq -er .version "$file")
  names+=("$name")
  body+="$name: $old to $new"$'\n'
done

if ((${#names[@]} == 1)); then
  subject="chore: update ${names[0]} to $(jq -er .version "${changed[0]}")"
else
  printf -v list '%s and ' "${names[@]}"
  subject="chore: update ${list% and }"
fi

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
