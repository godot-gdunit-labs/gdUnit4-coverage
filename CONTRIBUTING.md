# Contributing to gdUnit4-coverage

**Thank you for considering contributing to gdUnit4-coverage!**
We appreciate your input and want to make the contribution process as easy
and transparent as possible. Whether you want to report a bug, discuss
improvements, submit a fix, propose new features, or help with
documentation, we welcome your involvement.

**Note on scope:** this repo ships the GDScript plugin
(`addons/gdunit4_coverage/`) and public documentation. The native
GDExtension source (the C++ that actually records coverage) is closed
and lives in a private repo. Code contributions here can target the
GDScript plugin, the demo project, the CI workflow, and the docs —
behavior changes to the native recording mechanism need to be filed as
an issue instead.

## Reporting Bugs

If you encounter any bugs or issues, please use GitHub's issue tracking
system: [open a new
issue](https://github.com/godot-gdunit-labs/gdUnit4-coverage/issues/new/choose)
and pick the Bug Report template. When submitting a bug report, please
provide detailed information, including the steps to reproduce the
issue, your environment, and sample code if possible.

## Development on GitHub

We use GitHub to host our code, track issues and feature requests, and
accept pull requests. We follow [GitHub
Flow](https://docs.github.com/en/get-started/quickstart/github-flow)
for making code changes: all code modifications should be proposed
through pull requests.

**If you'd like to contribute, please follow these steps:**

1. Select an open issue to work on, or open a new one if none exists.
2. Fork the repository and create a branch from `main` with a short,
   descriptive name (e.g. `fix/gutter-amber-color`).
3. If you change GDScript behavior, add or update tests under
   `demo/tests/` where practical.
4. If you add or change plugin behavior, update the relevant doc under
   `docs/`.
5. Open a pull request:
   - Link it to the corresponding issue, if any.
   - Include `## Why` and `## What` sections in the description.
   - Keep the change minimal and focused.
   - Ensure your code follows the [Coding Style](#coding-style)
     conventions below.
   - Ensure CI (`.github/workflows/coverage.yml`) passes.
6. Submit the pull request!

## Pull Request Rules

1. **Title & description**
   - Title: a concise, present-tense summary (e.g. "Fix gutter amber
     color on partial branch coverage").
   - Description must include a `## Why` (motivation) and `## What`
     (what changed) section.
2. **Scope**
   - Keep changes minimal and focused. Include documentation updates
     where applicable.

### AI Usage

The use of AI is permitted, but you remain fully responsible for your
contributions.

- Never commit AI-generated code without understanding it yourself.
- Avoid unnecessary class or function documentation when names are
  already self-explanatory.

## Project Setup

Contributing to this repo only requires a standard Godot install — no
C++ toolchain, no Mono/.NET build. The native extension binary ships
as a release asset; you don't need to build it to work on the plugin
or docs.

### Prerequisites

You should be comfortable with:

- Basic Godot usage (scenes, nodes, scripts, project settings)
- Reading and writing GDScript
- Basic Git workflow

### Compatibility & Supported Versions

This project currently supports **Godot 4.7 (stable)** and **gdUnit4
v6.2+** — see [Installation](docs/INSTALLATION.md) for exact
requirements.

### Setup GDScript Linting

GDScript linting uses
[`gdtoolkit`](https://github.com/Scony/godot-gdscript-toolkit)
(`gdlint`, version 4.5.0):

```bash
pip install gdtoolkit==4.5.0
gdlint addons/gdunit4_coverage/
```

Please use explicitly typed declarations (`var x: Type = ...`), type
all function parameters and return types, and follow [Godot's
GDScript style
guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html).
Linting is enforced by CI.

### Testing Your Changes

The `demo/` project is a minimal gdUnit4 test suite used by this
repo's own CI
([`.github/workflows/coverage.yml`](.github/workflows/coverage.yml))
— the same workflow runs on every pull request, so opening a PR is
usually enough to verify a change. To run it locally, follow
[Installation](docs/INSTALLATION.md) to set up gdUnit4 and the gdcov
runner against the `demo/` project.

## License

By contributing to this project, you agree that your contributions
will be licensed under the same [MIT License](LICENSE) that covers
the project. If you have any concerns, please reach out to the
maintainers.

## Coding Style

To maintain code consistency, please adhere to [Godot's GDScript
Conventions](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html).
