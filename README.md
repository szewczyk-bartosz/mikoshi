# Mikoshi

A modular NixOS system configuration built with Nix flakes.

> **Note:** This project is a work in progress. It is functional but not yet complete.

## Overview

Mikoshi is a personal NixOS configuration designed around modularity and composability. Rather than a single monolithic config, each feature is encapsulated in its own module with clear separation between system-level configuration (`system.nix`), home-manager configuration (`home.nix`), and exposed options (`options.nix`).

The goal is to have a clean, reproducible base that can be composed into different system profiles depending on need.

## Structure

```
features/
├── defaultApps/       # Default application associations
├── devTools/          # Development tooling
├── flake-parts/       # Flake-parts integration
├── gnome/             # GNOME desktop environment module
├── hyprland/          # Hyprland compositor module (in progress)
├── hyprshell/         # Hyprshell configuration
├── tmux/              # Tmux configuration
├── waybar/            # Waybar status bar configuration
├── options.nix        # Global options
├── gnomoshi.nix       # GNOME-based system profile
└── mikoshi-full.nix   # Full system composition
```

Each feature module follows a consistent pattern:
- `system.nix` — NixOS system-level configuration
- `home.nix` — Home-manager user-level configuration  
- `options.nix` — Declared options for the module

## Profiles

- **gnomoshi** — A stable, productivity-focused profile built around GNOME
- **mikoshi-full** — Full configuration including Hyprland setup (actively being developed)

## Status

- GNOME profile: functional and in daily use, still tweaking
- Hyprland/Hyprshell setup: under development, will get back to it once I have more time

## License

GPL-3.0
