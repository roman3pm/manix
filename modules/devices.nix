{ lib, ... }:
with lib;
with types;
{
  options = {
    hostName = mkOption { type = str; };

    devices = {
      interface = mkOption { type = str; };

      monitor1 = mkOption { type = str; };

      monitor2 = mkOption { type = str; };
    };
  };
}
