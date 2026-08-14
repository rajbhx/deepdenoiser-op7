# Conversation knowledge — 2026-08-14 — OP7 build setup

- thread: `codex-session-op7-port`
- cwd: remote (cloud)
- user messages: many | kept: useful types only

## Extracted knowledge (types)

- `[GOAL]` Build and maintain OnePlus 7-optimized editions of DeepDenoiser and Rain using original upstream source code
- `[RULE]` Never build Android locally - use GitHub Actions free infrastructure only
- `[RULE]` Playbook (op7-special-build-playbook) is the mandatory source of truth for the engineering process
- `[RULE]` Baseline first; measure before optimizing; one measurable optimization per revision
- `[RULE]` Keep customizations in a thin patch layer; never fork upstream unnecessarily
- `[RULE]` Never publish an unvalidated build; never commit signing keys or large binaries
- `[RULE]` Use free GitHub infrastructure only (Actions, Releases, caches)
- `[DECISION]` Create two new public repos: rajbhx/deepdenoiser-op7 and rajbhx/rain-op7
- `[DECISION]` Pin upstream commits instead of tracking latest; sync via playbook auto-update workflow
- `[REQUEST]` Register both projects in the playbook and keep it auto-synced
- `[REQUEST]` Update the op7-special-build skill with learned knowledge
- `[REQUEST]` Modify patches according to OP7 device specifics for rainManager + rain bundle
- `[GOTCHA]` Playbook sync crashed on flat-list field-notes logs; canonical shape is sections>entries
- `[GOTCHA]` Iceraven log had double-bracket tags (YAML nesting) that broke keyword derivation
