# Troubleshooting — DeepDenoiser OP7

Search the playbook notes first: `python3 scripts/lookup.py <problem words>`.

## Known failure modes

| Symptom | Likely cause | Fix |
|---|---|---|
| "App not installed" on Android 10 | `testOnly=true` in badging, or signature mismatch across builds | validation gate rejects testOnly; use `op7-signed-*` artifact (stable debug key) |
| Gradle can't find NDK 28.1.13356709 | NDK not installed on runner | `nttld/setup-ndk` with `ndk-version: r28b` (proven upstream) |
| `bun install` non-reproducible | upstream has no lockfile | `overrides/bun.lock` copied by `apply_patches.sh`; install with `--frozen-lockfile` |
| ONNX session null at runtime | `withOnnxruntime` plugin registration missed after prebuild | verify `MainApplication.kt` has `OnnxruntimePackage()`; re-run prebuild cleanly |
| Patch conflict after upstream update | upstream changed patched files | stop, report, rebase patch; never force |
| Slow builds | R8/assembleRelease, cold caches | use `fast=true` for iteration; keep caches warm |
| Scoped storage errors on Android 10 | raw path access | use picker/content:// URIs (upstream does) |

## On-device install

```bash
adb install -r <op7-signed-*.apk>     # or via Shizuku/pm on the device
# verify:
adb shell dumpsys package com.sayampy.deepdenoiser | head
```

If something is genuinely new and solved here, record it in
`docs/field-notes/log.yml` (playbook loop) so the knowledge stays searchable.
