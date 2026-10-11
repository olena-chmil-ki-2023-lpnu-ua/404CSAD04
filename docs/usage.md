# Usage guide

## Local development

From the repository root, run:

```bash
cargo build
cargo run
cargo test
```

To run only the lab verification test:

```bash
cargo test BasicAddition
```

## CI workflow

The repository includes a GitHub Actions config that runs on:

- `push` to `master` and `develop`
- `pull_request` targeting `master` and `develop`

The matrix covers:

- `ubuntu-latest`
- `windows-latest`
- `macos-latest`

Each platform invokes its matching script:

- `ci.sh` on Linux/macOS
- `ci.bat` on Windows

These scripts run the same Cargo build and test steps locally and in GitHub Actions.

## Troubleshooting

If a command fails, inspect the exact Cargo diagnostic and rerun the command from the project root. Keep the repo in a simple Cargo layout and avoid nested Rust projects or unrelated tooling.
