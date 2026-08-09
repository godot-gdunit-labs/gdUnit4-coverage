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

> **First time running coverage?** If the run seems stuck with no
> progress, your security software may be holding gdcov back — see
> [Coverage Window Opens, Then Hangs
> Forever](#coverage-window-opens-then-hangs-forever) below. This is
> common on the very first run of a newly downloaded or rebuilt gdcov
> binary and is not specific to this plugin.

### "failed to start the gdcov runner"

**Problem:** Running a coverage command reports this instead of running.

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
3. **Third-party antivirus / security software.** See [Coverage Window
   Opens, Then Hangs Forever](#coverage-window-opens-then-hangs-forever)
   below — the same security-software behavior more often shows up as a
   silent hang than as this error, but can cause either.
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

### Coverage Window Opens, Then Hangs Forever

**Problem:** The gdcov runner window appears (sometimes with a colored
border around it) and your tests never start, or start and never finish —
no output, no error, just a frozen window you have to close manually.

**Cause:** Security software (antivirus / internet security suites) can
silently trap gdcov the first time it runs and never let it continue.
Confirmed with **Comodo Internet Security**; other security suites with a
similar "run unknown programs in a protected sandbox" feature can likely
do the same thing. Skip straight to **Solution** below if you just want
the fix — the rest of this section explains why it happens, for anyone
who wants that context before changing a security setting.

**Why your security software reacts to gdcov, in plain terms:** most
antivirus/internet-security products keep a trust list of programs they
recognize, built from how widely-installed and how long-known a program
is, and from whether it carries a code-signing certificate that vouches
for its publisher. gdcov doesn't have either yet — see [What Is
gdcov?](ARCHITECTURE.md#what-is-gdcov) for what it actually does, so you
can judge that trust decision yourself. Some security software reacts to
an unrecognized program by watching it closely or running it in a
restricted sandbox until you (or the vendor's cloud service) vouch for it
— and that restriction can block something gdcov needs to start
rendering, which is what causes the freeze.

Comodo's dashboard shows this kind of block happening under **Blocked
Intrusions**:

![Comodo dashboard, Blocked Intrusions counter highlighted][img-blocking]

Its **View Logs** screen shows what specifically got stopped — here, gdcov
being denied a normal keyboard-input hook that any Godot game or editor
sets up on startup:

![Comodo HIPS log: gdcov blocked from Install Hook and keyboard access][img-log]

In Comodo, this is **HIPS → File Rating → File List** — find the gdcov
binary (or add it manually) and mark it **Trusted**:

![Comodo File List, gdcov entry with Rating set to Trusted][img-trusted]

Press **OK** to accept the change, then rerun the coverage command.

If your security software doesn't use the same terms, look for anything
described as a program's trust, reputation, or rating — as opposed to a
firewall/network rule or a simple allow/block rule.

**Note:** this fix is tied to the exact file, so it must be repeated every
time gdcov is rebuilt or re-downloaded (for example, after **Setup
Coverage Runner** fetches an update) — the new file looks unrecognized
again to your security software. If that gets tedious, check whether your
security software can trust an entire folder instead of one file at a
time.

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

[img-blocking]: ../assets/troubleshooting/commodo-blocking.png
[img-log]: ../assets/troubleshooting/commodo-protocol.png
[img-trusted]: ../assets/troubleshooting/comodo-file-rating-trusted.png

**Last Updated:** 2026-08-09
