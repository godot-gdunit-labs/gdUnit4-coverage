# Changelog

All notable changes to gdUnit4 Coverage will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

Nothing yet.

## [0.1.3] - [0.1.4]

### Added

- A hint in the "Setup Coverage Runner" popup and console log warning that
  antivirus/security software may flag or block a freshly installed gdcov
  binary on its first run, with a link to [Troubleshooting][ts-hang]
- The spawned gdcov runner now writes its own engine log, making failures
  that happen before it can stream any events back much easier to diagnose

### Fixed

- A rare crash in trial mode when a test suite exceeded the trial's file
  cap, caused by a data race in the discard path
- gdcov is now verified by its filename instead of being executed to check
  it, avoiding running an unverified binary
- Errors that decline a coverage run are now always logged to the editor
  Output panel, not just shown as a toast that can be missed

### Documentation

- Added a "What Is gdcov?" section to [Architecture](docs/ARCHITECTURE.md)
  explaining exactly what the coverage patch does and does not do
- Added a troubleshooting entry for antivirus/security software blocking
  gdcov, with screenshots walking through cause and fix

## [0.1.0] - [0.1.2]

### Added

- Line-by-line code coverage tracking for GDScript, recorded in-process by
  the **gdcov** patched-engine runner — see
  [Architecture](docs/ARCHITECTURE.md) for how it works
- LCOV format export (line, function, and branch records) for standard tool
  compatibility
- Visual coverage feedback in the Godot script editor: gutter coloring plus
  a Coverage Report panel
- gdUnit4 integration via a test session hook — coverage runs from the
  editor Tools menu, the gdUnit4 Inspector, the script editor context menu,
  or the FileSystem dock
- `CoverageApi` GDScript API for manual export, filtering, and reset

---

**Note:** This project is in closed beta. Features and APIs are subject to
change before the first stable release.

[ts-hang]: docs/TROUBLESHOOTING.md#coverage-window-opens-then-hangs-forever
