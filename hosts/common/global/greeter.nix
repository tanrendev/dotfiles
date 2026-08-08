{ inputs, ... }:
{
  imports = [ inputs.noctalia-greeter.nixosModules.default ];

  programs.noctalia-greeter = {
    enable = true;
    settings.session.default = "Hyprland (uwsm-managed)";
  };
}
