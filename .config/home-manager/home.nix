{ config, pkgs, ... }:

let
  # tildeRepo = pkgs.fetchFromGitHub {
  #   owner = "c4f3z1n";
  #   repo = "tilde";
  #   rev = "main";
  #   # hash = "sha256-feFbLxX7y3Fs+eJ+BfgsAyFan8EPDE46Z+HxPxBz2wc=";
  #   sha256 = "0lv3nicqdmnyszxnr8pimmh90v03y9982qdz5gjizi6q63qw1z38";
  # };
  tildeRepo = fetchTarball {
    url = "https://github.com/c4f3z1n/tilde/archive/refs/heads/main.tar.gz";
  };
in {
  home = {
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    username = "joao";
    homeDirectory = "/home/joao";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "23.05";

    # The home.packages option allows you to install Nix packages into your
    # environment.
    packages = with pkgs; [
      age
      bat
      chromium
      cryptomator
      docker
      ferdium
      firefox-esr
      gnupg
      guake
      jq
      libreoffice
      lxc
      sops
      thunderbird
      tree
      virt-manager
      vscode
      wireguard-tools
      xsel
      yq-go
      yubikey-manager

      # # It is sometimes useful to fine-tune packages, for example, by applying
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    file = {
      # ".config/autostart/guake.desktop".source = "${pkgs.guake.out}/share/applications/guake.desktop";
      # ".config/home-manager".source = "${home.homeDirectory}/Code/tilde/.config/home-manager";
      # ".config/home-manager" = { source = "${config.home.homeDirectory}/Code/tilde/.config/home-manager"; recursive = true; };
      # ".config/qtile" = { source = "${config.home.homeDirectory}/Code/tilde/.config/qtile"; recursive = true; };
      ".config/qtile".source = "${tildeRepo}/.config/qtile";
      ".config/home-manager".source = "${tildeRepo}/.config/home-manager";
      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
    };

    # You can also manage environment variables but you will have to manually
    # source
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/joao/etc/profile.d/hm-session-vars.sh
    #
    # if you don't want to manage your shell through Home Manager.
    sessionVariables = {
      # EDITOR = "emacs";
    };
  };

  programs = {
    bash.enable = true;
    nushell.enable = true;

    git = {
      enable = true;
      userName = "João Nogueira";
      userEmail = "joao.nogueira@eivee.io";
    };

    tmux = {
      enable = true;
    };

    zsh = {
      enable = true;
      shellAliases = {
        oss = "sudo nixos-rebuild switch";  # OS switch;
        hms = "home-manager switch --impure"; # home-manager switch;

        dig = "nix run nixpkgs/nixos-${config.home.stateVersion}#dig --";
        mosh = "nix run nixpkgs/nixos-${config.home.stateVersion}#mosh --";
      };
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "docker"
          "git"
          "gpg-agent"
          "kubectl"
          "sudo"
          "terraform"
        ];
      };
      zplug = {
        enable = true;
        plugins = [
          { name = "endaaman/lxd-completion-zsh"; }
          { name = "zsh-users/zsh-syntax-highlighting"; }
        ];
      };
    };
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
    enableExtraSocket = true;
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
