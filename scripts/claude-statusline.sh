#!/usr/bin/env bash
# `rate_limits` is present only on Pro/Max plans, and only after the session's
# first API response; until then each window shows "--".

input=$(cat)
[ -n "$input" ] || input='{}'

printf '%s' "$input" | jq -r '
  def clamp: if . < 0 then 0 else . end;
  def hm: floor as $s | "\(($s/3600)|floor)h\((($s%3600)/60)|floor)m";
  def dh: floor as $s | "\(($s/86400)|floor)d\((($s%86400)/3600)|floor)h";
  def model:
    [ .model.display_name?, .model.id? ]
    | map(select(type == "string" and . != ""))
    | .[0] // "?";
  def pct($r):
    if ($r.used_percentage | type) == "number"
    then ((100 - $r.used_percentage) | round | tostring) + "%" else "--" end;
  def rem($r; fmt):
    if ($r.resets_at | type) == "number"
    then "↻" + (($r.resets_at - now) | clamp | fmt) else "--" end;
  def seg(lab; w; fmt):
    (.rate_limits | if type == "object" then .[w] else null end) as $r
    | lab + " " + pct($r) + " " + rem($r; fmt);
  model + "   " + seg("5h"; "five_hour"; hm) + "   " + seg("7d"; "seven_day"; dh)
' 2>/dev/null || printf '?   5h -- --   7d -- --'
