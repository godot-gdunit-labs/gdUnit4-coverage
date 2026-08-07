# Usage Examples

## Example 1: Basic Coverage Run

```gdscript
# tests/calculator_test.gd
extends GdUnitTestSuite

func test_calculator_add():
    var calc = Calculator.new()
    assert_that(calc.add(2, 3)).is_equal(5)

func test_calculator_subtract():
    var calc = Calculator.new()
    assert_that(calc.subtract(5, 3)).is_equal(2)
```

**What happens:**

1. Trigger a coverage run — e.g. **Project → Tools → GdUnit4 Coverage:
   Run Tests with Coverage**
2. gdcov spawns, runs the suite, and records which lines in
   `Calculator` executed
3. When the session closes, the gutter shows green (executed) / red
   (not executed) lines, and the LCOV report is written automatically

## Example 2: Reading a Coverage Summary

```gdscript
# Run after a coverage session has completed
extends Node

func _ready():
    var summary := CoverageApi.get_summary()
    print("Coverage: %d/%d lines (%.1f%%)" % [
        summary.get("lines_hit", 0),
        summary.get("lines_found", 0),
        summary.get("coverage_percent", 0.0),
    ])
```

## Example 3: Manual LCOV Export

Export or merge the current session's data explicitly, e.g. from a test hook:

```gdscript
func after_suite():
    var err := CoverageApi.export_lcov("user://coverage/coverage.lcov")
    if err != OK:
        push_error("LCOV export failed: %s" % error_string(err))
```

Merging a partial run into an existing report instead of overwriting it:

```gdscript
CoverageApi.export_lcov_merged("user://coverage/coverage.lcov")
```

## Example 4: Filter Coverage by Path

Only track coverage for specific directories:

```gdscript
func setup_coverage_filters():
    # Only track src/
    CoverageApi.set_include_filters(["res://src/"])

    # Or exclude specific paths instead
    CoverageApi.set_exclude_filters([
        "res://tests/",
        "res://addons/",
        "res://examples/",
    ])
```

Useful for focusing reports on core logic you actually maintain.

## Example 5: GitHub Actions CI/CD Integration

There's no dedicated GitHub Marketplace action for gdUnit4-coverage
yet — set it up as its own workflow steps, the way the example below
does. A dedicated action to simplify this is planned for the future.

Coverage needs the **gdcov** runner, not stock Godot — a plain Godot
binary records no coverage at all. gdcov also can't take `--headless`
(gdUnit4 refuses it); on Linux CI it runs under `xvfb` instead.

A complete, working workflow is right here in this repo:
[`.github/workflows/coverage.yml`](../.github/workflows/coverage.yml).
It's the actual CI that tests this repo's own `demo/` project, so it's
kept in sync automatically instead of drifting like a copy pasted into
this doc would. Copy it into your project's `.github/workflows/` and
adjust:

- `--path demo` → `--path .` (or wherever your project lives) in the
  import and test-run steps
- The `Locate LCOV tracefile` step's `gdUnit4-coverage-demo` path
  segment → your own project's `config/name` (from `project.godot`);
  see [Troubleshooting](TROUBLESHOOTING.md#cant-find-the-lcov-file) for
  the platform-specific `user://` paths

## Example 6: Reset Between Focused Runs

```gdscript
func reset_coverage_for_new_suite():
    CoverageApi.reset()
    print("Coverage data cleared, ready for a new run")
```

## Example 7: Generate an HTML Report

External tools can turn the LCOV tracefile into a browsable report:

```bash
genhtml coverage.lcov -o htmlcov/
```

## Common Patterns

### Track Only Game Logic

```gdscript
CoverageApi.set_include_filters(["res://src/game/"])
CoverageApi.set_exclude_filters(["res://src/ui/", "res://src/audio/"])
```

## Tips & Tricks

✅ **Best Practices:**

- Use `set_include_filters`/`set_exclude_filters` (or the equivalent
  project settings) to keep coverage scoped to code you actually
  maintain
- Set a minimum coverage threshold for CI/CD

❌ **Avoid:**

- Chasing 100% coverage (diminishing returns)
- Testing internal implementation details
- Using coverage as the only quality metric

See [Troubleshooting](TROUBLESHOOTING.md) for common issues and solutions.
