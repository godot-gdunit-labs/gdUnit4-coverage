#!/usr/bin/env bash
set -euo pipefail

# Only gdUnit4-coverage shaped identifiers are considered, so names from the reporter's own
# project can never trip the substantiation check.
grep -oE '\b(CoverageApi|GdUnit4Coverage[A-Za-z0-9_]*|GdUnitCoverage[A-Za-z0-9_]*|is_available|is_enabled|is_armed|is_coverage_runner|get_version|get_summary|get_script_coverage|get_include_filters|get_exclude_filters|register_script|record_line|set_include_filters|set_exclude_filters|export_lcov|export_lcov_merged|load_lcov|hook_startup|hook_shutdown)\b' \
  triage/body.md | sort -u > triage/symbols.txt || true

: > triage/known.txt
: > triage/unknown.txt
while read -r name; do
  if [ -z "$name" ]; then
    continue
  fi
  # Declared in the plugin, carried by a source file name, documented, or declared by
  # the reporter's own snippet.
  if grep -rqE "(class_name|func|class)[[:space:]]+${name}\b" addons/gdunit4_coverage \
    || [ -n "$(find addons/gdunit4_coverage -type f -name "${name}.gd" -print -quit)" ] \
    || grep -rqw -- "$name" docs \
    || grep -qE "(class_name|extends|func|class)[[:space:]]+${name}\b" triage/body.md; then
    echo "$name" >> triage/known.txt
  else
    echo "$name" >> triage/unknown.txt
  fi
done < triage/symbols.txt
