# Nix usage

Build the wrapped Firefox package:

```bash
nix build github:vicondoa/firefox-virgl-vaapi.nix#firefox
```

## Public outputs

| Output | Purpose |
| --- | --- |
| `packages.<system>.firefox` / `packages.<system>.default` | Wrapped Firefox package exposing `bin/firefox`. |
| `checks.<system>.default` | Verifies `bin/firefox` exists, `firefox-virgl*` aliases do not exist, policies are installed, and the `glxtest` stub exists. |
| `overlays.default` | Self-contained overlay that brings in the generic shim package and replaces `pkgs.firefox` with the wrapped package built from `prev.firefox`. |
| `lib.wrapFirefoxVirglVaapi` | Importable wrapper function for advanced downstream composition. Its arguments match `nix/firefox-wrapper.nix`; the stable arguments are `firefox`, `virgl-vaapi-compat`, `aliasName`, `firefoxBinary`, `renderNode`, `renderer`, `glVersion`, `extraEnv`, `lockedPreferences`, and `extraPolicies`. |

Use the overlay when composing with an existing nixpkgs instance:

```nix
{
  inputs.firefox-virgl-vaapi.url = "github:vicondoa/firefox-virgl-vaapi.nix";
  inputs.firefox-virgl-vaapi.inputs.nixpkgs.follows = "nixpkgs";
}
```

The overlay replaces `pkgs.firefox` with the wrapped package using `prev.firefox`
as the underlying browser to avoid recursive wrapping. It is self-contained and
also provides `pkgs.virgl-vaapi-compat` from the generic shim input. Do not also
install a stock Firefox package in the same profile, because both packages
provide `bin/firefox`.

The wrapper accepts the extra arguments that the NixOS `programs.firefox` module
passes through `.override`, including `extraPrefsFiles`, `nativeMessagingHosts`,
and `cfg`. That lets downstream modules install native messaging hosts and
extension policies while preserving the VA-API wrapper.
