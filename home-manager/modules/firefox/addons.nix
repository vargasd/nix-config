{ buildFirefoxXpiAddon, lib }:
{
  duplicate-tab-closer = buildFirefoxXpiAddon rec {
    pname = "duplicate_tabs_closer";
    version = "4.2.9";
    addonId = "jid0-RvYT2rGWfM8q5yWxIxAHYAeo5Qg@jetpack";
    url = "https://addons.mozilla.org/firefox/downloads/file/3590150/${pname}-${version}.xpi";
    sha256 = "sha256-VivAt83Hol9vWLPiioBaPlFtIZhUfKx30iRwQMbeNX8=";
    meta = with lib; {
      homepage = "https://github.com/Peuj/duplicate-tabs-closer";
      description = "Detects and automatically closes duplicate tabs.";
      license = licenses.gpl3;
      platforms = platforms.all;
      mozPermissions = [
        "tabs"
        "webNavigation"
        "storage"
      ];
    };
  };
}
