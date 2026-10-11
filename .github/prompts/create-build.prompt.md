---
description: "Configure and verify the existing Rust Cargo project, add the BasicAddition unit test through the build-and-test skill, and run Cargo build, application, and test checks."
name: "create-build"
argument-hint: "Project name and directory (defaults to csad_lab1 in the current workspace)"
agent: "agent"
---

# Configure, Build, and Test the Rust Project

Use the existing [build-and-test skill](../skills/build-and-test/SKILL.md) as the authoritative procedure for Cargo setup, the addition function and unit test, verification, and error handling. Follow its safety requirements.

## Prerequisites

1. Read the linked `build-and-test` skill before acting.
2. Confirm the project name, target directory, and that the programming language is Rust. If needed input is unclear, ask before making changes.
3. The current workspace already contains a working Rust Cargo project named `csad_lab1`. When that project is the target, use the workspace root in place. Do not recreate it, run `cargo new`/`cargo init`, or make a nested project directory.
4. Inspect `Cargo.toml`, `src/main.rs`, and the existing Rust tests before making changes.

## Actions

1. Verify that `Cargo.toml` and `src/main.rs` exist at the target project root. If either is missing or the target does not appear to be the intended Cargo project, stop and report the condition rather than creating a new project.
2. Configure or verify the Cargo build system in the existing `Cargo.toml`. Preserve its package metadata, dependencies, settings, and user changes. Do not add dependencies for basic integer addition or unit testing. Ask approval before changing conflicting existing configuration.
3. Inspect the existing code and tests for an equivalent addition function and a test named `BasicAddition`.
   - Reuse the existing function/test if they correctly test that `2 + 3 == 5`.
   - If either is missing, make only the minimal necessary addition in the existing source/test structure, after confirming it will not overwrite or conflict with user code.
   - Do not duplicate an existing function, test, or Cargo configuration.
   - Rust identifiers use snake_case by convention. To meet the required exact test name, use `#[allow(non_snake_case)]` on the test function `BasicAddition` only.
4. Run the verification commands from the Cargo project root, in this order:
   1. `cargo build`
   2. `cargo run`
   3. `cargo test`
5. Stop immediately if compilation or a test fails. Report the failing command and diagnostic output. Do not continue to later checks or claim success.
6. Report the project directory, files inspected and changed, and the result of each command. Do not claim success unless all three commands exit successfully, `cargo run` prints exactly `Hello, world!`, and `cargo test` reports `BasicAddition` and all other tests as passed.

## Expected Files

- Existing `Cargo.toml` with valid Cargo package/build configuration.
- Existing `src/main.rs` for the Hello World application and, if appropriate to the project's organization, the addition function.
- An existing or appropriately placed Rust test containing `BasicAddition`, verifying `2 + 3 == 5`.

Preserve all existing files and user changes. Add or change no unrelated files. Repeated execution must verify and reuse correct existing configuration and tests without duplication.

## Verification Commands

Run each command sequentially from the project root; only continue after the previous command succeeds:

```sh
cargo build
cargo run
cargo test
```

Expected results:

- `cargo build` succeeds and compiles the project.
- `cargo run` succeeds and stdout is exactly `Hello, world!` (ignoring the final platform-specific line ending only).
- `cargo test` succeeds, including `BasicAddition` with the assertion `2 + 3 == 5`.

## Error Messages and Handling

- **Missing project file:** Report `Cannot build: Cargo.toml or src/main.rs is missing from the specified project root.` Stop and ask how to proceed; do not scaffold or recreate the project without approval.
- **Build failure:** Report `cargo build failed` followed by the relevant compiler output. Stop before running `cargo run` or `cargo test`.
- **Application failure or wrong output:** Report `cargo run failed` or the actual stdout. Stop and ask before changing existing application behavior.
- **Test failure:** Report `cargo test failed` and the failing test/assertion output. Stop and do not report tests as passed.
- **Conflicting source or configuration:** Preserve the existing file and report the specific conflict. Ask for approval before editing it.
- **Unavailable Cargo toolchain:** Report the exact command error and that Rust/Cargo must be installed or available on `PATH`.

## Successful Execution Example

**Input:** Project name `csad_lab1`; target directory is the current workspace; language is Rust.

**Expected result:** Confirm `Cargo.toml` and `src/main.rs` exist, inspect and reuse the current Cargo configuration, and add `BasicAddition` only if an equivalent test is missing and a safe non-conflicting edit is possible. `cargo build`, `cargo run`, and `cargo test` all succeed; the application prints `Hello, world!`; the test verifies `2 + 3 == 5`. Existing files and unrelated user changes remain preserved.
