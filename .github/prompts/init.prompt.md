---
description: "Orchestrate the complete Rust/Cargo Variant 4 setup sequentially: verify Git, scaffold Hello World, configure build and BasicAddition test, create cross-platform CI, then run the final check."
name: "init"
argument-hint: "Optional project name and directory (defaults to csad_lab1 in the current workspace)"
agent: "agent"
---

# Initialize the Rust Laboratory Project

Coordinate the complete Rust/Cargo Variant 4 workflow by executing the five existing prompt files in order. This is an orchestrator: do not perform stages in parallel, skip a failed stage, or duplicate their instructions. Read and follow each referenced prompt and skill at its stage.

## Prerequisites

- **Language:** Rust.
- **Project name:** Defaults to `csad_lab1` unless the user specifies another.
- **Project directory:** Defaults to the current workspace unless the user specifies another.
- Confirm the intended directory and inputs before making changes. If ambiguous, ask the user.
- The current project and Git repository already exist, with `master` and `develop` branches. Preserve the repository, branch, history, and working tree. For this project, the Git stage must verify existing state rather than reinitialize or rewrite it.
- Before execution, inspect the five referenced prompt files and required skills. If a required file is missing or unreadable, stop and report it.
- Preserve user files and changes. Never overwrite existing changes without approval, create a nested Cargo project, duplicate tests, stage or commit files, or rewrite Git history.

## Inputs

- Project name (optional; default `csad_lab1`).
- Project directory (optional; default current workspace).
- Programming language (Rust).

## Required Workflow and References

Execute each prompt stage sequentially. Start the next stage only after the prior stage completes successfully with `PASS`.

### Stage 1 — `git-init`

Read and execute [git-init.prompt.md](./git-init.prompt.md).

- Verify Git repository state and the current branch/status.
- Verify or safely complete `.gitignore` rules for Rust/Cargo, build output, logs, temporary files, and secrets; keep `Cargo.lock` trackable.
- Since this repository already exists, do not run `git init` or alter `master`, `develop`, or repository history.

### Stage 2 — `create-project`

Read and execute [create-project.prompt.md](./create-project.prompt.md), following [project-scaffold/SKILL.md](../skills/project-scaffold/SKILL.md).

- Create or verify the Rust Cargo binary Hello World project in the specified directory.
- Check `Cargo.toml`, `src/main.rs`, `README.md`, and `.gitignore`.
- For the existing `csad_lab1` project, work in place and avoid nested projects.
- Verify `cargo run` prints exactly `Hello, world!`.

### Stage 3 — `create-build`

Read and execute [create-build.prompt.md](./create-build.prompt.md), following [build-and-test/SKILL.md](../skills/build-and-test/SKILL.md).

- Verify Cargo configuration and add or verify a simple addition function and exact test name `BasicAddition`, checking `2 + 3 == 5`.
- Avoid duplicate tests and preserve existing source/configuration.
- Run `cargo build`, `cargo run`, and `cargo test` in the order specified by that prompt. Stop the stage at the first failure.

### Stage 4 — `create-actions`

Read and execute [create-actions.prompt.md](./create-actions.prompt.md), following [github-actions/SKILL.md](../skills/github-actions/SKILL.md).

- Create or verify `.github/workflows/ci.yml`, `ci.sh`, and `ci.bat`.
- Configure push and pull request triggers for `master` and `develop`, with one job matrix for Ubuntu, Windows, and macOS.
- Use checkout and stable Rust toolchain setup. The workflow must call the platform scripts; the scripts must build the Hello World executable and run `cargo test`.
- Preserve existing CI files, avoid secrets, and ensure failures propagate.

### Stage 5 — `check`

Read and execute [check.prompt.md](./check.prompt.md) as the final verification stage.

- Perform its read-only project, Git, build, run, test, script, workflow, and cross-platform checks.
- The final check must not modify project files.

## Execution Rules

1. Execute the referenced prompt content one stage at a time and in the exact order above. Do not run stages concurrently.
2. Pass the same confirmed project name and directory to each applicable stage.
3. Record a status and concise evidence for each completed stage.
4. If any stage returns an error, a verification failure, a required input/approval is unresolved, or a referenced prompt/skill is unavailable, stop immediately. Do not run later stages. Report the blocking stage and diagnostic, and mark later stages `NOT CONFIGURED`.
5. Do not claim an unexecuted stage passed. Final cross-platform CI is `PASS` only if the GitHub Actions results confirm successful Ubuntu, Windows, and macOS runs.
6. Run safely when repeated: detect existing compliant files and state, avoid duplicates, and make no unnecessary changes.
7. Do not delete project files, overwrite user changes without approval, stage or commit files, change branches, or force-push/rewrite Git history.

## Expected Outputs

- Verified Git repository and Rust/Cargo ignore configuration.
- A verified Cargo Hello World project with `Cargo.toml`, `Cargo.lock`, `src/main.rs`, `README.md`, and `.gitignore`.
- A verified addition function and `BasicAddition` test.
- A script-driven GitHub Actions workflow and platform scripts.
- Final read-only verification results.

Report files created or changed by each stage. Preserve and accurately mention pre-existing user modifications; do not call a stage successful if a required artifact or check is missing.

## Final Report

End with a table that has one row for each stage:

| Stage | Status | Evidence / error |
|---|---|---|
| 1. `git-init` | PASS / FAIL / NOT CONFIGURED | ... |
| 2. `create-project` | PASS / FAIL / NOT CONFIGURED | ... |
| 3. `create-build` | PASS / FAIL / NOT CONFIGURED | ... |
| 4. `create-actions` | PASS / FAIL / NOT CONFIGURED | ... |
| 5. `check` | PASS / FAIL / NOT CONFIGURED | ... |

Then summarize satisfied requirements, remaining fixes, files changed, and any platform checks not verified. Use `PASS` only when the stage completed and its required checks succeeded; use `FAIL` for an observed error or requirement mismatch; use `NOT CONFIGURED` when it could not be run or was not reached.

## Successful Execution Example

**Input:** Rust project name `csad_lab1`; target is the current workspace; repository already exists with `master` and `develop`.

**Expected result:** Stage 1 verifies Git without reinitializing or changing branches. Stages 2–4 inspect and safely complete only missing requirements in place, with no nested Cargo project or duplicate test. Stage 5 verifies the result without edits. Report `PASS` for every stage only after the required checks succeed, including all three GitHub Actions matrix operating systems.

## Typical Failure Scenario

**Failure:** Stage 3 runs `cargo build` and receives a compiler error.

**Handling:** Mark `create-build` as `FAIL`, report the failing command and relevant diagnostic, and stop. Do not run `create-actions` or `check`. Mark those unreached stages `NOT CONFIGURED`; preserve the source and ask for approval before changing conflicting user content.
