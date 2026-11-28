#!/usr/bin/env bash
jq -r '
  def fmt_seconds:
    ([. | floor, 0] | max) as $s
    | ($s / 86400 | floor) as $d
    | ($s % 86400 / 3600 | floor) as $h
    | ($s % 3600 / 60 | floor) as $m
    | if $d > 0 then "\($d)d\($h)h"
      elif $h > 0 then "\($h)h\($m)m"
      else "\($m)m" end;

  def reset_str($q):
    if ($q.reset_in_seconds | type) == "number" then
      " " + ($q.reset_in_seconds | fmt_seconds)
    elif ($q.reset_time | type) == "string" then
      (try (($q.reset_time | sub("\\.[0-9]+Z$"; "Z") | fromdateiso8601) - now) catch null) as $diff
      | if $diff != null then " " + ($diff | fmt_seconds) else "" end
    else
      ""
    end;

  def fmt_bucket($label; $q):
    if ($q | type) != "object" or $q.disabled == true then
      null
    elif ($q.remaining_fraction | type) == "number" then
      $label + " " + (($q.remaining_fraction * 100) | round | tostring) + "%" + reset_str($q)
    elif ($q.remaining_amount | type) == "number" then
      $label + " " + ($q.remaining_amount | tostring) + reset_str($q)
    else
      null
    end;

  def model_prefix:
    if ((.model.id // .model.display_name // "") | ascii_downcase | test("gemini"))
    then "gemini"
    else "3p"
    end;

  def primary_segments:
    model_prefix as $p
    | [
        fmt_bucket("5h"; .quota["\($p)-5h"]),
        fmt_bucket("7d"; .quota["\($p)-weekly"])
      ]
    | map(select(. != null));

  def fallback_segments:
    (.quota // {})
    | to_entries
    | map(fmt_bucket(.key; .value))
    | map(select(. != null));

  (primary_segments | if length > 0 then . else null end) as $primary
  | ($primary // fallback_segments) as $quotas
  | [(.model.display_name // .model.id // "?")] + $quotas
  | join("   ")
'
