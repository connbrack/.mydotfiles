{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    bat
    bottom
    fd
    fx
    fzf
    lf
    jq
    jaq
    jqp
    neovim
    ripgrep
    sc-im
    skim
    starship
    tealdeer
    tgpt
    tmux
    zoxide
    zellij
    lazygit
    fastfetch
  ];

  news.display = "silent";

  # Based on https://github.com/nix-community/home-manager/issues/432
  programs.man.enable = false;
  home.extraOutputsToInstall = [ "man" ];
}
