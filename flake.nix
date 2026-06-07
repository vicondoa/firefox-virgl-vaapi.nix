{
  description = "Firefox wrapper for virgl/virtio-gpu VA-API video decode";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/331800de5053fcebacf6813adb5db9c9dca22a0c";
    virgl-vaapi-compat = {
      url = "github:vicondoa/virgl-vaapi-compat";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, virgl-vaapi-compat }:
    let
      lib = nixpkgs.lib;
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f: lib.genAttrs systems (system: f system);
      pkgsFor = system: import nixpkgs {
        inherit system;
        overlays = [ self.overlays.default ];
      };
    in
    {
      overlays.default = final: prev: {
        virgl-vaapi-compat = prev.callPackage "${virgl-vaapi-compat}/nix/package.nix" { };

        wrapFirefoxVirglVaapi = args:
          final.callPackage ./nix/firefox-wrapper.nix ({
            virgl-vaapi-compat = final.virgl-vaapi-compat;
          } // args);

        firefox = final.wrapFirefoxVirglVaapi {
          firefox = prev.firefox;
          aliasName = "firefox";
        };
      };

      packages = forAllSystems (system:
        let pkgs = pkgsFor system;
        in {
          default = pkgs.firefox;
          firefox = pkgs.firefox;
        });

      checks = forAllSystems (system:
        let pkgs = pkgsFor system;
        in {
          default = pkgs.runCommand "firefox-virgl-vaapi-check" { } ''
            set -eu
            mkdir -p "$out"
            test -x ${pkgs.firefox}/bin/firefox
            test ! -e ${pkgs.firefox}/bin/firefox-virgl
            test ! -e ${pkgs.firefox}/bin/firefox-virgl-vaapi
            test ! -e ${pkgs.firefox}/bin/firefox.virgl-vaapi-original
            test ! -e ${pkgs.firefox}/bin/.firefox-wrapped
            find ${pkgs.firefox}/lib -path '*/distribution/policies.json' -print -quit | grep -q .
            find ${pkgs.firefox}/lib -path '*/glxtest' -type f -perm -0100 -print -quit | grep -q .
            ln -s ${pkgs.firefox} "$out/firefox"
          '';
        });

      devShells = forAllSystems (system:
        let pkgs = pkgsFor system;
        in {
          default = pkgs.mkShell {
            packages = with pkgs; [ jq nixpkgs-fmt ];
          };
        });

      lib = {
        wrapFirefoxVirglVaapi = import ./nix/firefox-wrapper.nix;
      };
    };
}
