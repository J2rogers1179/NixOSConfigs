# /etc/nixos/configuration.nix
# Clean NixOS setup: KDE Plasma 6, auto-updates, AI/dev tooling.

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # ---------- Boot ----------
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-34636641-8284-4ad3-9780-b0105ce7543c".device =
    "/dev/disk/by-uuid/34636641-8284-4ad3-9780-b0105ce7543c";

  # ---------- Networking ----------
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  hardware.enableRedistributableFirmware = true;

  # ---------- Time & locale ----------
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # ---------- Desktop: KDE Plasma 6 ----------
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Automatic login
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "afroninja";

  # ---------- Sound (PipeWire) ----------
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ---------- Hardware ----------
  hardware.bluetooth.enable = true;
  services.printing.enable = true;

  # ---------- User ----------
  users.users.afroninja = {
    isNormalUser = true;
    description = "AfroNinja";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  # ---------- Nix settings & updates ----------
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  # Delete old system versions weekly (keeps 14 days)
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Update the system automatically every week
  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
    allowReboot = false;
  };

  # ---------- AI / dev friendliness ----------
  programs.nix-ld.enable = true;     # lets prebuilt Linux binaries run
  virtualisation.docker = {
    enable = true;
    package = pkgs.docker_29;
};
  # services.ollama.enable = true;   # uncomment to run local LLMs

  # ---------- Shell ----------
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "direnv" "docker" ];
      theme = "robbyrussell";
    };
  };
  system.userActivationScripts.zshrc = "touch .zshrc";
  programs.direnv.enable = true;

  # ---------- Editor ----------
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # ---------- Apps ----------
  programs.firefox.enable = true;

  # ---------- Packages ----------
  environment.systemPackages = with pkgs; [
    # basics
    wget
    curl
    git
    gh
    tree
    fzf
    ripgrep
    fd
    unzip
    jq
    htop
    brave

    # dev / AI
    nodejs_22
    python3
    uv
    gcc
    gnumake
    claude-code
    nixfmt-rfc-style

    # shell
    starship
  ];

  # Leave this at the version you first installed. Do not bump it.
  system.stateVersion = "24.11";
}
