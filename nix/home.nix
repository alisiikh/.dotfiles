{ pkgs, ... }:
let
  user = builtins.getEnv "USER";

  userInputs = {
    catppuccinFlavour = "mocha";
  };
in
{
  imports = (map (module: import module userInputs) [
    ./zsh
    ./git
    ./ripgrep
    ./bat
    ./direnv
    ./starship
    ./zoxide
    ./alacritty
    ./nvim
    ./tmux
    ./mc
  ]);

  home = {
    username = user;
    homeDirectory = "/Users/${user}";

    stateVersion = "22.11";

    # The home.packages option allows you to install Nix packages into your
    # environment.
    packages = with pkgs;
      [
        nix-prefetch
        bash
        wget
        (nerdfonts.override {
          fonts = [ "Meslo" "JetBrainsMono" "FiraCode" "Hack" ];
        })
        fd
        fzf
        eza # exa fork, as original package is not maintained
        jq
        lua
        rustup
        luarocks
        tree-sitter
        python3
        docker
        minikube
        kubernetes-helm
        terraform
        yarn
        go
        jdk17
        kafkactl
        # awscli2 # broken, hence commented, install unstable or freeze the version
        kcat
        bun
        stern # kubectl pod log scraping tool
        htop
        nodejs
        (sbt.override {
          jre = jdk17;
        })
        coursier
        scala

        (pkgs.writeShellScriptBin "home" ''
          #!/bin/bash

          # Function to display help message
          display_help() {
              echo "Usage: home {make|update|upgrade}"
              echo
              echo "Commands:"
              echo "  make    : Rebuild dotfiles"
              echo "  update  : Update dotfiles"
              echo "  upgrade : Rebuild and updade dotfiles"
          }

          # Function to perform 'home make'
          home_make() {
              home-manager switch --flake ~/.dotfiles#${user} --impure
          }

          # Function to perform 'home update'
          home_update() {
              nix flake update ~/.dotfiles
          }

          # Function to perform 'home upgrade'
          home_upgrade() {
              home_update
              home_make
          }

          # Main function to handle input and execute corresponding action
          main() {
              case "$1" in
                  make)
                      home_make
                      ;;
                  update)
                      home_update
                      ;;
                  upgrade)
                      home_upgrade
                      ;;
                  *)
                      display_help
                      exit 1
                      ;;
              esac
          }

          # Execute main function with provided arguments
          main "$@"
        '')
      ];

    sessionVariables = {
      JAVA_HOME = pkgs.jdk17;
      CATPPUCCIN_FLAVOUR = userInputs.catppuccinFlavour; # still used by nvim lua files
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager = {
    enable = true;
  };
}
