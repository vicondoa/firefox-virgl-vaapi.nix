# firefox-virgl-vaapi.nix

`firefox-virgl-vaapi.nix` packages Firefox with the VA-API/DMABUF settings needed
for virgl/virtio-gpu video decode experiments. It composes the generic
[`virgl-vaapi-compat`](https://github.com/vicondoa/virgl-vaapi-compat) libva
shim and exposes a wrapped Firefox package that still installs the standard
`bin/firefox` command.

The repo is Nix-specific. The generic libva shim lives in
`vicondoa/virgl-vaapi-compat`; this repo owns only Firefox-specific integration:
locked Firefox policies, scoped `LIBVA_*` environment, and a virgl `glxtest`
stub.

## Outputs

```bash
nix build github:vicondoa/firefox-virgl-vaapi.nix#firefox
nix flake check github:vicondoa/firefox-virgl-vaapi.nix
```

Public flake outputs:

| Output | Purpose |
| --- | --- |
| `packages.<system>.firefox` / `packages.<system>.default` | Wrapped Firefox package exposing `bin/firefox`. |
| `checks.<system>.default` | Verifies the package shape, policies, and `glxtest` stub. |
| `overlays.default` | Self-contained overlay that adds `virgl-vaapi-compat`, `wrapFirefoxVirglVaapi`, and replaces `pkgs.firefox` with the wrapped package. |
| `lib.wrapFirefoxVirglVaapi` | Importable wrapper function for downstream flakes that need direct control over arguments. |

The package installs `bin/firefox`. It intentionally does not install
`firefox-virgl` or `firefox-virgl-vaapi` command aliases; downstream systems that
use this package should make it the only Firefox provider in the profile.

## Documentation

- [`docs/how-it-works.md`](docs/how-it-works.md)
- [`docs/debugging.md`](docs/debugging.md)
- [`docs/nix.md`](docs/nix.md)
- [`docs/troubleshooting.md`](docs/troubleshooting.md)
- [`docs/removal-criteria.md`](docs/removal-criteria.md)

## License

Apache-2.0. See [`LICENSE`](LICENSE).
