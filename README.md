# DeepDenoiser · OnePlus 7 Edition

[![OP7 Build](https://github.com/rajbhx/deepdenoiser-op7/actions/workflows/op7-build.yml/badge.svg)](https://github.com/rajbhx/deepdenoiser-op7/actions/workflows/op7-build.yml)
[![CI](https://github.com/rajbhx/deepdenoiser-op7/actions/workflows/ci.yml/badge.svg)](https://github.com/rajbhx/deepdenoiser-op7/actions/workflows/ci.yml)
[![Upstream Check](https://github.com/rajbhx/deepdenoiser-op7/actions/workflows/upstream-check.yml/badge.svg)](https://github.com/rajbhx/deepdenoiser-op7/actions/workflows/upstream-check.yml)

**DeepDenoiser OP7** builds [DeepDenoiser](https://github.com/sayampy/deepdenoiser)
(Expo 55 / React Native 0.83 + ONNX Runtime DeepFilterNet3 + Kotlin MediaCodec)
for the **OnePlus 7** — arm64-v8a only, Android 10 compatible, built entirely on
free GitHub Actions. It is not a fork of the app: the OP7 layer is a thin,
documented, auto-synced patch layer over a pinned upstream commit.

| Layer | What it does |
|---|---|
| Pinned upstream | exact commit in `upstream/commit.txt`, never a moving branch |
| Overrides | `overrides/bun.lock` — pinned dependency lockfile (upstream ships none) |
| OP7 patch set | `patches/op7/` — r1: none required (upstream already arm64-only) |
| GitHub Actions | `op7-build.yml` build+validate, `upstream-check.yml` daily, `ci.yml` cheap lint, `maintenance.yml` monthly |
| Fails closed | upstream conflict or failed gate = no build, no publish |

## Status

| Revision | Content | Status |
|---|---|---|
| **r1** | Unmodified upstream baseline, reproducible (pinned lockfile), arm64-v8a APK via GitHub Actions | ✅ this revision |
| r2+ | One measured optimization per revision (see `docs/optimization.md`) | 🔄 planned |

## Device facts (verified on this OnePlus 7)

```
Model     GM1901        SoC     Snapdragon 855 (SM8150)
Android   10 (API 29)   GPU     Adreno 640
ABI       arm64-v8a     RAM     8 GB
```

## Quick start

- **Get the latest APK**: `Actions → OP7 Build → workflow_dispatch` (defaults =
  pinned upstream, fast build), or grab the `op7-signed-*` artifact.
- **Manual dispatch**:
  `gh workflow run op7-build.yml -f fast=true -f release=false`
- **Release build** (R8, needs release secrets): `-f release=true -f fast=false -f release_tag=op7-1.4.3-r1`

See `docs/build.md` for the full pipeline and `docs/benchmarking.md` for
on-device measurement instructions (you test manually; we never claim numbers
we did not measure).
