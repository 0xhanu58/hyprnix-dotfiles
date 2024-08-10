{ config, pkgs, ... }:
let
  nvchad = pkgs.callPackage ./nvchad.nix {};
in
{
  home.packages = [ nvchad ];

  # NvChad Configurations
  home.file.".config/nvim" = {
    source = "${nvchad}/";
    recursive = true;
  };
}
