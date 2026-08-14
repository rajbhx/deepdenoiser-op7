# Session digest — 2026-08-14 — OP7 build setup (DeepDenoiser)

Brought the upstream DeepDenoiser (Expo/RN + ONNX Runtime + Kotlin MediaCodec)
to a GitHub-Actions-only OP7 pipeline: pinned upstream commit 531b8a8b, thin
patch layer, expo prebuild + plain gradle, stable debug keystore, badging gate.

## Problems solved
- **P** upstream deepdenoiser ships no dependency lockfile
  cause: bun.lockb/bun.lock gitignored upstream (expo/rn convention)
  solution: pin deps in overrides/bun.lock copied into the CI mirror before bun install --frozen-lockfile
  section: A
  tags: [reproducibility, expo, bun, lockfile]
- **P** eas build --local requires EAS project ownership/token, unavailable to a new build repo
  cause: upstream CI depends on EAS cloud credentials
  solution: replace eas with expo prebuild + plain gradle assemble in the OP7 pipeline; no EAS dependency
  section: A
  tags: [ci, expo, eas, github-actions]
- **P** ONNX runtime native libs require matching NDK/ABI or gradle fails
  cause: onnxruntime-react-native builds JNI via CMake; arm64-v8a only
  solution: mirror upstream proven combo (Java 17 + NDK r28b + app.json buildArchs arm64-v8a); badging gate checks lib/arm64-v8a
  section: A
  tags: [onnx, ndk, arm64, badging]
- **P** deepdenoiser CI build fails compiling @siteed/audio-studio (Promise.reject override mismatch)
  cause: fresh bun.lock resolved siteed 3.2.1; its reject(String?,...) no longer matches expo-modules-core Promise.reject(String,...); upstream patch-package patches target 3.0.3
  solution: pin @siteed/audio-studio to 3.0.3 in overrides/bun.lock; verify compile passes
  section: A
  tags: [onnx, build, siteed, lockfile, compile-error]
- **P** android 10 install can fail on testOnly or signature mismatch
  cause: injected testOnly flag / per-build debug keystore
  solution: aapt badging gate rejects testOnly; stable DEBUG_SIGNING_KEY secret for consistent signatures
  section: B
  tags: [android10, install, testonly, signing]
- **P** repeated denoise jobs grow memory on OP7 (one InferenceSession leaked per job)
  cause: process.tsx handleDenoise creates a DeepFilterNet and never calls release(); recording flow already releases via ref
  solution: OP7 patch 001 - declare denoiser outside try, release() in finally (session is null-safe)
  section: B
  tags: [memory-leak, onnx, stability, patch-001]

## Notes (optional)
- onnxruntime-react-native version comes from upstream package.json; do not bump blindly on OP7.
- MediaCodec path is Kotlin native (expo-modules) — no changes needed for API 29 baseline.
