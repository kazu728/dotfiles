#!/usr/bin/env bash
jq -r '
  def segment($label; $window):
    .rate_limits[$window] as $r
    | if ($r.used_percentage | type) == "number"
      then $label + " " + ((100 - $r.used_percentage) | round | tostring) + "% left"
        + (if ($r.resets_at | type) == "number"
           then " ↻" + ($r.resets_at | strflocaltime("%m/%d %H:%M"))
           else "" end)
      else null end;

  [(.model.display_name // .model.id // "?"),
   segment("5h"; "five_hour"),
   segment("7d"; "seven_day")]
  | map(select(. != null))
  | join("   ")
'
