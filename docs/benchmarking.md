# Benchmarking — DeepDenoiser OP7 (manual, on the real device)

All measurement happens on the OnePlus 7 by the user. Reproducible inputs:

- fixtures: `media-fixtures/` — keep 10 s, 60 s, 5 min audio (16-bit 44.1 kHz
  WAV/MP3) and one short video, identical across runs (see also the
  iceraven-op7 repo's fixture workflow).
- Record: input duration, processing duration, real-time factor (RTF =
  processing/input), CPU% (top/`dumpsys cpuinfo`), peak memory
  (`dumpsys meminfo <pkg>`), APK size, model size; temperature if measurable
  (`dumpsys thermalservice` on OP7).

## Procedure

1. Cold start: force-stop app, relaunch, time to interactive UI (label COLD).
2. Import fixture → denoise → export; record timings and memory.
3. Repeat 3×; report median; label "contended" if the device was in use.
4. Compare across revisions ONLY with identical fixtures and device state.

## What we need from you (to drive r2+)

- the baseline numbers above for the r1 APK (`op7-signed-*` artifact), and
- the export's output parity check (sounds right, no artifacts).

Then we implement exactly ONE candidate from `docs/optimization.md`, ship a new
revision, and you re-measure. Numbers that are not measured are not claimed.
