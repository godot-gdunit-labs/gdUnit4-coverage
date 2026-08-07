# Troubleshooting

## Installation Issues

### Plugin Not Appearing in Plugin List

**Problem:** After extracting the plugin, it doesn't show up in
**Project Settings → Plugins**.

**Solutions:**

1. Verify the plugin is in the correct location:
   `your-project/addons/gdunit4_coverage/plugin.cfg`
2. Restart Godot completely (close and reopen)
3. Check the Output panel for errors

### Missing gdUnit4 Dependency

**Problem:** Errors referencing `res://addons/gdUnit4/...` scripts that
can't be found.

**Solution:**

- Install gdUnit4 first:
  [gdUnit4 Installation](https://github.com/MikeSchulze/gdUnit4)
- Ensure it's in `addons/gdUnit4/` (uppercase `U`), enabled in
  **Project Settings → Plugins**

### Godot / gdUnit4 Version Too Old

**Problem:** The plugin loads but coverage commands fail or behave
unexpectedly.

**Solution:** This build requires Godot 4.7 (stable) and gdUnit4
v6.2+. Check **Help → About** for your Godot version.

---

## gdcov Runner Issues

### `Could not create child process: ...gdcov.exe`

**Problem:** Running a coverage command fails with this error (or the
Linux/macOS equivalent).

**Likely causes, in order of likelihood:**

1. **Gdcov Path setting is empty or wrong.** Check **Project Settings →
   Gdunit4 Coverage → Runner → Gdcov Path** points at an actual gdcov
   binary. Use **Project → Tools → GdUnit4 Coverage: Setup Coverage
   Runner** to set it up automatically.
2. **Windows Mark-of-the-Web block.** If you downloaded the gdcov
   binary through a browser (rather than the in-editor downloader),
   Windows tags it as downloaded-from-the-internet, and the editor
   spawning it as a child process can get silently blocked. Fix:
   right-click the `.exe` → **Properties** → check **Unblock**, or run
   `Unblock-File path\to\gdcov.exe` in PowerShell.
3. **Third-party antivirus / HIPS software.** Products like Comodo
   Internet Security block an unsigned parent process (the Godot
   editor) from spawning an unrecognized child process (a freshly
   downloaded gdcov binary) at the driver level — this persists even
   after closing the antivirus's tray icon, since the enforcement runs
   as a background service. Check the security software's own logs
   (not just Windows Defender's) for a block/sandbox entry, and add an
   exception for the Godot editor and/or gdcov binary.
4. **gdcov/Godot version mismatch.** The runner must match your
   project's Godot minor version exactly; a mismatch produces a clear
   version-mismatch error instead, not this one — but worth
   double-checking if you're unsure which build you downloaded.

### "gdcov must match the project's Godot minor exactly"

**Problem:** The runner starts, but the version guard rejects it.

**Solution:** Download the gdcov build for your exact Godot minor (e.g.
a 4.7 project needs a 4.7 gdcov build, not 4.6). **Setup Coverage
Runner** always fetches the matching build automatically.

### "the gdUnit4 test server is not active"

**Problem:** A coverage command reports this instead of running.

**Solution:** Restart the Godot editor, then retry.

---

## Runtime Issues

### No Coverage Data After a Run

**Problem:** A coverage run completes, but no colors appear in the
gutter.

**Possible causes:**

1. The file you're viewing wasn't covered by the tests that ran (check
   your include/exclude filters)
2. `gdunit4_coverage/editor/show_coverage_gutter` is disabled

**Solutions:**

1. Check the Output panel for the coverage summary line printed at
   session close
2. Narrow `include_paths`/`exclude_paths` so the files you care about
   are tracked first
3. Open the [Coverage Report panel](USAGE.md#coverage-report-panel) to
   confirm what was actually tracked

### Coverage Looks Inaccurate

**Possible causes:**

1. Dynamic code (signals, property access via `set`/`get`, `call()`)
   may not track perfectly
2. Stale data from a previous session — call `CoverageApi.reset()` or
   clear the display
3. Multiline statements — a statement spanning several lines is
   attributed to its first line

**Solutions:**

1. Reset coverage between unrelated runs
2. Use static method calls where possible for the clearest attribution

---

## Export & Report Issues

### LCOV File Not Created

**Problem:** `CoverageApi.export_lcov()` returns an error, or no file
appears.

**Solutions:**

1. Verify coverage was actually tracked first:

   ```gdscript
   var summary := CoverageApi.get_summary()
   print(summary)  # should show non-zero lines_found
   ```

2. Check the returned `Error` — a non-`OK` result means the write
   failed (bad path, no write permission)
3. Confirm the extension is loaded: `CoverageApi.is_available()`

### Can't Find the LCOV File

**Problem:** Export reports success, but you can't locate the file.

**Default location:** `user://coverage/coverage.lcov` (configurable
via `gdunit4_coverage/export/lcov_path`).

To find the absolute path:

```gdscript
print(ProjectSettings.globalize_path("user://coverage/coverage.lcov"))
```

Typical `user://` locations:

- **Windows:** `%APPDATA%\Godot\app_userdata\<project-name>\`
- **macOS:**
  `~/Library/Application Support/Godot/app_userdata/<project-name>/`
- **Linux:** `~/.local/share/godot/app_userdata/<project-name>/`

### CI/CD Can't Find the LCOV File

**Solutions:**

1. Use an absolute path, or resolve `user://` explicitly in your test
   setup before uploading
2. Verify the file exists before the upload step (`ls` it in your CI
   script)
3. Confirm the CI runner actually ran a coverage command, not just a
   plain test run

---

## Performance Issues

### Coverage Run Feels Slow

Overhead is normally near-zero — a tracked line records at most once
per run.

**If it's noticeably slower than a plain test run:**

1. Narrow tracking scope:

   ```gdscript
   CoverageApi.set_include_filters(["res://src/"])
   CoverageApi.set_exclude_filters(["res://tests/", "res://addons/"])
   ```

---

## Editor Issues

### Gutter Colors Disappear After Editing

**Expected behavior:** the gutter reflects the last coverage session's
data; editing a file doesn't invalidate it until you run coverage again.

**Solutions:**

1. Re-run a coverage command to refresh
2. Close and reopen the file if colors seem stuck

---

## FAQ

**Q: Does coverage tracking affect my exported game's performance?**
A: No. Coverage only runs via the gdcov runner during explicit coverage
runs in the editor/CI — exported game builds are unaffected.

**Q: Can I use this with C# projects?**
A: Not currently — GDScript only.

**Q: Can I disable coverage for specific files?**
A: Yes:

```gdscript
CoverageApi.set_exclude_filters(["res://generated/", "res://third_party/"])
```

**Q: Does this work in CI?**
A: Yes, but not with `--headless` — gdcov refuses that flag the same
way gdUnit4 itself does. On Linux CI it runs under `xvfb` with a
software renderer instead; see
[Examples](EXAMPLES.md#example-5-github-actions-cicd-integration).

---

## Getting Help

**Still stuck?**

1. **Check Documentation:** [Usage Guide](USAGE.md),
   [API Reference](API.md)
2. **Search Issues:**
   [GitHub Issues](https://github.com/godot-gdunit-labs/gdUnit4-coverage/issues)
3. **Ask Community:**
   [GitHub Discussions](https://github.com/godot-gdunit-labs/gdUnit4-coverage/discussions)
4. **Report Bug:** Create a new issue with:
   - Godot version
   - gdUnit4 version
   - Plugin version
   - Steps to reproduce
   - Error message/screenshot

---

**Last Updated:** 2026-08-06
