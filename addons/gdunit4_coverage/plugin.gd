@tool
extends EditorPlugin

## Editor plugin entry point of gdUnit4-Coverage.
##
## Responsibilities:
## - verify the native extension is loaded and register the coverage test
##   session hook with gdUnit4 (the hook setting is a typed
##   Dictionary[String, bool], so it is kept in GDScript)
##
## Everything else lives in the native extension: the coverage run commands,
## the tool menu entry, the Command Palette entries, the inspector popup
## injection and the script editor / FileSystem context menus are implemented
## by GdUnit4CoverageEditorPlugin + GdUnit4CoverageCommands (Task 15.2/15.3).
## The commands drive the native GdUnit4CoverageRunner (Task 15.6), which
## reproduces gdUnit4's editor test run on the gdcov binary - the runner
## streams its events back over gdUnit4's TCP server, so the inspector and
## console update live.

const HOOK_PATH := "res://addons/gdunit4_coverage/GdUnitCoverageTestSessionHook.gd"
const GDUNIT4_PLUGIN := "res://addons/gdUnit4/plugin.cfg"
# Storage key used by GdUnitSettings (GdUnitSettings.SESSION_HOOKS).
const SESSION_HOOKS_SETTING := "gdunit4/hooks/session_hooks"


func _enter_tree() -> void:
	if CoverageApi.is_available():
		print("gdUnit4 Coverage: native extension loaded (v%s)." % CoverageApi.get_version())
	else:
		push_warning("gdUnit4 Coverage: native GDExtension is not loaded. Build it with 'scons target=template_debug' first.")
	_register_session_hook()


func _register_session_hook() -> void:
	if not FileAccess.file_exists(GDUNIT4_PLUGIN):
		push_warning("gdUnit4 Coverage: gdUnit4 addon not found, session hook not registered.")
		return

	# gdUnit4 persists session hooks in the project settings and loads them
	# in the test runner process, so a one-time registration is sufficient.
	# The setting is written directly because GdUnitSettings may not have
	# created its properties yet at plugin load time.
	var hooks: Dictionary[String, bool] = {}
	if ProjectSettings.has_setting(SESSION_HOOKS_SETTING):
		hooks.assign(ProjectSettings.get_setting(SESSION_HOOKS_SETTING))
	if hooks.has(HOOK_PATH):
		return
	hooks[HOOK_PATH] = true
	ProjectSettings.set_setting(SESSION_HOOKS_SETTING, hooks)
	var error := ProjectSettings.save()
	if error != OK:
		push_warning("gdUnit4 Coverage: cannot persist session hook registration: %s" % error_string(error))
		return
	print("gdUnit4 Coverage: session hook registered.")
