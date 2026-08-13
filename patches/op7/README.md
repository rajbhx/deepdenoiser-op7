# OP7 patch set — deepdenoiser

Applied in filename order over the pinned upstream commit (`upstream/commit.txt`).

| Patch | Change | Reason | Baseline | Result | Status |
|---|---|---|---|---|---|
| `001-release-inference-session.patch` | release the ONNX `InferenceSession` in `finally` after every denoise job | upstream leaks one 13 MB ORT session per job (recording flow releases; processing flow did not) — memory grows across repeated denoises on OP7 | upstream 531b8a8 (leak present) | patch applies cleanly; CI build + badging green | KEEP |
| (lockfile, not a patch) | `overrides/bun.lock` pin | upstream ships no lockfile; reproducibility | no lock | frozen installs in CI | KEEP |

Every future optimization follows `docs/optimization.md` (one measured change per revision).
