{ config, pkgs, ... }:
let
  nvchad = pkgs.callPackage ./xfreerdp.nix {};
in
{
  home.packages = [ xfreerdp ];
}
