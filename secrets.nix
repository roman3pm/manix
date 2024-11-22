let
  roz-pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMdsUJHGS6cO/Xp5r3PqzgDDlx7nCHXzFiE1pjBX6rkN";
  roz-laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIETTU9unFd79n0ToIig6BO0boOqJ8ImnS9vTCPy4alw7";

  system-pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOpDpAsY7nE346rDKku5QmsLGp6QlFTMJrH1X4C2GY0B";
  system-laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL9PESjEDCGwgiThiRAZZWIlEniN7mZDjldfvAhlh7n8";

  all = [
    roz-pc
    roz-laptop
    system-pc
    system-laptop
  ];
in
{
  "secrets/wg0-privateKey.age".publicKeys = all;
}
