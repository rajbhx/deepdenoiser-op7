# Architecture — DeepDenoiser OP7

## Upstream architecture (audited)

```
src/scripts/Denoiser.ts        DeepFilterNet3 streaming + batch inference (ONNX Runtime JS API)
src/scripts/AudioProcess.ts    audio pipeline orchestration (decode -> PCM -> denoise -> encode)
src/scripts/formatHandler.ts   format conversion / bitrate re-encoding (Litr via module)
modules/AudioProcessorModule   Expo native module (Kotlin): MediaExtractor/MediaCodec,
                               Litr transcode, denoise loop, MediaMuxer export
plugins/withOnnxruntime.js     config plugin: registers OnnxruntimePackage in MainApplication
plugins/withNdkVersion.js      NDK pinning for the ONNX JNI build
patches/*.patch                patch-package: ORT 16 KB page-size link flags + fbjni fix
assets/model/denoiser_model.ort  DeepFilterNet3 ORT model (13 MB, packaged asset)
```

## OP7 layer (this repo)

```
upstream source (pinned commit)
  -> overrides/bun.lock            dependency pinning (reproducibility)
  -> patches/op7/NNN-*.patch       OP7 source changes (r1: none)
  -> GitHub Actions                mirror -> apply -> install -> prebuild -> gradle -> validate
  -> validated arm64-v8a APK
```

## Inference path (as upstream ships)

1. Model loaded from bundled asset via `InferenceSession.create(modelPath, {executionProviders:["cpu"], graphOptimizationLevel:"all", intraOpNumThreads:2, interOpNumThreads:1})`.
2. Streaming frames (hopSize) fed through `states` tensors; output frames written back.
3. Audio: MediaExtractor → PCM (Float32) → denoise → Litr/MediaCodec re-encode → MediaMuxer.
4. Export via FileProvider/expo-sharing (scoped storage safe).

## OP7 invariants

- Never replace ONNX/MediaCodec with anything else; never touch model weights.
- Keep CPU EP until a measured alternative (NNAPI/XNNPACK) wins on-device.
- One measured optimization per revision; every change lands as a documented patch.
