# CSAD Lab 1

## Student Information

- Full Name: Chmil Olena Pavlivna
- Group: KI-404
- University: Lviv Polytechnic National University
- Variant: 4
- Programming Language: Rust
- Build System: Cargo
- Testing Framework: cargo test

This repository contains a minimal Rust Cargo binary project named `csad_lab1`.

## Project purpose

The application is intentionally small: it demonstrates a basic Rust project structure, a standard Cargo build/run workflow, and a simple `BasicAddition` test verifying the arithmetic behavior required by the lab.

## Requirements

- Rust toolchain with Cargo installed
- A working terminal in the repository root

## Build, run, and test

From the repository root:

```bash
cargo build
cargo run
cargo test
```

To run only the lab test by name:

```bash
cargo test BasicAddition
```

The expected program output is:

```text
Hello, world!
```

## Repository structure

- `Cargo.toml` defines the Rust crate metadata and dependencies.
- `src/main.rs` contains the executable entry point and prints the Hello World message.
- `src/lib.rs` provides the shared `add` function used by the lab test.
- `tests/` contains the `BasicAddition` verification test.
- `.github/workflows/ci.yml` runs the project on Ubuntu, Windows, and macOS using Cargo build and test scripts.

## CI

The project includes cross-platform CI scripts for the repository:

- `ci.sh` for Linux and macOS
- `ci.bat` for Windows

The GitHub Actions workflow runs those scripts for `push` and `pull_request` on `master` and `develop`.
