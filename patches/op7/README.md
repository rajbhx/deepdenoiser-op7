# OP7 patch set — deepdenoiser

Applied in filename order over the pinned upstream commit (`upstream/commit.txt`).
r1 (op7r1): **no source changes required** — upstream already targets arm64-v8a,
minSdk 24 (Android 10 OK), and builds cleanly. The pipeline only adds a pinned
lockfile (see `overrides/bun.lock`) for reproducible dependency resolution.

| Patch | Change | Reason | Baseline | Result | Status |
|---|---|---|---|---|---|
| (none, r1) | unmodified upstream + lockfile pin | reproducible builds | — | — | KEEP |

Future revisions add one measured optimization per revision (see `docs/optimization.md`).
