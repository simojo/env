{ config, lib, pkgs, ... }:
# chromium configuration
{
  programs.chromium = {
    enable = true;
    extensions = [
      "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
      "aghfnjkcakhmadgdomlmlhhaocbkloab" # Just Black theme
      "dmghijelimhndkbmpgbldicpogfkceaj" # Dark Mode
      "ldipcbpaocekfooobnbcddclnhejkcpn" # Google Scholar button
    ];
    extraOpts = {
      "DefaultInsecureContentSetting" = 2; # disallow
      "custom_chrome_frame" = true;

      # disable all manner of account-related things.
      "BrowserSignin" = 0; # disable
      "BrowserAddPersonEnabled" = false;
      "BrowserGuestModeEnabled" = false;
      "UserDisplayName" = "PolicyUser";
      "UserFeedbackAllowed" = false;
      "BackgroundModeEnabled" = false;
      "MetricsReportingEnabled" = false;
      "BlockExternalExtensions" = true;
      "AutofillAddressEnabled" = false;
      "AutofillCreditCardEnabled" = false;
      "PasswordManagerEnabled" = false;
      "PromptForDownloadLocation" = true;

      # usually it's just me testing things so allow it.
      "SSLErrorOverrideAllowed" = true;

      # prefer not-google for most search
      "DefaultSearchProviderEnabled" = true;
      "DefaultSearchProviderName" = "DuckDuckGoPolicy";
      "DefaultSearchProviderKeyword" = "duckduckgo.com";
      "DefaultSearchProviderIconURL" = "https://duckduckgo.com/favicon.ico";
      "DefaultSearchProviderSearchURL" = "https://duckduckgo.com?q={searchTerms}";

      # bookmarks management
      # when needing to browse through, use Ctrl+Shift+O.
      # otherwise, these are here for auto-complete purposes.
      "BookmarkBarEnabled" = true;
      "ShowAppsShortcutInBookmarkBar" = false;
      "ManagedBookmarks" = [
        { "toplevel_name" = "Managed Bookmarks"; }
        { "name" = "Daily"; "children" = [
          { "url" = "https://calendar.google.com/calendar/r"; name = "Calendar"; }
          { "url" = "https://gmail.com/"; name = "Mail"; }
          { "url" = "drive.google.com/drive/u/0/my-drive"; name = "Drive"; }
          { "url" = "https://canvas.colorado.edu"; name = "Canvas"; }
          { "url" = "https://app.slack.com/"; name = "Slack"; }
          { "url" = "https://github.com/"; name = "GitHub"; }
        ]; }
        { "name" = "Entertainment"; "children" = [
          { "url" = "https://open.spotify.com"; name = "Spotify"; }
          { "url" = "https://youtube.com"; name = "YouTube"; }
        ]; }
        { "name" = "Services"; "children" = [
          { "url" = "https://sites.allegheny.edu/lits/library/"; name = "Aggregator"; }
          { "url" = "https://amazon.com/"; name = "Amazon"; }
          { "url" = "https://digitalocean.com/"; name = "DigitalOcean"; }
          { "url" = "https://ebay.com/"; name = "eBay"; }
          { "url" = "https://github.com/"; name = "GitHub"; }
          { "url" = "https://web.hellotalk.com/?from=1home"; name = "HelloTalk"; }
          { "url" = "https://linkedin.com/"; name = "LinkedIn"; }
          { "url" = "https://namecheap.com/"; name = "Namecheap"; }
          { "url" = "https://newegg.com/"; name = "Newegg"; }
          { "url" = "https://translate.google.com/?sl=en&tl=es&op=translate"; name = "Spanish-English"; }
          { "url" = "https://translate.google.com/?sl=en&tl=ja&op=translate"; name = "Japanese-English"; }
          { "url" = "https://translate.google.com/?sl=en&tl=el&op=translate"; name = "Greek-English"; }
        ]; }
        { "name" = "Nix"; "children" = [
          { "url" = "https://nixos.org/nix/manual/"; name = "nix-manual"; }
          { "url" = "https://nixos.org/nixpkgs/manual/"; name = "nixpkgs-manual"; }
          { "url" = "https://nixos.org/nixos/manual/"; name = "nixos-manual"; }
          { "url" = "https://nixos.org/nixos/options.html"; name = "nixos-options"; }
          { "url" = "https://nixos.org/nixos/packages.html"; name = "nixos-packages"; }
          { "url" = "https://discourse.nixos.org/"; name = "nixos-discourse"; }
          { "url" = "https://old.reddit.com/r/nixos/"; name = "nixos-reddit"; }
          { "url" = "https://nixos.wiki/"; name = "nixos-wiki"; }
        ]; }
        { "name" = "ZFS"; "children" = [
          { "url" = "https://www.freebsd.org/doc/handbook/zfs.html"; name = "zfs-handbook"; }
          { "url" = "https://wiki.archlinux.org/index.php/ZFS"; name = "zfs-archwiki"; }
          { "url" = "https://nixos.wiki/wiki/NixOS_on_ZFS"; name = "zfs-nixoswiki"; }
          { "url" = "https://wiki.gentoo.org/wiki/ZFS"; name = "zfs-gentoowiki"; }
          { "url" = "https://docs.oracle.com/cd/E26505_01/html/E37384/"; name = "zfs-oracle"; }
          { "url" = "https://old.reddit.com/r/zfs/"; name = "zfs-reddit"; }
        ]; }
        { "name" = "Git"; "children" = [
          { "url" = "https://docs.github.com/en/enterprise/2.15/user/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent"; name = "ssh-key-gen"; }
          { "url" = "https://docs.github.com/en/github/authenticating-to-github/generating-a-new-gpg-key"; name = "gpg key gen"; }
        ]; }
      ];

    };
  };
}
