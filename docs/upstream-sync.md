# Upstream sync — DeepDenoiser OP7

Loop: **detect → sync → patch → build → validate → release or report** (playbook doc 06).

## Detection (daily, never builds)

`upstream-check.yml` compares the pinned `upstream/commit.txt` against
`sayampy/deepdenoiser@main`. On change it opens a "sync available" issue and
dispatches `op7-build.yml` with the new commit.

## Sync procedure (maintainer)

1. Update `upstream/commit.txt` to the new SHA.
2. Refresh `overrides/bun.lock`: `bun install` against the new tree, commit.
3. Rebase `patches/op7/*.patch` onto the new tree; run CI.
4. Dispatch a fast validation build; on green, decide on release.

## Conflict policy (hard)

- A patch that fails `git apply --3way` **stops** the pipeline: no build, no
  release. The failure report records upstream commit, failing patch, affected
  files, likely cause, and the required human decision.
- Never force-reset, never silently rewrite hunks, never auto-publish a broken merge.

## Safety invariant

A release is valid only if: sync ok → patches ok → deps resolve (frozen
lockfile) → compile ok → APK exists → badging ok → ABI ok → signing ok →
checksum ok. Any gate fails → no release.
