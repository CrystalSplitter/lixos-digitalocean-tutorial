# ./flake.nix
{
  description = "Tutorial on making a 'NixOS' VPS image.";
  inputs = {
    # NOTE: Change the SHA to "nixos-unstable" for your version. I try to pin things
    # to known working commits whenever possible.
    nixpkgs.url = "github:NixOS/nixpkgs/6eac218f2d3dfe6c09aaf61a5bfa09d8aa396129";
    nixos-generator = {
      url = "github:nix-community/nixos-generators/d002ce9b6e7eb467cd1c6bb9aef9c35d191b5453";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs.url = "github:serokell/deploy-rs";
  };
  outputs =
    { self, nixpkgs, ... }@flakeInputs:
    let
      system = "x86_64-linux";
      modules = [
        {
          # Pin nixpkgs to the flake input.
          nix.registry.nixpkgs.flake = nixpkgs;
          virtualisation.diskSize = 8 * 1024; # 8GiB
        }
        ./configuration.nix
      ];
    in
    {
      packages.${system} = {
        digitalOceanVM = flakeInputs.nixos-generator.nixosGenerate {
          inherit system;
          inherit modules;
          format = "do"; # DigitalOcean
        };
      };

      nixosConfigurations.myDigitalOceanDroplet = nixpkgs.lib.nixosSystem {
        inherit system;
        inherit modules;
      };

      deploy.nodes = {
        myDigitalOceanDroplet = {
          # Don't forget to set your hostname appropriately!
          hostname = "dodroplet";
          sshUser = "lixy";
          profiles.system = {
            user = "root";
            path =
              flakeInputs.deploy-rs.lib.${system}.activate.nixos
                self.nixosConfigurations.myDigitalOceanDroplet;
          };
        };
      };

      checks = builtins.mapAttrs (
        system: deployLib: deployLib.deployChecks self.deploy
      ) flakeInputs.deploy-rs.lib;
    };
}
