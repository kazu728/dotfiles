#!/usr/bin/env bash
jq -r '
  def until_reset:
    ([. - now | floor, 0] | max) as $s
    | ($s / 86400 | floor) as $d
    | ($s % 86400 / 3600 | floor) as $h
    | ($s % 3600 / 60 | floor) as $m
    | if $d > 0 then "\($d)d\($h)h"
      elif $h > 0 then "\($h)h\($m)m"
      else "\($m)m" end;

  def segment($label; $window):
    .rate_limits[$window] as $r
    | if ($r.used_percentage | type) == "number"
      then $label + " " + ((100 - $r.used_percentage) | round | tostring) + "%"
        + (if ($r.resets_at | type) == "number"
           then " " +($r.resets_at | until_reset)
           else "" end)
      else null end;

  [(.model.display_name // .model.id // "?"),
   segment("5h"; "five_hour"),
   segment("7d"; "seven_day")]
  | map(select(. != null))
  | join("   ")
'
