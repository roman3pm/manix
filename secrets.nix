let
  pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOpDpAsY7nE346rDKku5QmsLGp6QlFTMJrH1X4C2GY0B";
  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL9PESjEDCGwgiThiRAZZWIlEniN7mZDjldfvAhlh7n8";
in {
  "secrets/wg0-privateKey.age".publicKeys = [ pc laptop ];
  "secrets/wg1-privateKey.age".publicKeys = [ pc laptop ];
}
