class_name CoverageApi
extends RefCounted

## Public GDScript API of the gdUnit4-Coverage GDExtension.
##
## All calls are forwarded to the native GdUnit4Coverage engine singleton
## provided by the C++ GDExtension. When the extension is not loaded, all
## methods are safe no-ops and is_available() returns false.
##
## This is a stateless static-style API - use it as CoverageApi.enable(),
## never instantiate it.

const SINGLETON_NAME := &"GdUnit4Coverage"


## Returns true if the native coverage extension is loaded.
static func is_available() -> bool:
	return Engine.has_singleton(SINGLETON_NAME)


## Returns true if coverage collection is currently enabled.
static func is_enabled() -> bool:
	var instance := _instance()
	return instance.call("is_enabled") if instance else false


## Returns the version of the native coverage extension, or an empty string when unavailable.
static func get_version() -> String:
	var instance := _instance()
	return instance.call("get_version") if instance else ""


## Starts coverage collection.
static func enable() -> void:
	var instance := _instance()
	if instance:
		instance.call("enable")


## Stops coverage collection. Already collected data is kept.
static func disable() -> void:
	var instance := _instance()
	if instance:
		instance.call("disable")


## Clears all collected coverage data.
static func reset() -> void:
	var instance := _instance()
	if instance:
		instance.call("reset")


## Declares the executable lines of a script so unexecuted lines are
## reported with a hit count of zero.
##
## script_path: the resource path of the script, e.g. "res://src/player.gd".
## executable_lines: the line numbers containing executable code.
static func register_script(script_path: String, executable_lines: PackedInt32Array) -> void:
	var instance := _instance()
	if instance:
		instance.call("register_script", script_path, executable_lines)


## Records one execution of the given line.
##
## script_path: the resource path of the script.
## line: the 1-based line number that was executed.
static func record_line(script_path: String, line: int) -> void:
	var instance := _instance()
	if instance:
		instance.call("record_line", script_path, line)


## Sets the path prefixes to include in coverage tracking, e.g. "res://src/".
## An empty list tracks all scripts that are not excluded.
static func set_include_filters(filters: PackedStringArray) -> void:
	var instance := _instance()
	if instance:
		instance.call("set_include_filters", filters)


## Sets the path prefixes to exclude from coverage tracking, e.g. "res://addons/".
static func set_exclude_filters(filters: PackedStringArray) -> void:
	var instance := _instance()
	if instance:
		instance.call("set_exclude_filters", filters)


## Returns the coverage summary containing lines_found, lines_hit,
## coverage_percent and per-script details under scripts.
## Empty when the extension is unavailable.
static func get_summary() -> Dictionary:
	var instance := _instance()
	return instance.call("get_summary") if instance else {}


## Returns the per-line coverage of a single script as a mapping of line
## number to execution count. Empty when unknown or unavailable.
## Counts are covered/uncovered (1/0) unless the project setting
## 'gdunit4_coverage/runner/count_hits' enables real per-line hit counting.
static func get_script_coverage(script_path: String) -> Dictionary:
	var instance := _instance()
	return instance.call("get_script_coverage", script_path) if instance else {}


## Exports the collected coverage data as an LCOV tracefile.
##
## path: the target file path, supports res:// and user://.
## Returns OK on success.
static func export_lcov(path: String) -> Error:
	var instance := _instance()
	return instance.call("export_lcov", path) if instance else ERR_UNAVAILABLE


## Merges the collected data of a partial run into the LCOV tracefile at the
## given path, at file granularity: scripts hit this session replace their
## record, untouched scripts keep the file's existing record verbatim.
## A missing file behaves like export_lcov().
##
## path: the tracefile path, supports res:// and user://.
## Returns OK on success.
static func export_lcov_merged(path: String) -> Error:
	var instance := _instance()
	return instance.call("export_lcov_merged", path) if instance else ERR_UNAVAILABLE


## Loads an LCOV tracefile back into per-file coverage keyed by res:// script
## path. Each entry contains "lines" (line number to execution count),
## "functions" (name to {"line", "calls"}) and "branches" (branch line to an
## array of per-arm taken counts).
##
## path: the tracefile path, supports res:// and user://.
## Returns the parsed report, empty when unreadable or the extension is unavailable.
static func load_lcov(path: String) -> Dictionary:
	var instance := _instance()
	return instance.call("load_lcov", path) if instance else {}


## Detects the gdcov runner and arms in-process line tracking.
## Returns {"active": bool, "message": String}; empty when the extension is unavailable.
## Internal to the test-session hook.
static func hook_startup() -> Dictionary:
	var instance := _instance()
	return instance.call("hook_startup") if instance else {}


## Reads the recorded hits, disarms tracking and exports the LCOV report.
## Returns {"success": bool, "message": String, "error": String}; empty when unavailable.
## Internal to the test-session hook.
static func hook_shutdown() -> Dictionary:
	var instance := _instance()
	return instance.call("hook_shutdown") if instance else {}


## Returns true if in-process coverage tracking is currently armed.
## Internal to the test-session hook.
static func is_armed() -> bool:
	var instance := _instance()
	return instance.call("is_armed") if instance else false


static func _instance() -> Object:
	return Engine.get_singleton(SINGLETON_NAME) if Engine.has_singleton(SINGLETON_NAME) else null
