let
  pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOpDpAsY7nE346rDKku5QmsLGp6QlFTMJrH1X4C2GY0B";
  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL9PESjEDCGwgiThiRAZZWIlEniN7mZDjldfvAhlh7n8";
  roz = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMdsUJHGS6cO/Xp5r3PqzgDDlx7nCHXzFiE1pjBX6rkN";
  all = [
    pc
    laptop
    roz
  ];
in
{
  "secrets/wg0-privateKey.age".publicKeys = all;
}
