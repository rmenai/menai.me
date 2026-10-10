{ pkgs, ... }:

{
  packages = [ pkgs.chromium ];

  languages.javascript = {
    enable = true;
    bun.enable = true;
  };

  # Required to make playwright work
  env = {
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
    PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH = "${pkgs.chromium}/bin/chromium";
  };

  git-hooks.hooks = {
    commitizen.enable = true;

    trim-trailing-whitespace.enable = true;
    end-of-file-fixer.enable = true;
    check-merge-conflicts.enable = true;
    check-added-large-files.enable = true;

    check-json.enable = true;
    check-toml.enable = true;
    check-yaml.enable = true;

    eslint.enable = true;
    prettier = {
      enable = true;
      settings.configPath = "./prettier.config.js";
    };
  };
}
