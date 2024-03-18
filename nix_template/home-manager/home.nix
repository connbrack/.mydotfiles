{ config, pkgs, ... }:

{
  home.username = "connor";
  home.homeDirectory = "/home/connor";
  home.stateVersion = "23.05";
  home.packages = with pkgs; [

# Main terminal
    neovim
    lf
    tmux
    btop
    tldr
    tgpt

    nodejs_21
    yarn
  ];
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfreePredicate = _: true;
}
