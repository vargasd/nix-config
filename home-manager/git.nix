{
  enable = true;

  aliases = {
    co = "checkout";
    bco = # sh
      ''!f() { git checkout -b "sam/$1"; }; f'';
    bclean = # sh
      "!f() { git branch --merged origin/main | xargs git branch -D; }; f";
    fu = "commit --fixup";
    fua = "commit -a --fixup";
    graph = "log --graph --pretty=mine";
    g = "log --graph --pretty=mine";
    ga = "log --graph --all --pretty=mine";
    mt = "mergetool";
    pf = "push --force";
    ri = # sh
      ''!f() { git rebase -i "''\${1:-origin/HEAD}"; }; f'';
    ra = "rebase --abort";
    rc = "rebase --continue";
    reste = "reset";
  };

  ignores = [
    ".DS_Store"
    "[._]*.s[a-w][a-z]"
    "[._]s[a-w][a-z]"
    "Session.vim"
    ".vim"
    ".samignore"
    ".gitoverlay"
    ".direnv"
    ".envrc"
  ];

  delta = {
    enable = true;
    options = {
      navigate = true;
      tabs = 2;
      syntax-theme = "enhansi";
    };
  };

  extraConfig = {
    log.date = "format-local:%F %R";
    column.ui = "auto";
    commit.gpgSign = true;
    # core.pager = "bat"; # conflict with delta.enabled
    diff = {
      algorithm = "histogram";
      colorMoved = "plain";
      mnemonicPrefix = true;
      renames = true;
    };
    fetch = {
      prune = true;
      pruneTags = true;
      writeCommitGraph = true;
    };
    grep.lineNumber = true;
    help.autocorrect = "prompt";
    init.defaultBranch = "main";
    pager.difftool = true;
    pretty.mine = "%C(auto)%h%C(brightgreen bold)% (trailers:key=closes,valueonly,separator=%x2C)%C(brightblue bold)% (trailers:key=ref,valueonly,separator=%x2C) %C(auto)%s %C(cyan)%aL/%C(blue)%cL %C(magenta)%cd%C(auto)%d";
    pull.rebase = true;
    push = {
      default = "current";
      autoSetupRemote = true;
      followTags = true;
    };
    rebase = {
      autoSquash = true;
      autoStash = true;
      updateRefs = true;
    };
    receive.denyCurrentBranch = "warn";
    rerere = {
      enabled = true;
      autoupdate = true;
    };
    tag = {
      gpgSign = true;
      sort = "version:refname";
    };
    user = {
      email = "sam@varga.sh";
      signingKey = "73266EE4";
      name = "Samuel Varga";
    };
    merge = {
      tool = "nvimdiff";
      conflictStyle = "zdiff3";
    };
    mergetool = {
      keepBackup = false;
      nvimdiff.layout = "LOCAL,REMOTE / MERGED";
      vimdiff.layout = "LOCAL,REMOTE / MERGED";
    };
  };
  includes = [
    {
      condition = "gitdir:~/work/";
      contents = {
        user = {
          email = "samuel.varga@sap.com";
          signingKey = "7FF62D2D";
        };
      };
    }
  ];
}
