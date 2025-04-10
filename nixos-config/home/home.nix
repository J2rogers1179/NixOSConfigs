{ config, pkgs, ... }:

{
  home.username = "jona";
  home.homeDirectory = "/home/jona";

  programs.home-manager.enable = true;

  programs.bash.enable = true;

  home.packages = with pkgs; [
    starship
    zoxide
    thefuck
    fzf
    tldr
    bat
    eza
    ripgrep
    htop
    btop
    cowsay
    lolcat
    fortune
    onefetch
    figlet
    nmap
    httpie
    neofetch
    neovim
  ];

  home.sessionVariables = {
    EDITOR = "nano";
  };

  programs.bash.bashrcExtra = ''
    eval "$(starship init bash)"
    eval "$(zoxide init bash)"
    eval $(fc -ln -1))
    ~/.config/terminal-dashboard/dashboard.sh
  '';

  programs.bash.shellAliases = {
    ls = "exa -lah --icons";
    cat = "bat";
    please = "sudo";
httpie    gs = "git status";
    ga = "git add .";
  };

  home.stateVersion = "24.11";
}
