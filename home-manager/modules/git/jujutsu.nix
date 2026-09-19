{ ... }:
{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        email = "sam@varga.sh";
        name = "Samuel Varga";
      };
      signing = {
        behavior = "own";
        backend = "gpg";
        key = "D3346FA3521F7F13";
      };
      git = {
        sign-on-push = true;
      };
    };
  };

  programs.delta.enableJujutsuIntegration = true;
}
