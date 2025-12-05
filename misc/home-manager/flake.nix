{
  description = "Home Manager flake (username-agnostic)";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
      username = builtins.getEnv "USER";
      homeDir  = builtins.getEnv "HOME";
    in
    {
      homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./home.nix

          # Module to set username, homeDirectory, stateVersion
          {
            home = {
              username = username;
              homeDirectory = homeDir;
              stateVersion = "24.05";
            };
          }
        ];
      };
    };
}

