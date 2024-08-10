{ stdenv, fetchFromGitHub, lib, ... }:

stdenv.mkDerivation rec {
  pname = "nvchad";
  version = "main"; # You can specify a particular version or branch

  src = fetchFromGitHub {
    owner = "NvChad";
    repo = "starter";
    rev = "main"; # The branch or commit you want to use
    sha256 = "sha256-yxZTxFnw5oV/76g+qkKs7UIwgkpD+LkN/6IJxiV9iRY="; # Run `nix-prefetch-git` to get the actual sha256
  };

  installPhase = ''
    mkdir -p $out
    cp -r * $out/
    echo 'vim.o.clipboard = "unnamedplus"' >> $out/init.lua
  '';

  meta = with lib; {
    description = "Integrating NvChad to Nix";
    homepage = "https://github.com/NvChad/starter";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}

