extends GdUnitTestSessionHook

## gdUnit4 test session hook of gdUnit4-Coverage.
##
## Thin GDScript shim - gdUnit4 requires session hooks to be GDScript classes
## inheriting GdUnitTestSessionHook, the implementation lives in the native
## extension and is reached through the typed CoverageApi wrapper (which
## no-ops cleanly when the extension is not loaded).
##
## startup: arms in-process line tracking. Requires the tests to run on the
## gdcov coverage runner (a patched Godot that records line hits in-process),
## launched with -d so its EngineDebugger is active. On a stock Godot binary
## coverage cleanly stays inactive.
##
## shutdown: collects the recorded hits from the runner, disarms tracking and
## exports the LCOV report.


func _init() -> void:
	super("GdUnit4CoverageHook", "Collects code coverage during the test session and exports an LCOV report.")


func startup(session: GdUnitTestSession) -> GdUnitResult:
	if not CoverageApi.is_available():
		return GdUnitResult.error("gdUnit4 Coverage: native extension 'GdUnit4Coverage' is not loaded.")

	var result := CoverageApi.hook_startup()
	session.send_message(result["message"])
	return GdUnitResult.success()


func shutdown(session: GdUnitTestSession) -> GdUnitResult:
	if not CoverageApi.is_available():
		return GdUnitResult.error("gdUnit4 Coverage: native extension 'GdUnit4Coverage' is not loaded.")

	if not CoverageApi.is_armed():
		return GdUnitResult.success()

	var result := CoverageApi.hook_shutdown()
	if not result["success"]:
		return GdUnitResult.error("gdUnit4 Coverage: %s" % result["error"])
	session.send_message(result["message"])
	return GdUnitResult.success()
