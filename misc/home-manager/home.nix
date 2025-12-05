{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    bat
    blesh
    bottom
    fd
    fx
    fzf
    lf
    neovim
    ripgrep
    sc-im
    skim
    starship
    tealdeer
    tgpt
    tmux
    zoxide
  ];

  news.display = "silent";

  # Based on https://github.com/nix-community/home-manager/issues/432
  programs.man.enable = false;
  home.extraOutputsToInstall = [ "man" ];
}
