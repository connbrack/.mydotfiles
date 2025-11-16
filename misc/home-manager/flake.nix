{
  description = "Home Manager flake (username-agnostic)";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
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

