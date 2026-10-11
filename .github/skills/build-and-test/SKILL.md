---
name: build-and-test
description: "Configure, build, run, and test Rust projects with Cargo. Use when adding or verifying a Rust addition function, the BasicAddition unit test, Cargo builds, or application execution."
---

# Rust Build and Test

## Purpose

Guide safe Cargo build and test setup for the Rust laboratory assignment (Variant 4). The workflow adds a simple integer addition function and a `BasicAddition` unit test that checks `2 + 3 == 5`, then verifies the project with Cargo.

## When to Use

- Configure or inspect an existing Rust Cargo project.
- Add or verify a simple addition function and its `BasicAddition` unit test.
- Build, run, or test the Rust application using Cargo.
- Diagnose a compilation error or failing unit test.

## Inputs

- **Project name**: Cargo package name, if a new project must be initialized.
- **Programming language**: Must be `Rust`; stop if another language is requested.
- **Project directory**: Existing Cargo project directory or a user-approved empty directory.
- **Requested scope**: Build configuration, application run, and unit-test behavior; clarify any request beyond this scope.

## Expected Outputs

- An existing Cargo configuration inspected and reused, or a minimal configuration created only if files are missing and doing so is safe.
- A Rust addition function and `BasicAddition` test that verifies `2 + 3 == 5`, after preserving existing project structure and obtaining approval before changing conflicting user content.
- Results for `cargo build`, `cargo run`, and `cargo test`, with failures reported accurately.

## Safe, Repeatable Workflow

1. Confirm the language is Rust, identify the project directory, and check whether it is a Cargo project by inspecting `Cargo.toml`, `Cargo.lock`, `src/main.rs`, and existing tests.
2. Read relevant files before changing anything. Preserve existing content, dependencies, test organization, formatting, and user changes.
3. Do not run `cargo new` or `cargo init` over an existing project. If no Cargo project exists, initialize one only in an empty or user-approved directory. If files already exist and initialization may conflict, stop and request approval.
4. Inspect `Cargo.toml`. Reuse the existing manifest and dependencies; do not add a dependency for integer addition or unit testing. If the manifest needs changes, make only the necessary, approved edit.
5. Find the existing application and test modules. Before adding code, check whether an equivalent addition function and test already exist:
   - If they exist and cover the required behavior, leave them unchanged.
   - If they are missing and there is no conflict, add the smallest idiomatic implementation and test in the existing project structure.
   - If adding them requires changing or replacing user code, explain the conflict and request approval first.
6. Implement the operation with a simple function, for example `fn add(a: i32, b: i32) -> i32 { a + b }`. Keep it in the existing source or test module structure; do not create duplicate functions or tests on repeated runs.
7. Add a unit test named `BasicAddition` that asserts adding `2` and `3` returns `5`. Rust convention favors snake_case, but the assignment requires this test name; apply `#[allow(non_snake_case)]` to this test function only so Cargo reports it as `BasicAddition` without a naming warning.
8. Run the verification commands in order. Stop on the first failed build or test command and report its command and error output before making further changes.
9. Summarize files inspected and changed, build/run/test results, and any unresolved approval needed. Do not claim checks passed unless their command exits successfully.

## Example Implementation

In the existing source module, if no equivalent function exists and adding it is approved:

```rust
fn add(a: i32, b: i32) -> i32 {
    a + b
}
```

In the existing test module, if no equivalent test exists and adding it is approved:

```rust
#[test]
#[allow(non_snake_case)]
fn BasicAddition() {
    assert_eq!(add(2, 3), 5);
}
```

The narrowly scoped lint allowance preserves the assignment's exact test name while leaving naming checks enabled for the rest of the project.

## Verification Commands

Run from the Cargo project directory:

```sh
cargo build
cargo run
cargo test
```

- `cargo build` must exit successfully.
- `cargo run` must exit successfully and the application must behave as intended; for a Hello World scaffold, confirm stdout is exactly `Hello, world!`.
- `cargo test` must exit successfully and report the addition test as passed.

## Error Handling

- **Compilation or build failure:** Stop. Report the exact command and relevant compiler output. Explain the likely cause and propose the smallest safe correction. Do not continue to `cargo run` or `cargo test` until the build succeeds.
- **Test failure:** Stop. Report the failing test and assertion output. Diagnose whether the function, test expectation, or surrounding code is responsible; request approval before changing conflicting user code.
- **Cargo or toolchain unavailable:** Report the exact error and the required Cargo/Rust toolchain setup. Do not claim verification succeeded.
- **Existing code conflicts:** Preserve files and user changes. Ask for approval before editing or replacing conflicting content.
- **Repeated execution:** Re-check for equivalent code and tests before adding anything. Make no duplicate test, function, manifest section, or dependency.

## Example

**Input**

- Project name: `hello-world`
- Programming language: `Rust`
- Project directory: an existing Cargo project with a `Cargo.toml` and `src/main.rs`
- Request: add the Variant 4 addition test and verify the application

**Expected result**

Inspect the existing project and preserve its files. Add only a missing addition function/test when safe and approved, then run the three Cargo verification commands. Report the addition test as passed only if `cargo test` succeeds.

## Typical Error Scenario

**Error:** `cargo test` fails because the test cannot find `add`.

**Solution:** Stop and report the compiler diagnostic. Inspect the existing module visibility and test location. If the function is missing and adding it does not conflict with user code, add the minimal `add(i32, i32) -> i32` function in the appropriate module and rerun `cargo build`, `cargo run`, and `cargo test`. If a source change would alter existing behavior, request approval before proceeding.
