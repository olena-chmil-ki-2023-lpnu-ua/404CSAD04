---
description: "Read-only verification of the Rust Cargo project, Git state, build, Hello World output, unit tests, and cross-platform script-driven GitHub Actions configuration."
name: "check"
argument-hint: "Optional project directory (defaults to the current workspace)"
agent: "agent"
---

# Verify the Rust Laboratory Project

Perform a read-only verification of the Variant 4 Rust/Cargo project. Do not fix, create, delete, stage, or modify any project files. Do not run commands that write project configuration or source. This check must be safe to repeat.

## Prerequisites

1. Identify the project root from the supplied directory or current workspace. If unclear, ask before running commands.
2. Confirm the workspace appears to be a Rust Cargo project.
3. Confirm Git, Rust/Cargo, and the relevant platform shell are available. If a tool is unavailable, mark only affected checks as `NOT CONFIGURED` and explain why.
4. Do not expose secrets or copy credential values into the report.

## Verification Steps

Run checks from the project root. Report each item with exactly one status: `PASS`, `FAIL`, or `NOT CONFIGURED`.

### 1. Project structure

Read-only inspect whether each required file exists:

- `Cargo.toml`
- `Cargo.lock`
- `src/main.rs`
- `README.md`
- `.gitignore`

Mark `PASS` only when the file exists and is readable. Mark `FAIL` when absent or unreadable. Do not create or repair missing files.

### 2. Git repository state

Run:

```sh
git rev-parse --is-inside-work-tree
git status --short --branch
```

Confirm Git reports an existing work tree. Record the current branch and working-tree status without changing them. A dirty working tree is not itself a failure; report the changes as found. If Git is unavailable or the directory is not a repository, report `FAIL` and the relevant error.

### 3. Build

Run:

```sh
cargo build
```

Mark `PASS` only if Cargo exits successfully; otherwise mark `FAIL` and include the relevant error output. Do not modify files to fix compilation.

### 4. Application output

Run:

```sh
cargo run
```

Mark `PASS` only if it exits successfully and stdout is exactly `Hello, world!`, ignoring only the final platform-specific line ending. If the program fails or prints any other output, mark `FAIL` and include the observed output/error.

### 5. Unit tests

Run:

```sh
cargo test
```

Mark `PASS` only if the command exits successfully, all tests pass, and output confirms that the `BasicAddition` test is present and passes the `2 + 3 == 5` check. If the test is absent, mark `FAIL` and report it as missing; do not add it. If Cargo cannot run tests due to a missing toolchain, mark `NOT CONFIGURED` and explain.

### 6. CI scripts and workflow files

Read, do not edit, these paths:

- `ci.sh`
- `ci.bat`
- `.github/workflows/ci.yml`

For each path, mark `PASS` if it exists, is readable, and has the required behavior; otherwise mark `FAIL` if absent or incorrectly configured. Mark `NOT CONFIGURED` only when the check cannot be performed (for example, the file is inaccessible due to a tool limitation).

Check script contents:

- `ci.sh` must build the Rust Hello World executable and run `cargo test`, failing with a nonzero status if either command fails.
- `ci.bat` must build the Rust Hello World executable and run `cargo test`, stopping with a nonzero status if either command fails.

Check `.github/workflows/ci.yml`:

- `push` and `pull_request` trigger on both `master` and `develop`.
- One CI job has a matrix containing `ubuntu-latest`, `windows-latest`, and `macos-latest`.
- The workflow checks out the repository and sets up a stable Rust toolchain.
- Build/test execution calls `ci.sh` on Linux/macOS and `ci.bat` on Windows.
- Workflow steps do not directly invoke `cargo build` or `cargo test`; these commands belong in the scripts.
- The workflow contains no exposed secrets or tokens.

If the workflow configuration cannot be parsed or interpreted with available read-only tools, state the limitation and mark that validation `NOT CONFIGURED`; do not make changes to enable validation.

### 7. Cross-platform CI evidence

Inspect available GitHub Actions results only if they can be accessed without changing the repository. Mark `PASS` only when successful runs confirm all three operating systems. If no run is available or remote evidence cannot be accessed, mark `NOT CONFIGURED`; local checks on one operating system do not prove cross-platform support.

## Reporting Format

Use a table with a separate row for every verification:

| Check | Status | Evidence / issue |
|---|---|---|
| `Cargo.toml` | PASS / FAIL / NOT CONFIGURED | ... |
| `Cargo.lock` | PASS / FAIL / NOT CONFIGURED | ... |
| `src/main.rs` | PASS / FAIL / NOT CONFIGURED | ... |
| `README.md` | PASS / FAIL / NOT CONFIGURED | ... |
| `.gitignore` | PASS / FAIL / NOT CONFIGURED | ... |
| Git repository and branch/status | PASS / FAIL / NOT CONFIGURED | ... |
| `cargo build` | PASS / FAIL / NOT CONFIGURED | ... |
| `cargo run` output | PASS / FAIL / NOT CONFIGURED | ... |
| `cargo test` and `BasicAddition` | PASS / FAIL / NOT CONFIGURED | ... |
| `ci.sh` | PASS / FAIL / NOT CONFIGURED | ... |
| `ci.bat` | PASS / FAIL / NOT CONFIGURED | ... |
| `.github/workflows/ci.yml` configuration | PASS / FAIL / NOT CONFIGURED | ... |
| GitHub Actions: Ubuntu / Windows / macOS | PASS / FAIL / NOT CONFIGURED | ... |

Conclude with:

- **Satisfied:** list all requirements with `PASS`.
- **Needs fixes:** list all requirements with `FAIL`; suggest fixes without applying them.
- **Not verified:** list all `NOT CONFIGURED` checks and why they could not be performed.
- State clearly: **No project files were modified.**

## Error Handling

- Never delete, overwrite, stage, or modify project files while checking.
- Missing required files are `FAIL`, not an invitation to create them.
- On command failure, capture the command, exit status, and relevant diagnostic; continue with independent read-only checks where possible.
- If `cargo build` fails, still run `cargo run` and `cargo test` as independent diagnostic checks only if safe, and report each actual result. Do not claim their success implies the build passed.
- If `cargo test` fails, identify failing test names and output. Do not alter test code.
- Invalid CI configuration or direct Cargo build/test calls in workflow steps are `FAIL`; describe the specific discrepancy without editing it.
- If a tool, OS runner, or remote workflow evidence is unavailable, report `NOT CONFIGURED` rather than guessing.
- Repeat runs must only observe and report current state; they must remain side-effect-free.
