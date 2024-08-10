# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    useOSProber = true;
    enable = true;
    devices = [ "nodev" ];
    efiSupport = true;
  };
  
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';

  # Windows menu entery for GRUB
  #boot.loader.grub.extraEntries = ''
  #  menuentry "Windows" {
  #    insmod part_gpt
  #    insmod ntfs
  #    insmod search_fs_uuid
  #    search --no-floppy --fs-uuid --set=root 0E5E42D25E42B1EF
  #    chainloader /EFI/Mircosoft/Boot/bootmgfw.efi
  #  }
  #'';
  
  # udisks2 and polkit rule to allow mounting without sudo
#  services.udisks2.enable = true;
#  
#  environment.etc."polkit-1/rules.d/49-nopasswd-mount.rules".text = ''
#    polkit.addRule(function(action, subject) {
#      if ((action.id == "org.freedesktop.udisks2.filesystem-mount-system" ||
#           action.id == "org.freedesktop.udisks2.filesystem-mount" ||
#           action.id == "org.freedesktop.udisks2.filesystem-unmount-others" ||
#           action.id == "org.freedesktop.udisks2.filesystem-unmount") &&
#          subject.isInGroup("wheel")) {
#        return polkit.Result.YES;
#      }
#    });
#  '';


  networking.hostName = "hypr-nix"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # wireguard
  #networking.wg-quick.interfaces.wgprotonnl.configFile = "/etc/wireguard/wg0.conf";

  #networking.enableIPv6 = false;
  services.flatpak.enable = true;
  
  # openvpn
  services.resolved.enable = true; 

