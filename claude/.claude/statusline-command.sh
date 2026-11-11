#!/bin/bash
# Claude Code status line, mirrors the starship prompt: user, dir, git branch/status
input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input" | jq -r '.model.display_name')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
five=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
cache_exp=$(echo "$input" | jq -r 'if .prompt_cache.warm then .prompt_cache.expires_at else empty end')

user=$(whoami)
dir="$cwd"
root=$(git -C "$cwd" --no-optional-locks rev-parse --show-toplevel 2>/dev/null)
if [ -n "$root" ]; then
  dir="$(basename "$root")${cwd#"$root"}"
else
  dir="${cwd/#$HOME/~}"
fi

# starship truncation_length = 4: keep last 4 path components
dir=$(echo "$dir" | awk -F/ '{ if (NF>4) { s=$(NF-3); for(i=NF-2;i<=NF;i++) s=s"/"$i; print s } else print }')
ustyle='\033[1;33m'; [ "$(id -u)" = 0 ] && ustyle='\033[1;31m'
out=$(printf "${ustyle}%s\033[0m %s" "$user" "$(printf '\033[1;36m%s\033[0m' "$dir")")

if [ -n "$root" ]; then
  branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)
  [ -z "$branch" ] && branch=$(git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
  st=$(git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null)
  conflicted=$(echo "$st" | grep -cE '^(DD|AU|UD|UA|DU|AA|UU)')
  staged=$(echo "$st" | grep -cE '^[MARC]')
  modified=$(echo "$st" | grep -cE '^.[MT]')
  deleted=$(echo "$st" | grep -cE '^(D.|.D)')
  untracked=$(echo "$st" | grep -c '^??')
  stashed=$(git -C "$cwd" --no-optional-locks stash list 2>/dev/null | wc -l | tr -d ' ')
  read -r ahead behind < <(git -C "$cwd" --no-optional-locks rev-list --left-right --count '@{upstream}...HEAD' 2>/dev/null | awk '{print $2, $1}')
  ahead=${ahead:-0}; behind=${behind:-0}
  # Nerd Font glyphs as UTF-8 byte escapes (macOS bash 3.2 printf has no \u); same as starship.toml
  out="$out on $(printf '\033[1;35m\xee\x82\xa0 %s\033[0m' "$branch")"
  if [ "$ahead" -gt 0 ] && [ "$behind" -gt 0 ]; then
    out="$out $(printf '\033[1;36m\xef\x81\xa2%s \xef\x81\xa3%s\033[0m' "$ahead" "$behind")"
  elif [ "$ahead" -gt 0 ]; then
    out="$out $(printf '\033[1;36m\xef\x81\xa2 %s\033[0m' "$ahead")"
  elif [ "$behind" -gt 0 ]; then
    out="$out $(printf '\033[1;36m\xef\x81\xa3 %s\033[0m' "$behind")"
  fi
  [ "$staged" -gt 0 ] && out="$out $(printf '\033[1;32m\xef\x81\xa7 %s\033[0m' "$staged")"
  [ "$modified" -gt 0 ] && out="$out $(printf '\033[1;33m\xef\x81\xa9 %s\033[0m' "$modified")"
  [ "$untracked" -gt 0 ] && out="$out $(printf '\033[1;37m\xef\x85\x81 %s\033[0m' "$untracked")"
  [ "$deleted" -gt 0 ] && out="$out $(printf '\033[1;31m\xef\x87\xb8 %s\033[0m' "$deleted")"
  [ "$conflicted" -gt 0 ] && out="$out $(printf '\033[1;31m\xef\x81\xb1 %s\033[0m' "$conflicted")"
  [ "$stashed" -gt 0 ] && out="$out $(printf '\033[1;33m\xef\x86\x87 %s\033[0m' "$stashed")"
fi

out="$out | $model"
[ -n "$used" ] && out="$out | ctx $(printf '%.0f' "$used")%"
[ -n "$five" ] && out="$out | 5h $(printf '%.0f' "$five")% · 7d $(printf '%.0f' "${week:-0}")%"
# clock time, not a countdown: the bar only redraws on activity, so a countdown would go stale while idle
if [ -n "$cache_exp" ] && [ "$cache_exp" -gt "$(date +%s)" ]; then
  out="$out | cache till $(date -r "$cache_exp" +%H:%M 2>/dev/null || date -d "@$cache_exp" +%H:%M)"
elif echo "$input" | jq -e '.prompt_cache' >/dev/null; then
  out="$out | cache cold"
fi
printf '%s\n' "$out"
