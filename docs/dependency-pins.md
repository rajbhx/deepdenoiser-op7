# Dependency pins (build-config layer, not source patches)

## `@siteed/audio-studio` pinned to `3.0.3`

- **Where:** `overrides/bun.lock` (copied into the CI mirror before
  `bun install --frozen-lockfile` by `automation/op7/apply_patches.sh`).
- **Why:** `@siteed/audio-studio@3.0.4+` overrides
  `Promise.reject(code: String?, ...)` which no longer matches
  `expo-modules-core`'s `Promise.reject(code: String, ...)` interface,
  causing `Execution failed for task ':siteed-audio-studio:compileDebugKotlin'`.
  Upstream's patch-package patches target the 3.0.3 API surface.
- **Not a git patch:** this is a lockfile pin, so it lives under `overrides/`,
  not under `patches/op7/*.patch`. The OP7 CI never `git apply`s this.
- **Revisit when:** upstream updates its patch-package patches for a newer
  siteed, or releases a fix. Regenerate `overrides/bun.lock` from the new
  upstream tree and re-verify compile.
