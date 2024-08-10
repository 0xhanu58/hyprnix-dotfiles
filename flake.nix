{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";    # or "github:nixos/nixpkgs/nixos-24.05"
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Turn this on to enable Stylix
    stylix.url = "github:danth/stylix";

    # AGS
    # ags.url = "github:Aylur/ags";
  };

  outputs = { stylix, self, nixpkgs, home-manager, ... }@inputs:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
  {
    nixosConfigurations = {
      hypr-nix = lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix

          # Turn these on to enable Stylix
          stylix.nixosModules.stylix
          ./ricing/stylix/stylix.nix

          # Virtualization (qemu and docker)
          ./virtualization.nix

          # tools
          ./roles
        ];
      };
    };

    homeConfigurations = {
      hanu58 = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./home.nix
          ./apps # apps like NvChad, ags, librewolf (not integrated), vscodium
        ];
      };
    };
  };
}