#  networking.extraHosts =''
#    10.129.174.241  trilocor.local dev.trilocor.local blog.trilocor.local portal.trilocor.local remote.trilocor.local store.trilocor.local careers.trilocor.local pr.trilocor.local securetransfer-dev.trilocor.local osticketapp.trilocor.local gogsusdev01.trilocor.local uat01-eu.intranet.trilocor.local
#     172.16.139.35  ms01  ms01.trilocor.local
#     172.16.139.3   dc01  dc01.trilocor.local
#  '';
  
  # htb machines
  networking.extraHosts =''
    10.10.11.17 mist.htb
    10.10.11.27 itrc.ssg.htb ssg.htb signserv.ssg.htb
  '';

  #networking.interfaces.enp3s0 = {
  #  ipv4.addresses = [ { address = "192.168.1.1"; prefixLength = 24; } ];
  #};

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-v24n.psf.gz";
    packages = with pkgs; [ terminus_font ];
    keyMap = "us";
  };


  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;
  # Enable Sound
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  
  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hanu58 = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    home = "/home/hanu58";
    packages = with pkgs; [
      librewolf 
      tree
      firefox 
    ];
  };  

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vesktop
    qview
    wget
    git
    alacritty
    ranger
    hyprland
    waybar
    wofi
    dunst
    libnotify
    wl-clipboard
    cliphist
    wf-recorder
    btop
    tldr
    swww
    coreutils
    # Languages
    python3
    pipx
    perl
    rustc
    rustup
    libgcc
    nodejs_22
    cargo
    php
    go
    ruby
    unzip
    gcc
    clang
    # screenshare
    grim
    slurp
    swappy
    mpv
    # (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    # noto-fonts-emoji
    # noto-fonts
    # noto-fonts-cjk
    # font-awesome
    wayvnc # vnc for wayland
    networkmanagerapplet
    ntfs3g # installs kernel module for ntfs
    cifs-utils # smb things
    rsync # fast file transfers
    # acpilight # brightness control alternative
    brightnessctl # works best
    alsa-utils
    fastfetch
    pavucontrol
    papirus-icon-theme
    gnome-themes-extra
    update-systemd-resolved
    openvpn
    netcat-gnu
    wireguard-tools
    gparted # gnome 
    gptfdisk # for gpt partitions
    dmidecode # reads hardware from bios, `dmidecode --type memory`
    obsidian
    jdk11 # for burpsuite
    seclists
    inetutils
    file
    openssl
    remmina
    xorg.xhost
    # tools
    rlwrap
    smbmap
    php83Extensions.smbclient
    netexec
    nfs-utils
    neo4j
    go
    sshpass
    xdg-utils
    obs-studio
    lsd
    zoxide
    sublime
    #woeusb-ng
    appimage-run
    lxappearance
    # shell
    starship
    fishPlugins.done # sends notification of command completetion more than 5s
    fishPlugins.fzf-fish
    fzf
    fd
    bat
    fishPlugins.forgit
    fishPlugins.grc # coloured terminal output
    grc
    fishPlugins.puffer # sudo !!; cd ....../result.png; !$ (last argument)
    fishPlugins.pisces # auto complete pairs, eg:- "", (), {}
    #fishPlugins.gruvbox
    fishPlugins.fifc
    chafa
    hexyl
    eza 
    ripgrep
    repgrep
    procs
    broot
    fishPlugins.sponge
    # fun cli 
    sl
    lolcat
    cmatrix
    cbonsai
    fortune-kind
    figlet
    cowsay
    fortune
  ];

  # Neovim
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    #extraPackages = with pkgs; [ neovim-qt xclip ];
  };


  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    #nvidiaPatches = true;
  };

  # Fish
  programs.fish = {
    enable = true;
    shellAliases = {
      # directory listing
      "ls" = "lsd --color=auto --group-directories-first";
      "la" = "lsd -A --group-directories-first";
      "ll" = "lsd -alFh --group-directories-first";
      "lr" = "lsd -lRh --group-directories-first";
      "lf" = "lsd -l | grep -E -v '^d'";
      "ld" = "lsd -l | grep -E '^d' --color=never";
      # bat
      "cat" = "bat"; # coloured cat
      "cata" = "bat --show-all"; # shows all
      "catp" = "bat -p"; # no numbers
      "catpp" = "bat -pp"; # no numbers and no pager
      "c" = "bat -l rust"; # for coloured output piping
    };
    shellInit = ''
      zoxide init fish --cmd cd | source
      set fish_greeting ""
      # sponge (shell history)
      set sponge_successful_exit_codes 0 127 
      set sponge_delay 10
      set sponge_allow_previously_successful false
      # fifc
      set -Ux fifc_editor nvim 
      set -U fifc_keybinding \cx
      set -U fifc_fd_opts --hidden
      set -U fifc_bat_opts --style=numbers
      # path 
      set -U fish_user_paths /home/hanu58/.cargo/bin $fish_user_paths
      set -U fish_user_paths /home/hanu58/.local/bin $fish_user_paths
    '';
  };
  users.defaultUserShell = pkgs.fish;

  # starship
  programs.starship = {
    enable = true;
  };

  # Thunar
  programs.thunar.enable = true;
  services.gvfs.enable = true;

  # session variables 
  environment.sessionVariables = {
    # If your cursor becomes invisible
    WLR_NO_HARDWARE_CURSORS = "1";
    # hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };

  # Harware Settings for Nvidia
  hardware.nvidia = {
    modesetting.enable = true;
    # powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  nixpkgs.config.allowUnfree = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  # optimous prime nvidia
  
  hardware.nvidia.prime = {
    # sync.enable = true;
    offload = {
			enable = true;
			enableOffloadCmd = true;
		};
		# Make sure to use the correct Bus ID values for your system!
		#intelBusId = "PCI:0:2:0";
		nvidiaBusId = "PCI:1:0:0";
    amdgpuBusId = "PCI:5:0:0"; #For AMD GPU
	};

  


  # Greet Display Manger
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # Enable xdg portals for better integration with applications
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gtk xdg-desktop-portal-hyprland ];
  # Configure xdg portals
  xdg.portal.config.common.default = "*"; # To maintain pre-1.17 behavior

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  # Locate 
  services.locate.enable = true;
  
  # makes boot faster
  #systemd.network.wait-online.enable = false; # not needed if using NetworkManager to make networks
  #systemd.services.NetworkManager-wait-online.enable = false; # disable if using ethernet
  systemd.services.docker.enable = false;
  systemd.services.lxd.enable = false;
  #systemd.services.vboxnet0.enable = false;
  services.journald.extraConfig = "
    SystemMaxUse=100 
    MaxRetentionSec=1week
  ";

  # Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}


