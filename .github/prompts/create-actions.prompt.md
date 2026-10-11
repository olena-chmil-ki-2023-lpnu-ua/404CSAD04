---
description: "Create or verify script-driven GitHub Actions CI for the Rust Cargo project on master and develop across Linux, Windows, and macOS."
name: "create-actions"
argument-hint: "Optional Cargo project directory (defaults to the current workspace)"
agent: "agent"
---

# Configure Cross-Platform GitHub Actions

Use the existing [github-actions skill](../skills/github-actions/SKILL.md) as the authoritative procedure for workflow structure, platform scripts, validation, and error handling. Follow its safety rules and do not contradict its requirements.

## Prerequisites

1. Read the linked `github-actions` skill before acting.
2. Identify the Cargo project root from the provided directory or current workspace.
3. Verify that `Cargo.toml` exists and the Rust project is present. Inspect `src/main.rs` and relevant project files; do not change Rust source code as part of CI configuration.
4. Inspect `.github/workflows/ci.yml`, any other relevant workflow files, and existing `ci.sh` and `ci.bat` scripts before proposing changes.
5. If the directory is unclear or required files are missing, stop and report the exact issue rather than creating a new Cargo project.

## Actions

1. Create or safely update `.github/workflows/ci.yml` to:
   - Run for `push` and `pull_request` events targeting `master` and `develop`.
   - Use exactly one CI job with a matrix of `ubuntu-latest`, `windows-latest`, and `macos-latest`.
   - Check out source using `actions/checkout`.
   - Install/configure the stable Rust toolchain.
   - Invoke the matching platform script for build and test: `ci.sh` on Linux/macOS and `ci.bat` on Windows.
2. Create or safely update `ci.sh` for Linux/macOS. It must run `cargo build` to compile the project and produce the platform-native Hello World executable, then run `cargo test`. Enable fail-fast shell behavior so any failed command returns a nonzero exit status.
3. Create or safely update `ci.bat` for Windows. It must run `cargo build` and `cargo test`, checking each command's error level and exiting nonzero immediately on failure.
4. The workflow must invoke the scripts for all build and test work. Do not add direct `cargo build` or `cargo test` invocations as workflow steps.
5. Preserve existing workflow and script content. Make only minimal, necessary edits. Never overwrite user changes or remove existing behavior without explicit approval.
6. Avoid duplicating workflows, jobs, steps, or script commands on repeated execution. Reuse compliant existing files; create only missing files. Do not create unrelated project files.
7. Do not include secrets, tokens, credential values, or unnecessary token permissions in the workflow or scripts.
8. Validate the workflow structure and script syntax where possible. Run the local platform's script only if execution is requested and permitted. Confirm cross-platform success through the GitHub Actions results for all three matrix legs; local testing on one OS is not sufficient.
9. Report files inspected and changed, validation performed, and any remaining platform checks. Do not claim success when any build, test, or matrix job fails.

## Expected Files

- `.github/workflows/ci.yml` with the requested triggers, one three-OS matrix job, checkout, stable Rust setup, and script-based build/test invocation.
- `ci.sh` to build and test on Linux/macOS.
- `ci.bat` to build and test on Windows.

Existing files must be preserved and verified or minimally amended. The scripts must return failure to GitHub Actions if either compilation or tests fail. `cargo build` creates the platform-specific Hello World executable in Cargo's `target` directory; do not hard-code a platform-dependent executable name.

## Verification Steps

From the project root, verify:

```sh
cargo build
cargo test
bash ci.sh
```

On Windows Command Prompt, verify:

```bat
ci.bat
```

Inspect `.github/workflows/ci.yml` to confirm:

- `push` and `pull_request` both target `master` and `develop`.
- The workflow has one job whose matrix includes `ubuntu-latest`, `windows-latest`, and `macos-latest`.
- It checks out the repository and sets up stable Rust.
- Build and test are performed by `ci.sh` or `ci.bat`, not directly by workflow Cargo steps.

For full cross-platform verification, inspect the GitHub Actions run and confirm all three OS matrix jobs pass, including `cargo build` and `cargo test` through their scripts.

## Error Handling

- **Missing Cargo project or `Cargo.toml`:** Report `Cannot configure CI: Cargo.toml was not found in the specified project root.` Stop; do not scaffold or recreate the project.
- **Existing workflow/script conflict:** Preserve the file, explain the conflicting content, and request approval before a change that would replace user behavior.
- **Missing platform script:** Report which script is missing. Create it only after verifying there is no equivalent existing script and preserving project conventions. Never bypass the script requirement by putting Cargo build/test commands directly into the workflow.
- **Workflow or script validation failure:** Report the exact validation command and diagnostic. Make only a safe, minimal correction; do not claim the workflow is valid until rechecked.
- **Build failure:** Stop and report the failing platform, script, Cargo command, and error output. Do not continue to tests as if the build succeeded.
- **Test failure:** Stop and report the failing platform, test output, and nonzero status. Do not skip or suppress tests.
- **Platform not run:** Mark that OS unverified. Do not claim all platforms pass based on local validation alone.
- **Secret exposure:** Do not add secrets or tokens. If existing content appears to contain a credential, do not reproduce it in the report; pause and alert the user without copying the value.

## Successful Execution Example

**Input:** The current directory is a Rust Cargo project with `Cargo.toml`; configure CI for `master` and `develop`.

**Expected result:** The project and existing CI assets are inspected first. The workflow contains one job with Ubuntu, Windows, and macOS matrix entries and uses checkout plus stable Rust setup. Linux/macOS runners call `ci.sh`; Windows calls `ci.bat`. Both scripts build the Hello World executable and run tests, returning failure if either command fails. Existing user changes are preserved, no secrets are introduced, and success is reported only after all three GitHub Actions matrix jobs pass.
