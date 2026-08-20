{ pkgs, lib, ... }:
{
  imports = [
    ./nixos.nix
  ];

  home = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      # https://wiki.nixos.org/wiki/Prisma
      PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
      PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
      PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/query-engine";
      PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
      PRISMA_FMT_BINARY = "${pkgs.prisma-engines}/bin/prisma-fmt";
    };

    file.".yarnrc.yaml".text = lib.generators.toYAML { } {
      npmRegistries."https://npm.pkg.github.com" = {
        npmAlwaysAuth = true;
        npmAuthToken = "GITHUB_PERSONAL_TOKEN";
      };
    };

    packages = with pkgs; [
      slack
      claude-code

      openssl
      corepack_24
      nodejs_24

      (google-cloud-sdk.withExtraComponents (
        with google-cloud-sdk.components;
        [
          gke-gcloud-auth-plugin
          config-connector
        ]
      ))

      prisma-engines
      prisma
    ];
  };

  programs.aerc.extraAccounts.work =
    let
      passGetter = pkgs.writeShellScript "pass-getter" "pass show $1 | head -1";
    in
    {
      source = "imaps://sam.varga%40championhq.com@imap.gmail.com";
      source-cred-cmd = "${passGetter} work/aerc.gmail";
      outgoing = "smtp://sam.varga%40championhq.com@smtp.gmail.com";
      outgoing-cred-cmd = "${passGetter} work/aerc.gmail";
      default = "INBOX";
      from = "Sam Varga <sam.varga@championhq.com>";
      cache-headers = true;
      folders-sort = "INBOX";
      postpone = "[Gmail]/Drafts";
    };
}
