# AGENTS.md — DeepDenoiser OP7 build repo

Produces a OnePlus 7–optimized DeepDenoiser APK (Expo/React Native + ONNX Runtime
DeepFilterNet3 + Kotlin MediaCodec), arm64-v8a only, built on free GitHub Actions.
Upstream: `sayampy/deepdenoiser`. OP7 changes live ONLY in `patches/op7/NNN-*.patch`
(applied in order); r1 = unmodified upstream baseline.

## Before doing anything

- Load the `op7-special-build` skill.
- Search the playbook notes before inventing: `python3 scripts/lookup.py <words>`
  in a clone of `rajbhx/op7-special-build-playbook`.

## Hard rules (from the field, apply to this repo)

- Baseline before optimization; measure on the real device (user tests manually);
  label data "contended" if the device was in use.
- One measured optimization per revision (`op7-revision.txt`, `op7r<N>`); revert on regression.
- Iteration builds: dispatch with `-f fast=true` (assembleDebug, no R8). Release
  builds (~R8 minify) only when ready.
- Never publish an unvalidated build; a patch conflict stops the pipeline.
- Never commit APKs, keystores, or node_modules (`.gitignore` covers them).
- Never run Android builds locally — everything runs on GitHub Actions.

## Recording lessons

1. `docs/field-notes/sessions/<date>-<topic>.md` (template in playbook): problem/cause/solution/tags.
2. Append `docs/field-notes/log.yml` (same schema as iceraven-op7; one line per field).
3. Commit + push — the playbook sync workflow regenerates the searchable notes.
