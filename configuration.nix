# ./configuration.nix
{ pkgs, ... }:

{
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

  # Set this to whichever system state version you're installing now.
  # Afterwards, don't change this lightly. It doesn't need to change to
  # upgrade.
  system.stateVersion = "25.05";
}
