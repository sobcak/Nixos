# Cisco Packet Tracer (manual only)

Not managed by Home Manager or `nix switch`. Keeps flake builds from depending on NetAcad vendor blobs.

## Vendor deb

Place `CiscoPacketTracer_901_Ubuntu_64bit.deb` in this directory (gitignored).

## One-off run

```bash
deb="$HOME/Nixos/vendor/cisco-packet-tracer/CiscoPacketTracer_901_Ubuntu_64bit.deb"
nix-store --add-fixed sha256 "$deb"
nix shell --extra-experimental-features 'nix-command flakes' nixpkgs#ciscoPacketTracer9 \
  --command env LIBGL_ALWAYS_SOFTWARE=1 packettracer9
```

Download: [NetAcad lab downloads](https://www.netacad.com/resources/lab-downloads).