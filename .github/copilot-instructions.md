# Copilot instructions for CSAD_Lab1

## Project overview

- This repository is a minimal Rust/Cargo binary crate named `csad_lab1`.
- The application is intentionally small: `Cargo.toml` defines the crate metadata and `src/main.rs` is the single executable entry point.
- The current runtime behavior is a standard Hello World program: `println!("Hello, world!");` in `src/main.rs`.
- This repository is not a framework application or multi-module workspace. The architecture is a single binary crate with generated output under `target/`.
- The `.github/` directory contains the assignment workflow metadata: prompt files describe the stage-by-stage lab process, `skills/` holds implementation details, and `agents/` defines the build-engineer role. Treat these as operational guidance for the lab rather than application code.

## Build, test, and lint commands

Run these from the repository root:

```bash
cargo build
cargo run
cargo test
```

If the assignment requires running a single test by name, use:

```bash
cargo test BasicAddition
```

There is no project-level lint configuration in this repository today. Do not add extra linting or build tooling just to satisfy a generic requirement. If formatting is needed, prefer the standard Rust toolchain command only when the task explicitly calls for it:

```bash
cargo fmt
```

## High-level architecture

- `Cargo.toml` is the source of truth for package metadata, edition, and dependencies; the project is intentionally dependency-light.
- `src/main.rs` is the only application source file. Keep changes narrowly scoped unless the assignment explicitly introduces additional behavior.
- `Cargo.lock` is tracked for this binary crate and should remain in version control.
- `target/` is generated build output; treat it as disposable and let `.gitignore` handle it.
- `.github/prompts/` contains the step-by-step tasks for the lab (`init`, `create-build`, `create-actions`, `check`), and `.github/skills/` contains the authoritative guidance for Cargo setup and CI.
- The codebase is deliberately simple enough that a single source file and the Cargo manifest are enough to understand the app’s runtime behavior.

## Key conventions and repository-specific rules

- Use Rust and Cargo for all changes; avoid introducing CMake, Makefiles, or unrelated languages/tools.
- Preserve the existing Hello World behavior unless the task explicitly changes functionality. `cargo run` should continue to print exactly `Hello, world!`.
- When the lab calls for a test, keep the exact requirement: test name `BasicAddition`, assertion `2 + 3 == 5`, and no extra behavior beyond that requested scope.
- Do not reinitialize Git, change branches, stage or commit files, or rewrite repository history as part of routine maintenance unless the user explicitly asks.
- Respect the repo’s existing `.gitignore` rules, especially the `target/` exclusion and the decision to keep `Cargo.lock` tracked.
- Prefer the existing prompt/skill workflow in `.github/` when making repository changes; avoid duplicating or overwriting conflicting user content without confirmation.
- Keep the project as a single Cargo binary crate. Do not create nested Rust projects or additional workspace members unless the task clearly requires it.

