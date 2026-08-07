# Installation Guide

## Prerequisites

- **Godot Engine** 4.7 (stable)
- **gdUnit4** v6.2 or later, installed in your project

## Installation Steps

### Step 1: Download

Download the latest release from
[Releases](https://github.com/godot-gdunit-labs/gdUnit4-coverage/releases).

### Step 2: Extract to Addons

Extract the plugin to your project's `addons/` folder:

```text
your-project/
└── addons/
    ├── gdUnit4/              (existing)
    └── gdunit4_coverage/     (new - extracted here)
```

### Step 3: Enable the Plugin

1. Open your Godot project
2. Go to **Project → Project Settings → Plugins**
3. Find **gdUnit4 Coverage** in the list
4. Click the checkbox to **Enable**
5. Godot will reload the editor

### Step 4: Set Up the gdcov Runner

Coverage is recorded in-process by **gdcov**, a patched Godot binary — the
editor itself can't record coverage on its own, so you need a gdcov build
that matches your Godot version.

**Automatic (recommended):**

1. **Project → Tools → GdUnit4 Coverage: Setup Coverage Runner**
2. The plugin downloads the gdcov build matching your Godot version and
   sets **Project Settings → Gdunit4 Coverage → Runner → Gdcov Path**
   automatically.

**Manual:**

1. Download the gdcov build for your platform and Godot version from
   [Releases](https://github.com/godot-gdunit-labs/gdUnit4-coverage/releases)
2. Place it anywhere in your project (e.g.
   `addons/gdunit4_coverage/bin/gdcov.exe`)
3. Set **Project Settings → Gdunit4 Coverage → Runner → Gdcov Path** to
   the file
4. **Windows only:** if you downloaded the binary through a browser,
   Windows may tag it as downloaded-from-the-internet and block your
   antivirus/security software from letting the editor spawn it. If you
   see `Could not create child process`, right-click the `.exe` →
   **Properties** → check **Unblock**, or run
   `Unblock-File path\to\gdcov.exe` in PowerShell. Third-party
   antivirus/HIPS software (e.g. Comodo) can also block an unrecognized
   binary at the driver level even after this — check the security
   software's own logs if the error persists.

The gdcov version must match your project's Godot **minor** version
exactly (e.g. a 4.7 gdcov build for a 4.7 project) — a mismatch is
rejected with a clear error rather than silently producing wrong results.

### Step 5: Verify Installation

1. Run **Project → Tools → GdUnit4 Coverage: Run Tests with Coverage**
2. The gdUnit4 Inspector should open and stream test results live
3. When the run finishes, open a tracked GDScript file — the gutter
   should show covered/uncovered line coloring
4. If you see errors, check [Troubleshooting](TROUBLESHOOTING.md)

## Next Steps

- Read the [Usage Guide](USAGE.md) to start tracking coverage
- Check [Examples](EXAMPLES.md) for common workflows
- See [API Reference](API.md) for the GDScript API

## Uninstallation

1. Disable the plugin (**Project → Project Settings → Plugins**)
2. Delete the `addons/gdunit4_coverage/` folder
3. Restart Godot

## Support

If you encounter issues:

1. Check [Troubleshooting](TROUBLESHOOTING.md)
2. Review [FAQ](TROUBLESHOOTING.md#faq)
3. [Report an issue](https://github.com/godot-gdunit-labs/gdUnit4-coverage/issues)
4. Ask in [Discussions](https://github.com/godot-gdunit-labs/gdUnit4-coverage/discussions)
