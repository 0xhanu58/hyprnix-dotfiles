{ config, lib, pkgs, ... }:

let
  librewolfPath = "${pkgs.librewolf}/bin/librewolf";
  pkillPath = "${pkgs.procps}/bin/pkill";
in
{
  
  programs.librewolf = {
    enable = true;
    settings = {
      "privacy.clearOnShutdown.history" = false;
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "network.dns.disableIPv6" = true;
      "identity.fxaccounts.enabled" = true;
    };
  };

  home.file.".librewolf/chrome/userChrome.css".text = "
    .tabbrowser-tab {
      visibility: collapse;
    }
    .titlebar-button {
      height: 27px !important;
    }
    #nav-bar {
      margin-top: -38px;
      margin-right: 140px;
      box-shadow: none !important;
    }

    [uidensity=\"compact\"]:root .titlebar-button {
      height: 32px !important;
    }
    [uidensity=\"compact\"]:root #nav-bar {
      margin-top: -32px;
    }

    #titlebar-spacer {
      background-color: var(--chrome-secondary-background-color);
    }
    #titlebar-buttonbox-container {
      background-color: var(--chrome-secondary-background-color);
    }
    .titlebar-color {
      background-color: var(--toolbar-bgcolor);
    }

    #main-window[inFullscreen=\"true\"] #sidebar-box,
    #main-window[inFullscreen=\"true\"] #sidebar-box + splitter {
        visibility: collapse;
    }

    #sidebar-box #sidebar-header {
      display: none !important;
    }
  ";

  home.file.".librewolf/editCSS.sh".text = "
    #!/bin/sh
    librewolf &

    while true; do
      SOME_DIR=$(find ~/.librewolf/ -name \"*.default\" -print -quit)
      if [ -n \"$SOME_DIR\" ]; then
        break
      fi 
      sleep 1 
    done

    pkill librewolf

    cp -r ~/.librewolf/chrome/ $SOME_DIR   
  ";

  home.activation.postActivation = "
    #!/bin/sh
    ${librewolfPath} &

    while true; do
      SOME_DIR=$(find ~/.librewolf/ -name \"*.default\" -print -quit)
      if [ -n \"$SOME_DIR\" ]; then
        break
      fi
      sleep 1
    done

    ${pkillPath} librewolf

    cp -r ~/.librewolf/chrome/ $SOME_DIR  
  ";
}
