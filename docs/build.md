# Build — DeepDenoiser OP7 (all builds run on GitHub Actions)

## Workflows

| Workflow | Trigger | Cost |
|---|---|---|
| `op7-build.yml` | `workflow_dispatch` (maintainers) | heavy (the only build) |
| `upstream-check.yml` | daily cron + dispatch + `repository_dispatch` | ~free (never builds) |
| `ci.yml` | push/PR | cheap (actionlint + shellcheck + pin checks) |
| `maintenance.yml` | monthly cron + dispatch | ~free (prunes artifacts/caches/runs) |

## Build pipeline (op7-build.yml)

1. Resolve upstream commit (input or `upstream/commit.txt`).
2. `git clone` upstream → `mirror/` (never a tracked dir).
3. Apply OP7 layer: `overrides/bun.lock` copy + `patches/op7/*.patch` via
   `automation/op7/apply_patches.sh` — any conflict **stops** the run.
4. `bun install --frozen-lockfile` (bun + Gradle caches).
5. `bunx expo prebuild --platform android --no-install` (generates `android/`).
6. Gradle: `fast=true` → `:app:assembleDebug` (no R8, ~10–15 min);
   `fast=false` → `:app:assembleRelease` (R8 minify, longer).
7. Validation gate (`automation/op7/validate_apk.sh`, aapt badging):
   package, min/target SDK, `native-code arm64-v8a`, `lib/arm64-v8a/` present,
   **not** `testOnly`, SHA-256 + metadata JSON.
8. Re-sign with stable debug key (secret `DEBUG_SIGNING_KEY`, if set) so
   reinstalls keep the same signature; upload artifacts (validation 7 d,
   signed 14 d).
9. `release=true` → dedicated release job under the `release` environment
   (secrets guarded; never visible to PRs/forks), publishes GitHub Release.

## Dispatch examples

```bash
# fast validation build of pinned upstream
gh workflow run op7-build.yml -f fast=true -f release=false

# build a specific upstream commit
gh workflow run op7-build.yml -f upstream_commit=<sha> -f fast=true

# full release (requires release env secrets + tag)
gh workflow run op7-build.yml -f fast=false -f release=true -f release_tag=op7-1.4.3-r1
```

## Free-tier hygiene

- arm64-only + `fast=true` keeps builds cheap; release builds are opt-in.
- Artifacts: 7/14-day retention; monthly maintenance prunes >14 d artifacts,
  caches, and old runs (500 MB / 10 GB limits).
- Upstream check never builds; every dispatch resets the scheduled-workflow window.
