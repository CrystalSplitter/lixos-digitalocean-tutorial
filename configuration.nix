# ./configuration.nix
{ lib, modulesPath, pkgs, ... }:

{

  imports = [
    ./networking.nix
  ]
  # Required for Digital Ocean droplets.
  ++ lib.optional (builtins.pathExists ./do-userdata.nix) ./do-userdata.nix ++ [
    (modulesPath + "/virtualisation/digital-ocean-config.nix")
  ];

  # Enable flakes.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Set your default locale, as you wish.
  i18n.defaultLocale = "C.UTF-8";

  # System-wide packages.
  environment.systemPackages = with pkgs; [
    hyfetch # Fetch to show our system is working.
    neovim # Change to your favourite tiny text editor.
  ];

  users.users.lixy = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh = {
      # NOTE: Change this to whatever public key you use!
      authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINmzFzWOf+ddSaL0haZVVUn5tKjE+XsMEDGn/J4Etkuj"
      ];
    };
  };

  users.users.root = {
    openssh = {
      # NOTE: Change this to whatever public key you use!
      authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINmzFzWOf+ddSaL0haZVVUn5tKjE+XsMEDGn/J4Etkuj"
      ];
    };
  };

  # Passwordless sudo.
  # WARNING!
  # If you decide to change this, remember you NEED to set a password
  # for the chosen user with an "authorizedKeys" setting. Passwords are
  # public in the nix store, so know what you're doing!
  security.sudo.wheelNeedsPassword = false;

  # Set this to whichever system state version you're installing now.
  # Afterwards, don't change this lightly. It doesn't need to change to
  # upgrade.
  system.stateVersion = "25.05";
}
