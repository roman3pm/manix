{ pkgs, ... }: {
  home-manager.users.roz = {
    programs.firefox = {
      enable = true;
      profiles.default = {
        id = 0;
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          privacy-badger
          darkreader
          tree-style-tab
          vimium
          bitwarden
        ];
        userChrome = ''
          #TabsToolbar {
            visibility: collapse;
          }
        '';
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          "browser.startup.homepage" = "about:blank";

          "browser.search.defaultenginename" = "Google";
          "browser.search.selectedEngine" = "Google";
          "browser.urlbar.placeholderName" = "Google";

          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.ping-centre.telemetry" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.hybridContent.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.reportingpolicy.firstRun" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.updatePing.enabled" = false;

          "experiments.activeExperiment" = false;
          "experiments.enabled" = false;
          "experiments.supported" = false;
          "network.allow-experiments" = false;
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
