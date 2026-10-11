---
description: "Safely initialize Git for the current Rust/Cargo project when needed, verify Rust ignore rules while keeping Cargo.lock trackable, and report repository status."
name: "git-init"
argument-hint: "Optional project directory (defaults to the current workspace)"
agent: "agent"
---

# Initialize or Verify Git for the Rust Project

Safely prepare Git for the current Rust laboratory assignment (Variant 4). The repository may already exist with `master` and `develop` branches; preserve its history and current branch state.

## Prerequisites

- Identify the intended project root. Use the current workspace unless the user provides another directory.
- Confirm the directory is the Rust/Cargo project location or the intended repository root.
- Inspect existing Git metadata and `.gitignore` before changing anything.
- Never delete, reset, clean, replace, or overwrite user files or Git history. Do not switch branches, create commits, or push.
- If the intended directory is ambiguous, or a required change conflicts with existing user content, stop and ask before proceeding.

## Actions

1. Change to the intended project root and determine whether it is already inside a Git work tree:

   ```sh
   git rev-parse --is-inside-work-tree
   ```

2. If this command confirms an existing repository, preserve it. Do not run `git init` again and do not alter its branches, remotes, commits, or history.
3. If the directory is not a Git repository, check whether it already contains files. Initialize Git with `git init` only in the intended directory and only when doing so will not conflict with or replace existing repository metadata. If an unexpected `.git` path or other conflict exists, stop and report it rather than trying to repair or replace it.
4. Inspect `.gitignore` if present. Preserve all existing rules and user edits. If it is missing, create it with the required Rust/Cargo and safety patterns below. If rules are missing, append only the necessary lines; never replace the file.
5. Ensure the ignore rules cover:
   - Cargo build output: `/target/`
   - Build output: `/build/`
   - Log files and log directories, such as `*.log` and `/logs/`
   - Temporary/editor files, such as `*.tmp`, `*.temp`, `*.swp`, and `*.swo`
   - Common secret files, such as `.env` and `.env.*`, with an explicit exception for a safe template such as `!.env.example`; also cover common credential/key files without printing their contents
6. Ensure `Cargo.lock` is not excluded by `.gitignore`. For a Rust binary application, keep the lockfile eligible for version control. If existing ignore rules exclude it, append an appropriate `!Cargo.lock` exception after those rules, unless a conflicting rule makes this unsafe—in that case, ask for approval.
7. Do not stage or commit files as part of this command. If `Cargo.lock` exists but is untracked, report that it is not yet tracked; do not run `git add` without explicit user approval.
8. Display the current repository state using `git status`, including the active branch and working-tree changes.
9. Report whether Git was already initialized or newly initialized, what (if anything) was added to `.gitignore`, whether `Cargo.lock` is ignored/tracked/untracked, and the final status. Do not claim success if any verification command fails.

## Expected Files and State

- `.git/` exists for the intended repository, either already present or created by a necessary `git init`.
- `.gitignore` contains the required ignore rules and continues to allow `Cargo.lock` to be tracked.
- Existing project files, branches, commits, and uncommitted user changes remain untouched.
- No files are staged or committed by this command.

## Verification Commands

Run these commands from the project root and report their results:

```sh
git rev-parse --is-inside-work-tree
git status --short --branch
git check-ignore -v target/ build/ logs/ example.log example.tmp .env
git check-ignore -v Cargo.lock
git ls-files --error-unmatch Cargo.lock
```

Interpret verification carefully:

- The first command must print `true`.
- The status command must show the active branch and existing working-tree changes; do not require a clean tree.
- For ignore checks, confirm build outputs, logs, temporary files, and secret files match intended ignore rules. `git check-ignore` may return a nonzero status for paths that are not ignored; investigate the matching rule rather than treating that result as success.
- `Cargo.lock` should not match an ignore rule. `git ls-files --error-unmatch Cargo.lock` succeeds only when the lockfile is already tracked. If the file exists but is untracked, report that fact; do not stage it automatically.

## Error Handling

- If Git is unavailable, report the command and error and stop.
- If `git rev-parse` fails because the directory is not a repository, initialize only the confirmed target directory. If it fails for another reason, such as inaccessible files or unsafe metadata, stop and report the error.
- If initialization encounters existing or unexpected `.git` metadata, do not remove or replace it. Stop and ask for guidance.
- If `.gitignore` cannot be read or safely updated, preserve it and report the problem; do not overwrite it.
- If ignore verification shows a required pattern missing, add only the missing rule while preserving existing content, then rerun the relevant check.
- If `git status` reports pre-existing user changes, leave them unchanged and include an accurate summary. Do not stage, discard, or commit them.

## Successful Execution Example

**Starting state:** The project already has a Git repository on `develop`, with `master` also present, a tracked `Cargo.lock`, and an existing `.gitignore`.

**Expected result:** The prompt detects the repository and does not reinitialize it. It verifies or minimally adds any missing Rust ignore patterns, confirms `Cargo.lock` is not ignored, runs `git status --short --branch`, and reports the existing branch and working-tree state without staging or changing user files.

## Typical Error Scenario

**Error:** `git check-ignore -v Cargo.lock` shows that a broad existing rule excludes the lockfile.

**Solution:** Preserve the existing `.gitignore` contents and append `!Cargo.lock` after the excluding rule if that safely restores tracking eligibility. Rerun the ignore check. If another pattern or directory rule still excludes the lockfile, explain the conflict and ask before making further changes. Do not stage the lockfile automatically.
