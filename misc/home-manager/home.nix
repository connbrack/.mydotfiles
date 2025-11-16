{ config, pkgs, ... }:

{
  home.packages = with pkgs; [

    ## Tui
    neovim-unwrapped
    lf
    tmux
    bottom
    starship
    lazygit
    sc-im

    ## Core-tools
    fzf
    ripgrep
    fd
    bat
    fx
    zoxide
    skim

    ## Extras
    tealdeer
    tgpt

  ];

  news.display = "silent";

  # Based on https://github.com/nix-community/home-manager/issues/432
  programs.man.enable = false;
  home.extraOutputsToInstall = [ "man" ];
}
