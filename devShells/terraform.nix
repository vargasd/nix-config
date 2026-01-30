{ pkgs, helpers }:
pkgs.mkShell {
  packages = with pkgs; [
    tenv
    terraform-ls
    tflint
  ];

  SAM_LSP_CONFIGS = helpers.extendJsonEnvVar pkgs "SAM_LSP_CONFIGS" {
    terraformls = { };
    tflint = { };
    efm.settings.languages.terraform = [
      {
        formatCommand = "terraform fmt -";
        formatStdin = true;
      }
    ];
  };
}
