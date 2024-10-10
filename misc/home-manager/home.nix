{ config, pkgs, ... }:

{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  home.username = "__username__";
  home.homeDirectory = "/home/__username__";
  home.stateVersion = "24.05";

  nixpkgs.config.permittedInsecurePackages = [
    "electron-27.3.11"
  ];
  home.packages = [


    ## Terminal
    pkgs.neovim
    pkgs.lf
    pkgs.tmux
    pkgs.fzf
    pkgs.bottom
    pkgs.starship

    ## Extras
    #pkgs.tldr
    #pkgs.tgpt
    #pkgs.pokeget-rs
    #pkgs.cmatrix
    #pkgs.cowsay

    ## Desktop tools
    #pkgs.rofi-wayland
    #pkgs.rofimoji
    #pkgs.rbw
    #pkgs.rofi-rbw-wayland

    ## Graphical Apps
    #pkgs.firefox
    #pkgs.vscodium
    #pkgs.audacity
    #pkgs.logseq
    #pkgs.zotero

    ## Phone
    #pkgs.android-tools
    #pkgs.scrcpy

  ];

  home.file = {
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.home-manager.enable = true;

  # Based on https://github.com/nix-community/home-manager/issues/432
  programs.man.enable = false;
  home.extraOutputsToInstall = [ "man" ];
}
