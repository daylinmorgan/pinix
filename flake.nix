{
  description = "Progress In Nix - Pacman inspired frontend for Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    self,
    nixpkgs,
    systems,
  }: let
    inherit (nixpkgs.lib) genAttrs;
    eachSystem = f:
      genAttrs (import systems)
      (system:
        f system
        (import nixpkgs {
          inherit system;
          overlays = [self.overlays.default];
        }));
  in {
    overlays = {
      default = final: _prev: {
        pinix = final.callPackage ./default.nix {};
      };
    };
    packages = eachSystem (system: (pkgs: {
      pinix = pkgs.pinix;
      default = self.packages.${pkgs.system}.pinix;
    }));

      };
  };
}
