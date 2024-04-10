{ pkgs, ... }: {
  home-manager.users.roz = {
    programs.firefox = {
      enable = true;
      profiles.default = {
        id = 0;
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          sidebery
          bitwarden
          vimium
          ublock-origin
          privacy-badger
        ];
        userChrome = ''
          #TabsToolbar {
            visibility: collapse;
          }
        '';
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          "browser.search.defaultenginename" = "Google";
          "browser.search.selectedEngine" = "Google";
          "browser.urlbar.placeholderName" = "Google";
        };
      };
    };
    xdg.mimeApps.defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };
}
