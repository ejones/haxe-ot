with import <nixpkgs> {};
mkShell {
  buildInputs = [
    haxe
  ];
  HOME = toString ./.nix-home;
  shellHook = ''
    mkdir -p "$HOME"
  '';
}
