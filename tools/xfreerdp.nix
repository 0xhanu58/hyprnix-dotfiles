{ stdenv, fetchFromGitHub, lib, ... }:

stdenv.mkDerivation rec {
  pname = "xfreerdp";
  version = "main"; # You can specify a particular version or branch

  src = fetchFromGitHub {
    owner = "FreeRDP";
    repo = "FreeRDP-old";
    rev = "master"; # The branch or commit you want to use
    sha256 = "sha256-2HNqPdnIVkX+d5OxjsRbL3SoY8l5Ey7/Y274Pi5uZW4="; # Run `nix-prefetch-git` to get the actual sha256
  };

  buildInputs = [ gnumake ];

  buildPhase = ''
    gcc foo.c -o foo
  '';

  installPhase = ''
    mkdir -p $out
    cp -r * $out/
  '';

  meta = with lib; {
    description = "depreciated xfreerdp package";
    homepage = "https://github.com/FreeRDP/FreeRDP-old";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}

