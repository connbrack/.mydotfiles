{ config, pkgs, ... }:

{
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  home.username = builtins.getEnv "USER";
  home.homeDirectory = "/home/${config.home.username}";
  home.stateVersion = "24.05";

  home.packages = with pkgs; [

    ## Tui
    neovim
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

  programs.home-manager.enable = true;
  news.display = "silent";

  # Based on https://github.com/nix-community/home-manager/issues/432
  programs.man.enable = false;
  home.extraOutputsToInstall = [ "man" ];
}
