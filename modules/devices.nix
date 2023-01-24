{ lib, ... }:
with lib;
with types; {
  options = {
    device = mkOption { type = str; };
    deviceSpecific = {
      audio = {
        sink = mkOption { type = str; };
        source = mkOption { type = str; };
      };
    };
  };
}
