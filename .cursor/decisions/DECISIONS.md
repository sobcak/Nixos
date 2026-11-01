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
