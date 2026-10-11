---
name: project-scaffold
description: "Create or verify a Rust Cargo binary Hello World project. Use when scaffolding a Rust project, checking Cargo.toml, src/main.rs, README.md, or .gitignore, or verifying the app with cargo run."
---

# Rust Project Scaffold

## Purpose

Create or verify a minimal Cargo binary project that prints exactly `Hello, world!`, while preserving all existing project files and user changes.

## When to Use

- Create a Rust Hello World project for a new assignment.
- Inspect an existing project and fill in missing scaffold files safely.
- Verify that an existing Cargo binary runs and prints the expected greeting.

## Inputs

- **Project name**: Cargo package name. Use a valid Cargo package name, such as `hello-world`.
- **Programming language**: Must be `Rust`. If another language is requested, stop and explain that this skill is Rust-only.
- **Project directory**: The target directory; use the current workspace when the user does not specify one.

## Outputs

- A Cargo binary project, either verified or scaffolded without overwriting existing files.
- The files `Cargo.toml`, `src/main.rs`, `README.md`, and `.gitignore` present in the project directory.
- Verification results from `cargo run`, including whether stdout is exactly `Hello, world!`.

## Procedure

1. Confirm the programming language is Rust and validate the requested project name. Identify the project directory before making changes.
2. Inspect the directory and read any existing `Cargo.toml`, `src/main.rs`, `README.md`, and `.gitignore`. Also check for `Cargo.lock` and other existing project files. Do not assume that a file is safe to replace just because it differs from a minimal template.
3. For each required file:
   - If it exists, preserve it. Verify its contents and make no changes when it already meets the requirement.
   - If it exists but does not meet the requirement, explain the mismatch and ask for approval before editing it. Do not replace or discard user content.
   - If it is missing, create only that missing file, creating `src/` if needed. Keep additions minimal and appropriate to the supplied project name.
4. Use these requirements when creating missing files:
   - `Cargo.toml`: a binary package with the requested valid package name and no unnecessary dependencies.
   - `src/main.rs`: a `main` function that prints exactly `Hello, world!`.
   - `README.md`: concise project purpose and `cargo run` usage.
   - `.gitignore`: ignore Cargo build output (`/target/`) without removing or changing existing ignore rules.
5. Do not run `cargo new` or `cargo init` over an existing project. If initialization is appropriate for a genuinely empty directory, first confirm it will not overwrite or conflict with existing files; otherwise create only the missing files.
6. Once the files are verified or safely created, run the verification commands from the project directory. Do not claim verification succeeded if a command fails or the output differs.
7. Report which files were already present, which missing files were added, the verification result, and any approval needed for conflicting existing content.

## Verification Commands

Run from the project directory:

```sh
cargo run
```

Confirm the process exits successfully and stdout is exactly:

```text
Hello, world!
```

If checking output programmatically, compare stdout without its final line ending so the expected greeting is not affected by platform-specific newline conventions.

## Error Handling

- If the language is not Rust, the project name is invalid, or the target directory is unclear, stop and report what needs correction.
- If a required existing file conflicts with the scaffold requirements, preserve it and request approval before editing. Do not silently skip the conflict or overwrite the file.
- If `cargo run` fails, stop, report the exact command and error output, and do not claim success. Diagnose the reported issue and propose the smallest safe fix; obtain approval before changing conflicting user content.
- If `cargo run` succeeds but stdout is not exactly `Hello, world!`, report the actual output and request approval before changing an existing `src/main.rs`.

## Example

**Input**

- Project name: `hello-world`
- Programming language: `Rust`
- Project directory: an existing directory containing `Cargo.toml`, `Cargo.lock`, `src/main.rs`, and `.gitignore`

**Expected result**

Inspect and preserve those existing files. Add `README.md` only if it is missing. Verify all required files, run `cargo run`, and report success only if it exits successfully and prints exactly `Hello, world!`.

## Typical Error Scenario

**Error:** `cargo run` reports that the manifest is missing or invalid.

**Solution:** Report the exact Cargo error. If `Cargo.toml` already exists, preserve it and request approval before correcting its contents. If it is missing, create a minimal binary manifest for the requested package name, then rerun `cargo run`.
