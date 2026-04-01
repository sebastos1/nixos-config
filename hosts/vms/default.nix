{ inputs, nixpkgs }:
{
  glance-vm = import ./glance.nix { inherit inputs nixpkgs; };
}
