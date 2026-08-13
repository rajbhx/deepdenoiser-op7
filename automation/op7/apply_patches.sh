#!/usr/bin/env bash
# Apply the OP7 build layer to a fresh upstream checkout.
#   OP7_LAYER_DIR=/path/to/deepdenoiser-op7 automation/op7/apply_patches.sh
# Run from the upstream checkout root. Copies build-config overrides first
# (pinned lockfile), then applies patches/op7/NNN-*.patch in order.
# Never auto-resolves conflicts: on failure it exits non-zero with a report and
# the pipeline stops before any build or publish step.
set -euo pipefail

OP7_LAYER_DIR="${OP7_LAYER_DIR:?set OP7_LAYER_DIR to the deepdenoiser-op7 checkout}"

# 1) Build-config overrides (reproducibility layer, not source patches)
if [[ -d "$OP7_LAYER_DIR/overrides" ]]; then
  for f in "$OP7_LAYER_DIR"/overrides/*; do
    [[ -e "$f" ]] || continue
    base="$(basename "$f")"
    if [[ "$base" == "bun.lock" ]]; then
      cp "$f" ./bun.lock
      echo "==> overrode $base (pinned dependency lockfile)"
    else
      echo "==> skipping unknown override: $base"
    fi
  done
fi

# 2) OP7 patches
PATCH_DIR="$OP7_LAYER_DIR/patches/op7"
if [[ ! -d "$PATCH_DIR" ]]; then
  echo "no patch directory: $PATCH_DIR (nothing to apply)"
  exit 0
fi

FAILED=0
for patch in "$PATCH_DIR"/*.patch; do
  [[ -e "$patch" ]] || continue
  echo "==> applying $patch"
  if ! git apply --check "$patch" 2> /tmp/op7-check.err; then
    echo "!! CONFLICT with $patch" >&2
    cat /tmp/op7-check.err >&2
    FAILED=1
    continue
  fi
  git apply "$patch"
  echo "    ok"
done

if [[ "$FAILED" -ne 0 ]]; then
  cat << REPORT >&2
======================== OP7 PATCH CONFLICT ========================
upstream commit : $(git rev-parse HEAD 2>/dev/null || echo unknown)
failing patch   : see messages above
conflict files  : git apply --check output above
last known-good : see GitHub Releases (op7-* tags)
maintenance     : rebase the failing patch onto the new upstream HEAD,
                  verify the root cause, and re-run validation.
Policy          : automatic publishing is STOPPED. No build, no release.
=====================================================================
REPORT
  exit 1
fi

echo "all OP7 patches applied cleanly"
