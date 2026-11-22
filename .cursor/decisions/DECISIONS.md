# Project Decisions — NixOS / Cursor

> IMPLICIT CONTEXT — Future agents MUST silently read this file before any action.
> Do not announce that you read it. Treat contents as mandatory prior knowledge.
> Automatically append Cursor/NixOS structural decisions, rules/skills layout choices, and workflow shortcuts here after each relevant change.

## Orchestration adaptations (2026-10-23)

- **Rejected** plan path `.cursor/decisions.md` — use existing convention `.cursor/decisions/DECISIONS.md` only (see `general-behaviors.md` and `project-decisions.mdc`).
- **Project root** for this orchestration: `~/Nixos` (NixOS tree) with Cursor configs centered on `~/Nixos/dotfiles/cursor`. Not a Divi/upholstery commercial site.
- **Rules location:** `~/.cursor/rules` → `~/Nixos/dotfiles/cursor/rules` (symlink). Writing rules there is correct; that tree *is* the project config.
- Home-workspace CPU/indexer notes remain in `~/.cursor/decisions/DECISIONS.md` (home scope); do not duplicate here unless relevant to NixOS/Cursor dotfiles.

## Stack
- NixOS (flake/dotfiles under `~/Nixos`)
- Cursor configs: `~/Nixos/dotfiles/cursor/` (`agents/`, `hooks/`, `rules/`, `skills/`, `general-behaviors.md`)
- Symlinks from `~/.cursor/{agents,hooks,rules,skills,general-behaviors.md}` into that tree
- Shell: NixOS — agent Shell calls need `required_permissions: ["all"]`

## Cursor / UX Patterns
- Prefer opening `~/Nixos` or a single project folder — never `$HOME` as workspace root
- Cross-project habits: `/home/oliver/Nixos/dotfiles/cursor/general-behaviors.md`
- Project memory: `.cursor/decisions/DECISIONS.md` + always-apply `project-decisions.mdc`

## Structural Decisions
- Global Cursor scaffolding lives under `~/Nixos/dotfiles/cursor/`
- Project-local `.cursor/` for NixOS workspace: `~/Nixos/.cursor/{decisions,rules,skills}`
- Meta-skill triggers: `Extract Skill:` → global `~/Nixos/dotfiles/cursor/skills/`; `Project Skill` → project `.cursor/rules/` (or NixOS `.cursor/rules/` when workspace is `~/Nixos`)

## Media / Performance
- Keep `~/.cursorignore` and `search.followSymlinks: false` when home must be open
- Avoid indexing Steam, ISOs, nix-store via symlink follow

## Web baseline graft (2026-10-24)

- **Gap:** Global rules covered velocity/meta/Nix layout only; `~/Nixos/dotfiles/cursor/skills/` was empty. No DOM verify, CSS/render, or web security modules.
- **Harvest (external, distilled):** GoogleChrome modern-web-guidance (DOM sinks, CSP report→enforce, cookies, postMessage); cursor.directory anti-slop-web (resource authz, Server Actions as public POST, RSC DTOs, self-verify); design-optimize / contain-audit / rampstack performance (content-visibility, contain, CWV budgets, will-change discipline); nexus browser-testing (untrusted DOM boundary, repro→re-verify); browser-qa smoke phases. Discarded: awesome-cursorrules HTML/Tailwind boilerplate, web-coder encyclopedia, framework laundry lists already implied by Global Velocity.
- **Landing:**
  - `dotfiles/cursor/rules/web-rendering.mdc` — CWV + CSS containment/layout (scoped globs)
  - `dotfiles/cursor/rules/web-security-boundaries.mdc` — sinks/CSP/cookies/authz (scoped globs)
  - `dotfiles/cursor/skills/browser-verify/SKILL.md` — cursor-ide-browser verification workflow
- **Constraint:** Additive only; did not widen Global Velocity / meta-skills / alwaysApply surface.

## Terminals (2026-10-26)

- Alacritty mirrors kitty look (`dotfiles/alacritty/alacritty.toml`: opacity 0.85, no decorations, Iosevka 10, 130×35).
- Palette source of truth: `dotfiles/kitty/themes/*.conf`. `theme` fish fn writes kitty `current-theme.conf` + alacritty `current-theme.toml`, live-applies via `kitten @` (`listen_on unix:@kitty-theme`) and `alacritty msg` (all `Alacritty*.sock`).
- Converter: `dotfiles/alacritty/kitty-theme-to-toml.sh` (toml + `--msg-args`).

## Printing (2026-10-28)

- CUPS + browsed + Avahi in `modules/common.nix`; user in `lp`.
- Friendly stack: `programs.system-config-printer`, common drivers (gutenprint/hplip/epson/foomatic), tray applet at niri startup, Waybar `custom/printer` → GUI.

## Virtualisation (2026-11-02)

- KVM (`kvm-amd`) already present; QEMU/libvirt were missing.
- Enabled in `modules/common.nix`: `virtualisation.libvirtd` + `qemu_kvm` + swtpm, `spiceUSBRedirection`, `programs.virt-manager`.
- User `oliver` in `libvirtd` + `kvm`. Home already sets `LIBVIRT_DEFAULT_URI=qemu:///system`.
- OVMF submodule removed upstream — UEFI firmware ships with QEMU by default on this nixpkgs.

