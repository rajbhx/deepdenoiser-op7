# Optimization — DeepDenoiser OP7

Playbook rule: **one measured optimization per revision**; baseline first;
revert on regression. r1 is the compatibility baseline — no optimization claimed.

## Candidate list (NOT applied — each needs an on-device baseline first)

| ID | Change | Hypothesis | Metric | Risk |
|---|---|---|---|---|
| OP7-OPT-001 | Make ONNX `intraOpNumThreads` configurable (2 → 3/4) | SD855 big cores may sustain more intra-op parallelism | sustained latency, RTF, CPU% | thread thrash, thermal |
| OP7-OPT-002 | Try XNNPACK or NNAPI EP on CPU fallback path | possibly faster on SD855 NPU/CPU | latency, power | numeric drift — must verify output parity |
| OP7-OPT-003 | Reuse `InferenceSession` across denoise jobs (already reused?) | avoid repeated model load (13 MB) | first-export latency | memory retention |
| OP7-OPT-004 | Buffer-size / copy audit in AudioProcess + Kotlin module | fewer allocs/copies | RTF, peak memory | — |
| OP7-OPT-005 | Audio thread affinity / MediaCodec settings for SD855 | codec pipeline efficiency | RTF, thermal | complexity |

## Decision template (use for every revision)

```
Revision: OP7-OPT-00X
Change:
Hypothesis:
Baseline:
After:
Result: PASS / FAIL
Regression:
Decision: KEEP / REVERT
```

## Rules

- No change without an on-device before/after using the same input files
  (`docs/benchmarking.md`); label data "contended" when the device was in use.
- CPU-only inference stays the default until a measured EP wins with output parity.
- Never trade functionality for a benchmark.
