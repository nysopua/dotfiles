# Example devenv configuration
# Copy this to your project and customize
{ pkgs, ... }:

{
  # Environment variables
  env = {
    # EXAMPLE_VAR = "value";
  };

  # Packages available in the shell
  packages = with pkgs; [
    git
  ];

  # Language support
  languages = {
    # Node.js
    # javascript = {
    #   enable = true;
    #   package = pkgs.nodejs_22;
    #   pnpm.enable = true;
    # };

    # Rust
    # rust.enable = true;

    # Python
    # python = {
    #   enable = true;
    #   version = "3.12";
    # };
  };

  # Services
  # services = {
  #   postgres.enable = true;
  #   redis.enable = true;
  # };

  # Scripts
  scripts = {
    hello.exec = "echo 'Welcome to devenv!'";
  };

  # Pre-commit hooks
  # pre-commit.hooks = {
  #   nixpkgs-fmt.enable = true;
  #   prettier.enable = true;
  # };

  # Shell hook
  enterShell = ''
    echo "devenv shell activated"
  '';
}
