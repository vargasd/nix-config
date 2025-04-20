pkgs:
pkgs.mkShell {
  packages = with pkgs; [
    vue-language-server
  ];
  SAM_VUE = "1";
}
