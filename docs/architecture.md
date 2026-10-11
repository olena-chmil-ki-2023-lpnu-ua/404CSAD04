# Architecture overview

This project is intentionally a single Rust binary crate with a small supporting library module.

## High-level structure

- `Cargo.toml` declares the package name and Rust edition.
- `src/main.rs` is the executable entry point for the app and remains responsible for printing the required Hello World output.
- `src/lib.rs` exposes shared functionality used by tests, including the `add` helper used for the lab’s arithmetic check.
- `tests/basic_addition.rs` contains the repository’s focused validation for `2 + 3 == 5`.
- `.github/workflows/ci.yml` orchestrates CI across multiple operating systems.
- `ci.sh` and `ci.bat` encapsulate the build and test logic used by the workflow.

## Why this structure works

The repo keeps the application simple so the workflow remains easy to verify:

- A binary target handles the runtime entry point.
- A library target keeps logic testable without changing user-facing output.
- Cargo handles compilation, execution, and test discovery in a standard Rust workflow.

This design is enough for a learning lab and avoids unnecessary framework or dependency complexity.
