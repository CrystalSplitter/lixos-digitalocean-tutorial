# ./flake.nix
{
  description = "Tutorial on making a 'NixOS' VPS image.";
  inputs = {
    # NOTE: Change the SHA to "nixos-unstable" for your version. I try to pin things
    # to known working commits whenever possible.
    nixpkgs.url = "github:NixOS/nixpkgs/6eac218f2d3dfe6c09aaf61a5bfa09d8aa396129";
  };
  outputs =
    { self, nixpkgs, ... }@flakeInputs:
    let
      system = "x86_64-linux";
    in
    { };
}
