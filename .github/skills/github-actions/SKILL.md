---
name: github-actions
description: "Configure cross-platform GitHub Actions CI for Rust Cargo projects using checked-in build and test scripts. Use when creating or verifying CI workflows for Linux, Windows, and macOS."
---

# Rust GitHub Actions CI

## Purpose

Create or verify CI for the Variant 4 Rust Cargo project. The workflow must run on Linux, Windows, and macOS, and must delegate project build and test commands to platform-appropriate scripts rather than invoking `cargo build` or `cargo test` directly in the workflow.

## When to Use

- Add or verify GitHub Actions CI for a Rust/Cargo project.
- Configure push and pull request validation for the `develop` and `master` branches.
- Create or verify the cross-platform `ci.sh` and `ci.bat` scripts.
- Diagnose CI workflow, script, build, or test failures.

## Inputs

- **Project name**: Cargo package name, used to understand or report the project.
- **Programming language/build system**: Must be Rust with Cargo; stop if a different stack is requested.
- **Project directory**: The Cargo project root containing `Cargo.toml`.
- **Existing CI assets**: Any workflow files and `ci.sh`/`ci.bat` scripts already present. Inspect them before proposing changes.

## Outputs

- `.github/workflows/ci.yml` with push and pull request triggers for `develop` and `master`, one CI job, and an OS matrix for `ubuntu-latest`, `windows-latest`, and `macos-latest`.
- A Linux/macOS `ci.sh` and a Windows `ci.bat` that compile the project, run `cargo test`, and build the Hello World executable.
- A summary of files created or changed and validation results for the workflow configuration, scripts, and available operating systems.

## Safe File Handling and Repeatability

1. Inspect `Cargo.toml`, source files, `.github/workflows/`, and any existing `ci.sh` or `ci.bat` before editing.
2. Preserve existing workflow files and scripts. If a target file already exists, review its content and make only a minimal, additive change. Never replace user changes without approval; request approval if requirements conflict with existing behavior.
3. Check for equivalent CI jobs and script commands before adding them. Reuse or update the existing implementation rather than duplicating workflows, jobs, steps, or commands.
4. Create only missing required files and directories. Repeating the skill must not create duplicate workflows or scripts.
5. Do not add secrets or tokens to the workflow, scripts, logs, or examples. The requested build/test workflow must not require credentials.

## Procedure

1. Confirm this is a Rust Cargo project and identify the repository root.
2. Inspect existing workflow and script files. Confirm the project can be built and tested with Cargo; do not change Rust source as part of CI setup unless separately requested and approved.
3. Create or safely update `.github/workflows/ci.yml` with:
   - `push` and `pull_request` triggers, each targeting `develop` and `master`.
   - Exactly one CI job with a matrix containing `ubuntu-latest`, `windows-latest`, and `macos-latest`.
   - `actions/checkout` to check out the repository.
   - A Rust toolchain setup step, for example `dtolnay/rust-toolchain@stable`.
   - A platform-specific script invocation step. On Linux and macOS, invoke `bash ci.sh`; on Windows, invoke `cmd /c ci.bat`. Use the matrix OS value to select the correct script.
4. Create or safely update `ci.sh` for Linux/macOS. It must stop on command failures, run `cargo build` to compile the project and produce the Hello World executable, and run `cargo test`. A suitable shell failure mode is `set -eu`. Do not hide command output or errors.
5. Create or safely update `ci.bat` for Windows. It must stop on command failures, run `cargo build` to compile the project and produce the Hello World executable, and run `cargo test`. Check each command's error level and exit nonzero immediately if it fails.
6. Ensure the workflow invokes the scripts for build and test. Do not put direct `cargo build` or `cargo test` steps in `ci.yml`; those commands belong in `ci.sh` and `ci.bat`. The workflow may have separate setup actions such as checkout and Rust toolchain setup.
7. Validate YAML structure and script syntax where local tools are available. Run the scripts locally only on the current platform; local success does not prove the other operating systems pass.
8. Review the GitHub Actions run matrix and verify that separate matrix runs execute on all three operating systems. Report unavailable remote validation as pending rather than claiming it passed.
9. Summarize files inspected, created, or changed, the exact checks performed, and any remaining CI validation required.

