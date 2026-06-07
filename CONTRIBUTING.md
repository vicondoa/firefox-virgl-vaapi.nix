# Contributing

Use branches and pull requests for all changes after initial bootstrap. Run local
validation before opening a PR and use squash merge after CI and any required
panel sign-off. GitHub's required approval count is intentionally 0 so the solo
maintainer can merge their own PR after checks pass.

## Local validation

```bash
nix flake check --show-trace
nix build .#packages.x86_64-linux.firefox --no-link
```

Verify the package exposes only the standard Firefox command:

```bash
out=$(nix build .#packages.x86_64-linux.firefox --no-link --print-out-paths)
test -x "$out/bin/firefox"
test ! -e "$out/bin/firefox-virgl"
test ! -e "$out/bin/firefox-virgl-vaapi"
```

## Pull requests

PRs should include a summary, validation performed, compatibility impact, and
panel status for non-trivial plan-driven work.
