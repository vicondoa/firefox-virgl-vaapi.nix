# AGENTS.md

Operating guide for AI coding agents and humans working on
`vicondoa/firefox-virgl-vaapi.nix`.

## Purpose

This repository packages Firefox for virgl/virtio-gpu VA-API experiments using
Nix. It composes `vicondoa/virgl-vaapi-compat` and exposes a wrapped package that
installs the normal `bin/firefox` command.

## Build and test

```bash
nix flake check --show-trace
nix build .#packages.x86_64-linux.firefox --no-link
```

Also verify:

```bash
out=$(nix build .#packages.x86_64-linux.firefox --no-link --print-out-paths)
test -x "$out/bin/firefox"
test ! -e "$out/bin/firefox-virgl"
test ! -e "$out/bin/firefox-virgl-vaapi"
```

## Contribution workflow

After initial repository bootstrap, nobody direct-pushes to `main`. GitHub's
required approval count is intentionally 0 so the solo maintainer can merge
their own PR after CI and any required panel sign-off. All changes use this
flow:

1. Create a topic branch.
2. Run local validation.
3. Open a pull request.
4. Wait for required CI and conversation resolution.
5. Squash-merge after required checks and any panel requirements are met.

## 8-reviewer panel sign-off policy

Non-trivial plan-driven or multi-phase work requires unanimous 8/8 panel approval
at each phase boundary. Each reviewer returns JSON with `engineer`, `signoff`,
`summary`, and `recommendations`. `signoff: true` is valid only when
`recommendations` is empty.

## Branch protection expectation

Protect `main` after bootstrap: require PRs, required CI, resolved
conversations, no force-pushes, no branch deletion, and no direct pushes for
anyone. Keep GitHub-native required approval count at 0 for solo-maintainer
self-merge; non-trivial plan-driven work still requires panel sign-off before
merge.
