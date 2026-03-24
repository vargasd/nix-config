{ ... }:
{
  programs.gpg = {
    enable = true;
    publicKeys = [
      { source = ./D3346FA3521F7F13.asc; }
    ];
    settings = {
      personal-cipher-preferences = [
        "AES256"
        "AES192"
        "AES"
      ];
      personal-digest-preferences = [
        "SHA512"
        "SHA384"
        "SHA256"
      ];
      personal-compress-preferences = [
        "ZLIB"
        "BZIP2"
        "ZIP"
        "Uncompressed"
      ];
      default-preference-list = [
        "SHA512"
        "SHA384"
        "SHA256"
        "AES256"
        "AES192"
        "AES"
        "ZLIB"
        "BZIP2"
        "ZIP"
        "Uncompressed"
      ];
      cert-digest-algo = "SHA512";
      s2k-digest-algo = "SHA512";
      s2k-cipher-algo = "AES256";
      charset = "utf-8";
      no-comments = true;
      no-emit-version = true;
      no-greeting = true;
      keyid-format = "0xlong";
      list-options = "show-uid-validity";
      verify-options = "show-uid-validity";
      with-fingerprint = true;
      require-cross-certification = true;
      require-secmem = true;
      no-symkey-cache = true;
      armor = true;
      use-agent = true;
      throw-keyids = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 60;
    maxCacheTtl = 120;
  };
}
