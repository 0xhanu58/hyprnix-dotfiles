{ config, pkgs, ... }:
let
  nvchad = pkgs.callPackage ./nvchad.nix {};
  vscodium = import ./vscodium;
in
{
  imports = [ vscodium ];
  home.packages = [ nvchad ];

  # NvChad Configurations
  home.file.".config/nvim" = {
    source = "${nvchad}/";
    recursive = true;
  };
}
