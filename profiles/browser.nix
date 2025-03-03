{ pkgs, ... }:
let
  defaultApplication = "firefox";
in
{
  home-manager.users.roz = {
    programs.chromium = {
      enable = true;
      extensions = [
        { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock-origin
        { id = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp"; } # privacy-badger
        { id = "ammjkodgmmoknidbanneddgankgfejfh"; } # 7tv
      ];
    };

    programs.firefox = {
      enable = true;
      profiles.default = {
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          bitwarden
          vimium
          ublock-origin
          privacy-badger
          seventv
        ];
      };
    };

    home.sessionVariables.BROWSER = "${defaultApplication}";
  };
}
