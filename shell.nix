let
  pkgs = import <nixpkgs> {};
  memoricidepkgs = import <memoricidepkgs> {};
  stdenv = pkgs.stdenv;
  elixir = import /home/sweater/.nix/pkg/elixir/default.nix {};
in
{
  developmentEnv = stdenv.mkDerivation rec {
    name = "developmentEnv";
    version = "nightly";
    src = ./.;
    buildInputs = [
      memoricidepkgs.elixir
      pkgs.postgresql93
    ];
  };
}
