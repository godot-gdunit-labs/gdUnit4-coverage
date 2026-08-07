# API Reference

## CoverageApi

`CoverageApi` (`addons/gdunit4_coverage/CoverageApi.gd`) is a stateless,
static-style GDScript wrapper around the native `GdUnit4Coverage` engine
singleton provided by the C++ extension. Call it directly — never
instantiate it — e.g. `CoverageApi.enable()`.

When the native extension isn't loaded, every method is a safe no-op
(booleans return `false`, dictionaries/strings return empty,
`export_lcov`/`export_lcov_merged` return `ERR_UNAVAILABLE`).

### `is_available() -> bool`

Returns `true` if the native coverage extension is loaded.

```gdscript
if not CoverageApi.is_available():
    print("gdUnit4 Coverage extension is not loaded")
```

### `is_enabled() -> bool`

Returns `true` if coverage collection is currently active.

### `get_version() -> String`

Returns the version of the native coverage extension, or an empty
string when unavailable.

### `enable() -> void`

Starts coverage collection.

### `disable() -> void`

Stops coverage collection. Already-collected data is kept.

### `reset() -> void`

Clears all collected coverage data.

```gdscript
CoverageApi.reset()
# Coverage tracking starts fresh
```

### `register_script(script_path: String, executable_lines: PackedInt32Array) -> void`

Declares the executable lines of a script so unexecuted lines are
reported with a hit count of zero.

- `script_path` — the resource path of the script, e.g.
  `"res://src/player.gd"`
- `executable_lines` — the line numbers containing executable code

### `record_line(script_path: String, line: int) -> void`

Records one execution of the given 1-based line number of
`script_path`.

### `set_include_filters(filters: PackedStringArray) -> void`

Sets the `res://` path prefixes to include in coverage tracking. An
empty list tracks everything not excluded.

```gdscript
CoverageApi.set_include_filters(["res://src/"])
# Only files under res://src/ are tracked
```

### `set_exclude_filters(filters: PackedStringArray) -> void`

Sets the `res://` path prefixes to exclude from coverage tracking.

```gdscript
CoverageApi.set_exclude_filters(["res://tests/", "res://addons/"])
```

### `get_summary() -> Dictionary`

Returns the coverage summary: `lines_found`, `lines_hit`,
`coverage_percent`, and per-script details under `scripts`. Empty when
the extension is unavailable.

```gdscript
var summary := CoverageApi.get_summary()
print("Coverage: %d/%d lines (%.1f%%)" % [
    summary.get("lines_hit", 0),
    summary.get("lines_found", 0),
    summary.get("coverage_percent", 0.0),
])
```

### `get_script_coverage(script_path: String) -> Dictionary`

Returns the per-line coverage of a single script as a mapping of line
number to execution count. Empty when unknown or unavailable.

Counts are covered/uncovered (`0`/`1`) unless the project setting
`gdunit4_coverage/runner/count_hits` enables real per-line hit counting.

### `export_lcov(path: String) -> Error`

Exports the collected coverage data as an LCOV tracefile (line,
function, and branch records) to `path` (supports `res://` and
`user://`). Returns `OK` on success.

```gdscript
var err := CoverageApi.export_lcov("user://coverage/coverage.lcov")
```

### `export_lcov_merged(path: String) -> Error`

Merges the collected data of a partial run into the LCOV tracefile at
`path`, at file granularity: scripts touched this session replace their
record, untouched scripts keep the file's existing record verbatim. A
missing file behaves like `export_lcov()`. Returns `OK` on success.

### `load_lcov(path: String) -> Dictionary`

Loads an LCOV tracefile back into per-file coverage keyed by `res://`
script path. Each entry contains:

- `lines` — line number → execution count
- `functions` — function name → `{"line": int, "calls": int}`
- `branches` — branch line → array of per-arm taken counts

Returns the parsed report, empty when unreadable or the extension is
unavailable.

## Integration with gdUnit4

Coverage is triggered from gdUnit4's own test discovery, not
automatically on every test run — see
[Usage Guide](USAGE.md#running-tests-with-coverage) for the four entry
points.

Under the hood, `addons/gdunit4_coverage/GdUnitCoverageTestSessionHook.gd`
is what makes this possible. gdUnit4 has no other extension point that
runs inside the test process itself, before the first test and after
the last — this hook is what arms tracking at session start and
collects the hits and exports the report at session end. It's wired in
automatically when you enable the plugin; nothing to configure. When a
coverage run finishes:

1. The gdcov runner's recorded hits are read
2. The LCOV report is written (`export_lcov` or `export_lcov_merged`
   for a partial run)
3. The editor gutter and Coverage Report panel update

## Project Settings

All settings live under **Project Settings → Gdunit4 Coverage** (enable
*Advanced Settings* to see them). Key ones:

| Setting | Default | Purpose |
|---|---|---|
| `gdunit4_coverage/runner/gdcov_path` | *(empty)* | Path to the gdcov runner binary |
| `gdunit4_coverage/runner/count_hits` | `false` | Record real per-line execution counts instead of covered/uncovered |
| `gdunit4_coverage/export/lcov_path` | `user://coverage/coverage.lcov` | LCOV report target |
| `gdunit4_coverage/filter/include_paths` | *(empty = everything)* | `res://` prefixes to track |
| `gdunit4_coverage/filter/exclude_paths` | `["res://addons/"]` | `res://` prefixes to skip |
| `gdunit4_coverage/visualization/view_mode` | Gutter Only | Gutter Only / Gutter And Line Colors / Line Colors Only |
| `gdunit4_coverage/visualization/show_hit_counts` | `false` | Render per-line hit counts in the gutter |
| `gdunit4_coverage/report/threshold_good_percent` | `75.0` | Report panel "good" color threshold |
| `gdunit4_coverage/report/threshold_warn_percent` | `50.0` | Report panel "warn" color threshold |

## Performance Considerations

- A tracked line records at most once per session, so overhead scales
  with the number of tracked lines, not with test count or how often a
  line executes
- Enabling `count_hits` records real per-line execution counts for the
  whole session, instead of the default one-shot covered/uncovered
  recording
- Coverage only runs via the gdcov runner during explicit coverage
  runs — it has no effect on normal test runs or exported game builds

## Limitations

- Requires a gdcov build matching your project's Godot minor version
  exactly — a mismatch is rejected, not silently ignored
- Some dynamic code patterns may not be fully tracked

See [Troubleshooting](TROUBLESHOOTING.md) for details.

## See Also

- [Usage Guide](USAGE.md) — How to use coverage in your workflow
- [Examples](EXAMPLES.md) — Code examples
- [Troubleshooting](TROUBLESHOOTING.md) — Common issues
