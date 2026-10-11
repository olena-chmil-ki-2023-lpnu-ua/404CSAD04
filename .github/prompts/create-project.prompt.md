---
description: "Create or verify a Rust Cargo binary Hello World project using the project-scaffold skill while preserving existing files and avoiding duplicate or nested projects."
name: "create-project"
argument-hint: "Project name and target directory (for example: csad_lab1, current workspace)"
agent: "agent"
---

# Create or Verify a Rust Project

Use the existing [project-scaffold skill](../skills/project-scaffold/SKILL.md) as the authoritative procedure for scaffolding and verifying the Rust Cargo Hello World project. Follow its safety and error-handling requirements.

## Inputs

- **Project name**: Cargo package name (for example, `csad_lab1`).
- **Target directory**: Existing project directory or an explicitly intended empty directory.
- **Programming language**: Rust. This command is for Rust only.

If the project name or target directory is missing or ambiguous, ask the user before making changes. Do not assume a new nested folder should be created.

## Prerequisites

1. Read the linked `project-scaffold` skill.
2. Inspect the target directory and the workspace root to determine whether a Cargo project already exists.
3. Check existing `Cargo.toml`, `src/main.rs`, `README.md`, `.gitignore`, `Cargo.lock`, and other relevant files before acting.
4. The current workspace already contains a working Rust Cargo project named `csad_lab1`. If the requested project is this existing project, treat the workspace root as its target and verify it in place. Do not run `cargo new` or `cargo init`, create a `csad_lab1/csad_lab1` nested directory, or recreate the project.

## Actions

1. Confirm the inputs specify Rust, a valid Cargo package name, and a target directory.
2. Delegate the scaffold procedure to the existing `project-scaffold` skill. Do not duplicate or contradict its instructions.
3. Verify the target location before making any change. If it is already a Cargo project, work in place. If the requested package name differs from the existing manifest package name, report the mismatch and ask for approval; do not rename or recreate the project.
4. Ensure the project contains or safely creates only missing required files:
   - `Cargo.toml`
   - `src/main.rs`
   - `README.md`
   - `.gitignore`
5. Preserve every existing file and user change. Never overwrite a conflicting file without explicit approval. If an existing required file does not meet the Hello World requirement, explain the conflict and ask before editing it.
6. Do not create duplicate Cargo projects, extra nested project directories, or redundant files. Repeated runs must check current state and leave correct existing files unchanged.
7. Verify the application with `cargo run` from the Cargo project root. Confirm successful exit and stdout exactly `Hello, world!` (ignoring only the final platform-specific line ending).
8. Report the target directory, the files verified or added, the command result, and any mismatch or approval needed. Never claim success when verification fails.

## Expected Files

The target project contains:

- `Cargo.toml` defining the requested Rust binary package.
- `src/main.rs` providing the Hello World executable.
- `README.md` with concise project and run instructions.
- `.gitignore` that ignores Cargo build output while preserving existing ignore rules.

If any file already exists, inspect and preserve it. Add only missing files when safe and approved.

## Verification Commands

From the confirmed project root:

```sh
cargo metadata --no-deps --format-version 1
cargo run
```

Confirm Cargo metadata resolves the intended manifest and package (not a nested or duplicate project), and `cargo run` exits successfully with stdout exactly:

```text
Hello, world!
```

## Error Handling

- **Ambiguous project name or directory:** Ask for clarification before creating or changing files.
- **Existing project/package-name mismatch:** Preserve the manifest and source; report the mismatch and ask for approval before renaming anything.
- **Existing file conflicts with the scaffold:** Preserve the file, explain the conflict, and request approval before modification.
- **Cargo command unavailable:** Report the exact command and error, and state that Rust/Cargo must be installed or added to `PATH`.
- **`cargo run` fails:** Report the exact command and error output. Stop; do not claim success or silently recreate the project.
- **Output differs from the expected greeting:** Report the actual output and ask before changing existing source.

## Successful Execution Example

**Input:** Project name `csad_lab1`; target directory is the current workspace; language is Rust.

**Expected result:** Recognize the existing `csad_lab1` Cargo project and inspect it in place. Preserve existing project files, add only missing required scaffold files if appropriate, create no nested directory, and verify the project using Cargo. Report success only if `cargo run` prints exactly `Hello, world!`.

## Typical Error Scenario

**Error:** Running `cargo new csad_lab1` from the workspace creates or would create `csad_lab1/csad_lab1`, even though the workspace root already contains `Cargo.toml`.

**Solution:** Stop before initialization. Use the existing workspace root as the project directory, inspect its manifest and source files, and continue through the `project-scaffold` skill without running `cargo new` or creating nested files.
