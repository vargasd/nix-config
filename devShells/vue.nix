pkgs: {
  packages = with pkgs; [
    vue-language-server
  ];
  env = [
    {
      name = "SAM_VUE";
      value = true;
    }
  ];
}
