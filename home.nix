{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.username = "hanu58";
  home.homeDirectory = "/home/hanu58";

  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
    
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    spotify
    cava
    spicetify-cli
  ];

  
  #home.file = {
  #};
  
  
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  

  programs.home-manager.enable = true;
}
