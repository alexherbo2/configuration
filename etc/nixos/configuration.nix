# NixOS
# https://nixos.org/nixos/manual/
# https://nixos.org/nixos/packages.html
# https://nixos.org/nixos/options.html

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan,
    # generated by nixos-generate-config.
    ./hardware-configuration.nix
  ];

  # This value determines the NixOS release with which your system is to be compatible,
  # in order to avoid breaking some software such as database servers.
  # You should change this only after NixOS release notes say you should.
  system.stateVersion = "18.03";

  # Options ────────────────────────────────────────────────────────────────────

  # Page: https://nixos.org/nixos/options.html

  networking.hostName = "othala";

  time.timeZone = "Europe/Paris";

  # Unfree
  # Allow Discord, drivers for Wi-Fi…
  nixpkgs.config.allowUnfree = true;

  # Security
  # Do not prompt for password
  security.sudo.wheelNeedsPassword = false;

  # Optimization – Speed-up builds
  # Jobs to run in parallel
  # Pull request: https://github.com/NixOS/nixpkgs/pull/44880
  # nix.maxJobs = "auto";
  # Use all available cores
  nix.buildCores = 0;

  # Automatic Upgrades
  # https://nixos.org/nixos/manual#idm140737316591792
  system.autoUpgrade.enable = true;

  # Cleaning the Nix Store
  # https://nixos.org/nixos/manual#sec-nix-gc
  nix.gc.automatic = true;

  # Clean temporary files during boot
  boot.cleanTmpDir = true;

  # Boot ───────────────────────────────────────────────────────────────────────

  # UEFI
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelModules = [
    # Wi-Fi (Unfree)
    "wl"
  ];

  boot.extraModulePackages = [
    # Wi-Fi (Unfree)
    config.boot.kernelPackages.broadcom_sta
  ];

  # Users ──────────────────────────────────────────────────────────────────────

  users.extraUsers.alex = {
    uid = 1000;
    # Indicates whether this is an account for a real user.
    # In other words, set a bunch of options for us.
    # https://nixos.org/nixos/options.html#isNormalUser
    isNormalUser = true;
    extraGroups = [
      "audio"
      "disk"
      "docker"
      "games"
      "networkmanager"
      "vboxusers"
      "wheel"
    ];
  };

  # Variables ──────────────────────────────────────────────────────────────────

  environment.variables = {
    XDG_CURRENT_DESKTOP = "kde";
  };

  # Services ───────────────────────────────────────────────────────────────────

  # Login
  services.logind.lidSwitch = "ignore";
  services.logind.extraConfig = ''
    HandlePowerKey=hibernate
    HandleSuspendKey=suspend
    HandleHibernateKey=hibernate
  '';

  # Networking
  networking.networkmanager.enable = true;

  # SSH
  services.openssh.enable = true;

  # Printing
  services.printing.enable = true;

  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  # Explicit PulseAudio support in applications
  # https://nixos.wiki/wiki/PulseAudio#Explicit_PulseAudio_support_in_applications
  nixpkgs.config.pulseaudio = true;

  # X11
  services.xserver.enable = true;
  # Enable touchpad support
  services.xserver.libinput.enable = true;

  # Display manager
  services.xserver.displayManager.sddm.enable = true;

  # Window managers
  # i3
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.package = pkgs.i3-gaps;
  # bspwm
  services.xserver.windowManager.bspwm.enable = true;

  # Desktop managers
  # Plasma
  services.xserver.desktopManager.plasma5.enable = true;

  # Qt
  # programs.qt5ct.enable = true;

  # Compositor for window managers
  services.compton.enable = true;

  # Redshift
  services.redshift.enable = true;
  # Location: Paris
  # https://google.com/search?q=Paris+Coordinates
  services.redshift.latitude = "48.8566";
  services.redshift.longitude = "2.3522";

  # Virtualisation
  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;

  # Packages ───────────────────────────────────────────────────────────────────

  # Page: https://nixos.org/nixos/packages.html
  # To search, run:
  # $ nix search {query}
  environment.systemPackages = with pkgs; [
    acpi
    aegisub
    aircrack-ng
    alacritty
    asciidoc
    asciinema
    bash
    bat
    bc
    blender
    bspwm
    bundix
    cabal-install
    calibre
    cargo
    ccl
    chromium
    clang
    cockatrice
    compton
    cool-retro-term
    crystal
    ctags
    curl
    dash
    dejavu_fonts
    discord
    docker
    dolphin
    dolphinEmu
    dtach
    dunst
    elvish
    emacs
    exa
    fdm
    ffmpeg
    file
    font-awesome_5
    fzf
    gcc
    ghc
    gimp
    git
    gitAndTools.diff-so-fancy
    gnumake
    go
    godot
    gparted
    gptfdisk
    graphviz
    gsmartcontrol
    gtkpod
    htop
    hunspell
    hunspellDicts.en-us
    i3blocks
    i3-gaps
    imagemagick
    inkscape
    inotify-tools
    iw
    jq
    kakoune
    kdeApplications.kdenlive
    leiningen
    lemonbar-xft
    lf
    libnotify
    lispPackages.quicklisp
    llvm
    lxc
    mkvtoolnix
    mosh
    mpv
    msmtp
    ncftp
    neovim
    nettools
    networkmanagerapplet
    nginx
    nix-index
    nodejs-10_x
    notmuch
    ntfs3g
    p7zip
    pandoc
    pavucontrol
    pcre
    peek
    peruse
    plasma-desktop
    polybar
    python37
    qemu
    ranger
    redshift
    ripgrep
    rofi
    rtorrent
    ruby_2_5
    rustup
    sbcl
    screenkey
    sddm
    setroot
    shards
    smartmontools
    socat
    sox
    sshfs
    steam
    sxhkd
    sxiv
    tig
    tmux
    tor
    unrar
    unzip
    vanilla-dmz
    virtualbox
    vis
    vscode
    weechat
    wget
    wine
    xboxdrv
    xclip
    xcompmgr
    xdo
    xdotool
    xorg.xbacklight
    xorg.xev
    xorg.xinit
    xorg.xkbcomp
    xorg.xmodmap
    xorg.xrdb
    yarn
    youtube-dl
    zathura
    zip
  ];

}
