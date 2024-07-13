{ pkgs, ... }:
let
  defaultApplication = "firefox";
in
{
  home-manager.users.roz = {
    programs.chromium = {
      enable = true;
      extensions = [
        { id = "nngceckbapebfimnlniiiahkandclblb"; } #bitwarden
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } #vimium
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } #ublock-origin
        { id = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp"; } #privacy-badger
        { id = "ammjkodgmmoknidbanneddgankgfejfh"; } #7tv
      ];
    };

    programs.firefox = {
      enable = true;
      profiles.default = {
        id = 0;
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          bitwarden
          vimium
          ublock-origin
          privacy-badger
        ];
      };
    };

    xdg.mimeApps.defaultApplications = {
      "text/html" = "${defaultApplication}.desktop";
      "x-scheme-handler/http" = "${defaultApplication}.desktop";
      "x-scheme-handler/https" = "${defaultApplication}.desktop";
      "x-scheme-handler/about" = "${defaultApplication}.desktop";
      "x-scheme-handler/unknown" = "${defaultApplication}.desktop";
    };

    home.sessionVariables.BROWSER = "${defaultApplication}";
  };
}
