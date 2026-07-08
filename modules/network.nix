{...}: {
  flake.modules.nixos.base = {
    lib,
    config,
    ...
  }: {
    assertions = [
      {
        assertion = config.networking.hostName != "";
        message = "networking.hostName must be set";
      }
    ];
    networking.networkmanager.enable = true;
  };
}
