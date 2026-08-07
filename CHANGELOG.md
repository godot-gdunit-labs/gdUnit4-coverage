# Changelog

All notable changes to gdUnit4 Coverage will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

Nothing yet.

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
