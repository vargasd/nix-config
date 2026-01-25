{ buildFirefoxXpiAddon, lib }:

{
  prune = buildFirefoxXpiAddon rec {
    pname = "prune_tabs";
    version = "3.4.16";
    addonId = "iam@theo.lol";
    url = "https://addons.mozilla.org/firefox/downloads/file/4344132/${pname}-${version}.xpi";
    sha256 = "";
    meta = with lib; {
      homepage = "https://github.com/tbrockman/prune";
      description = "prune can help you manage your tab growth";
      license = licenses.gpl3;
      platforms = platforms.all;
      mozPermissions = [
        "activeTab"
        "tabs"
        "bookmarks"
      ];
    };
  };
  tabDeduplicator = buildFirefoxXpiAddon rec {
    pname = "duplicate_tabs_closer";
    version = "3.5.3";
    addonId = "jid0-RvYT2rGWfM8q5yWxIxAHYAeo5Qg@jetpack";
    url = "https://addons.mozilla.org/firefox/downloads/file/3590150/${pname}-${version}.xpi";
    sha256 = "sha256-VivAt83Hol9vWLPiioBaPlFtIZhUfKx30iRwQMbeNX8=";
    meta = with lib; {
      homepage = "https://github.com/binghuan/Tab-Deduplicator";
      description = "prune can help you manage your tab growth";
      license = licenses.gpl3;
      platforms = platforms.all;
      mozPermissions = [
        "cookies"
        "tabs"
        "webNavigation"
        "storage"
        "contextualIdentities"
      ];
    };
  };
}