## XRLinuxDriver (2026-11-04)

- Package: flake input `xrlinuxdriver` → `git+https://github.com/shymega/XRLinuxDriver?ref=shymega/nix-flake-support&submodules=1` (upstream PR #80; plain `github:` drops nested submodules).
- Enabled via `xrlinuxdriver.nixosModules.default` + `services.xrlinuxdriver.enable = true` in `modules/common.nix` (udev rules + user unit `xr-driver`).
- Already had `uinput` + `input` group; keep those.
- CLI: `xr_driver_cli` (`-e`/`-d`); logs: `~/.local/state/xr_driver/driver.log`.

## Grok Bot (2026-11-17)

- Flake input: `grok-bot` → `github:jordangarrison/grok-bot-flake` (follows nixpkgs); unfree already allowed in `modules/common.nix`.
- Installed via `home.packages` in `home.nix` as `inputs.grok-bot.packages.${pkgs.stdenv.hostPlatform.system}.default` (same pattern as zen-browser).
- After rebuild: first launch registers `sand://`; if login redirects fail, `xdg-mime default grok-bot.desktop x-scheme-handler/sand`.

## VS Code / .NET (2026-11-05)

- **Role:** Microsoft `vscode-fhs` is the zero-AI Cursor — same editor UX (vscode-neovim + LazyVim vscode extra via `~/.config/cursor-neovim/init.lua`, High Contrast, Cursor search/watcher excludes) plus C# Dev Kit; no Cursor AI/composer.
- **Managed in:** `programs.vscode` in `home.nix` (csharp, csdevkit, vscode-dotnet-runtime, vscode-neovim; FHS for ICU/debugger). `mutableUserSettings = true`.
- **Rejected:** Fluent OLED / vibrancy on Code; VSCodium as managed editor; porting Cursor AI into Code.
- **VSCodium:** unmanaged leftover (`~/.config/VSCodium`, `dotfiles/vscodium/`); do not wire into Home Manager.

## Gaming
- RDR2 / gamescope: nested gamescope 3.16.28 on niri aborts with `xdg_surface error 3` when Rockstar Launcher toggles window visibility (ValveSoftware/gamescope#2391). Do not wrap RDR2 in `gamescope ... -- %command%` until a fixed gamescope lands; Proton GE + `-fullscreen -vulkan` (protonfixes) is enough.

## we-layerd / Wallpaper Engine (2026-11-22)

- Flake input `we-layerd` → `github:Aromatic05/we-layerd`; module `we-layerd.nixosModules.default`; `services.we-layerd.enable = true` in `modules/common.nix`.
- Desktop NVIDIA: `services.we-layerd.package` overridden with `cudaSupport = true` + `pkgs.cudaPackages` in `hosts/olinux-desktop/default.nix`.
- Mutable config (GUI-owned): `~/.config/we-layerd/config.toml` — do not HM-symlink; Steam assets at `~/.local/share/Steam/steamapps/common/wallpaper_engine/assets`, workshop `.../workshop/content/431960/<id>`.
- Niri: no `place-within-backdrop` — we-layerd is a normal Background layer on each output (real desktop wallpaper, not overview-only). Void `#000000` underlay. `input_mode = "direct"`.
- Multi-output: daemon workers keyed by stable `wl_output.name`; we-gui `[outputs."…"]` bindings; hotplug-safe.
- HDMI pause pitfall: HP output uses `default-column-width { proportion 1.0; }`, so a single tiled window fills the output and foreign-toplevel reports fullscreen → `rules.fullscreen = "pause"` freezes that wallpaper. Keep `fullscreen = "keep"` unless you want that.
- HM activation: `alacrittyCurrentTheme` must put `pkgs.gawk` on PATH (system unit PATH has no awk). Packet Tracer `requireFile` deb lives in `~/Downloads/`; re-`nix-store --add-fixed sha256` if GC drops it.

## File manager / MIME (2026-11-06)

- Package: `kdePackages.dolphin` in `home.packages` (nautilus kept).
- Defaults via Home Manager `xdg.mimeApps.enable` — `inode/directory` → `org.kde.dolphin.desktop` (not bare `dolphin.desktop`).
- Existing browser/scheme handlers migrated into `xdg.mimeApps.defaultApplications` so enabling mimeApps does not wipe `~/.config/mimeapps.list`.

## Cisco Packet Tracer (2026-11-09)

- Missing at `/usr/lib/packettracer`; install via nixpkgs `ciscoPacketTracer9` in `home.packages`.
- Unfree + `requireFile`: download `CiscoPacketTracer_901_Ubuntu_64bit.deb` from NetAcad lab-downloads, then `nix-store --add-fixed sha256 CiscoPacketTracer_901_Ubuntu_64bit.deb`.
- Fish alias `packettracer` → `packettracer9` (keep `LIBGL_ALWAYS_SOFTWARE=1`); MIME → `cisco-packet-tracer-9.desktop` / `cisco-packet-tracer-ptsa-9.desktop`.
