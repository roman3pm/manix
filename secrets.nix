let
  pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOpDpAsY7nE346rDKku5QmsLGp6QlFTMJrH1X4C2GY0B";
in {
  "secrets/wg0-privateKey.age".publicKeys = [ pc ];
  "secrets/wg1-privateKey.age".publicKeys = [ pc ];
}