## Required Workflow Shape

Use the following as a structural guide, adapting only when needed to preserve existing project conventions:

```yaml
name: Rust CI

on:
  push:
    branches: [develop, master]
  pull_request:
    branches: [develop, master]

jobs:
  build-and-test:
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v4
      - uses: dtolnay/rust-toolchain@stable
      - name: Build and test (Linux/macOS)
        if: runner.os != 'Windows'
        shell: bash
        run: bash ci.sh
      - name: Build and test (Windows)
        if: runner.os == 'Windows'
        shell: cmd
        run: ci.bat
```

Ensure the step's invocation syntax works on each runner. On Windows, use the `cmd` shell to invoke the batch script; on Linux and macOS, use `bash` to invoke the shell script. These are two conditional steps within the same matrix job, and exactly one runs per matrix operating system. The commands inside the scripts—not the workflow YAML—must run `cargo build` and `cargo test`. Do not add token permissions or credentials unless a separate, approved requirement makes them necessary.

## Script Requirements

`ci.sh` must be suitable for Linux and macOS and should follow this behavior:

```sh
#!/usr/bin/env bash
set -eu
cargo build
cargo test
```

`ci.bat` must be suitable for Windows `cmd.exe` and stop at the first failure. For example:

```bat
@echo off
cargo build
if errorlevel 1 exit /b %errorlevel%
cargo test
if errorlevel 1 exit /b %errorlevel%
```

`cargo build` creates the platform-native Hello World executable under Cargo's `target` directory. Do not hard-code an executable suffix that would make the script non-portable. If the assignment requires release artifacts, use `cargo build --release` consistently in both scripts and verify the corresponding output under `target/release`.

## Verification Commands

From the project root, verify locally on the available platform:

```sh
cargo build
cargo test
```

Then verify that the script for the current platform exits successfully:

```sh
bash ci.sh
```

For Windows, run from Command Prompt:

```bat
ci.bat
```

Inspect the workflow to confirm the triggers, single matrix job, all three runner labels, checkout, Rust toolchain setup, and script-based build/test invocation. Validate the YAML and inspect the GitHub Actions run for each matrix leg. A local check cannot substitute for a successful Windows, Linux, and macOS CI run.

## Error Handling

- **Workflow failure:** Identify the failing matrix operating system, step, and error output. Do not report the workflow as passing if any matrix leg fails.
- **Missing script:** Report which script is missing. Create only that file after checking for equivalent scripts or existing project conventions; do not silently switch to direct Cargo commands in `ci.yml`.
- **Build failure:** Stop the script immediately, report the exact Cargo diagnostic, and do not continue to tests or claim success.
- **Test failure:** Stop and report the failing test and output. Do not suppress failure codes or make the workflow green by skipping tests.
- **YAML or shell/batch syntax failure:** Report the validation command and diagnostic, then make the smallest safe fix without overwriting unrelated user changes.
- **Unavailable platform runner:** Report that platform as unverified and rely on GitHub Actions matrix results for final cross-platform confirmation.

## Example

**Input**

- Project name: `hello-world`
- Language/build system: Rust/Cargo
- Project directory: repository root with `Cargo.toml`
- Requested CI branches: `develop` and `master`

**Expected result**

Create or update `.github/workflows/ci.yml`, `ci.sh`, and `ci.bat` only when needed and only after preserving existing content. The workflow runs a single job on Ubuntu, Windows, and macOS for pushes and pull requests targeting either branch. Each runner calls its platform script; the scripts build the Cargo project, create the Hello World executable, and run `cargo test`. Report full cross-platform success only after all three matrix runs pass.

## Typical Error Scenario

**Error:** The Windows CI leg reports that `ci.sh` is not recognized or cannot be executed.

**Solution:** Check that the workflow selects `ci.bat` for the Windows runner and invokes it through `cmd.exe /c ci.bat`. Keep `ci.sh` for Linux/macOS. Preserve existing scripts, fix only the incorrect platform selection or invocation, and rerun the workflow to verify all matrix legs.
