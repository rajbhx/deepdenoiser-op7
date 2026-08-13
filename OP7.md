# OP7 engineering record — DeepDenoiser

Playbook: `rajbhx/op7-special-build-playbook`. Skill: `op7-special-build`.
Target: OnePlus 7 (GM1901, Snapdragon 855, Adreno 640, arm64-v8a, Android 10/API 29, 8 GB).

## Change log (one optimization per revision)

| Change | Reason | Baseline | Result | Status |
|---|---|---|---|---|
| r1: none (unmodified upstream) | Level 0/1 compatibility baseline; upstream already targets arm64-v8a, minSdk 24, NDK 28.1 | upstream 531b8a8… | APK builds in CI, badging passes | KEEP |
| r1: `overrides/bun.lock` pin | upstream ships no lockfile; pin deps for reproducibility | no lock | frozen installs in CI | KEEP |
| r2 (planned) | ONNX thread tuning / EP selection | on-device baseline required | — | pending |

## Compatibility matrix (OP7 / Android 10)

| Area | Upstream value | OP7 assessment |
|---|---|---|
| ABI | `arm64-v8a` only (`buildArchs`) | ✅ matches OP7 |
| minSdk | 24 | ✅ Android 10 (29) ≥ 24 |
| targetSdk | 36 | ✅ runs on Android 10 (scoped storage enforced — app uses SAF pickers/media library, no raw path access needed) |
| compileSdk / NDK | 36 / 28.1.13356709 (r28b) | ✅ standard toolchain |
| ONNX Runtime | onnxruntime-react-native 1.24.3, CPU EP, intra 2 / inter 1 threads | ✅ CPU-only avoids Adreno/NNAPI variance; tuning deferred to measured r2 |
| Model | `denoiser_model.ort` 13.0 MB, asset-packaged | ✅ no download at runtime |
| MediaCodec | Kotlin module: extract → denoise (Litr transcode + PCM) | ✅ API 29 codec paths; HW decode verified on this device (playbook) |
| Storage | document-picker / media-library / FileProvider | ✅ Android 10 scoped-storage compliant |
| Permissions | RECORD_AUDIO, READ/WRITE_EXTERNAL_STORAGE, FGS media playback | ✅ runtime-permission flow present; WRITE_EXTERNAL_STORAGE is a no-op on API 29+ (harmless) |
| Background | expo-audio background recording (FGS) | ✅ Android 10 allows FGS audio recording |
| Build | Expo 55 / RN 0.83 / AGP 8.x / Java 17 / bun | ✅ proven combo (upstream workflow) |

## Known upstream quirks (documented, not changed)

- `modules/AudioProcessorModule/android/build/` (generated artifacts) is committed upstream — harmless, ignored by Gradle.
- onnxruntime-react-native resolves `onnxruntime-android` via `latest.integration` Maven — pinned by lockfile? No: Maven, not npm. Tracked as reproducibility risk; revisit if a measured regression appears.
- patch-package applies `expo-modules-core` + `onnxruntime-react-native` patches at install time (16 KB page-size link flags etc.) — preserved exactly.

## Optimization levels

- **L0 compatibility** — done (r1): build + install + launch expected.
- **L1 stability** — r1 APK passes structural gates; on-device smoke test is yours.
- **L2 performance** — only after your on-device baseline (see `docs/benchmarking.md`); candidates are listed in `docs/optimization.md`.
