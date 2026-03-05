{ pkgs, ... }:
{
  packages = with pkgs; [
    tenv
    terraform-ls
    tflint
  ];

  lspConfig = {
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
