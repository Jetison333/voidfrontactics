# shell.nix
with import <nixpkgs> { };

mkShell {
  name = "voidfront tactics";
  packages = [ godot ];
}
