# Mikoshi
A modular NixOS configuration library built with flake-parts.

> **Note:** This project is a work in progress. It is functional and in daily use, but not yet complete.

---

## Overview

Mikoshi is a NixOS configuration library designed around modularity and composability. Rather than a single monolithic config, each feature is encapsulated in its own module with clear separation between system-level configuration (`system.nix`), home-manager configuration (`home.nix`), and exposed options (`options.nix`).

The goal is a clean, reproducible base that can be composed into different system profiles depending on need. Mikoshi exposes its modules via `flake.nixosModules.*`, meaning you import what you need and configure it through the `mikoshi.*` option namespace.

**home-manager is a prerequisite.** Mikoshi does not manage home-manager for you — import it yourself and wire up your users. Mikoshi features that require home-manager use `home-manager.sharedModules` internally and will work as long as home-manager is present as a NixOS module.

---

## Profiles

Profiles are pre-composed collections of features for common use cases. They are the recommended starting point.

### gnomoshi
A stable, productivity-focused desktop profile built around GNOME with Pop Shell tiling.

**Includes:** audio, network, ghostty, gnome, tmux, stylix, fonts, icons, steam, neovim

### hyprlandoshi
A full desktop profile built around Hyprland.

**Includes:** hyprland, audio, network, ghostty, stylix, tmux, fonts, icons, neovim

---

## Usage

```nix
{
  inputs.mikoshi.url = "github:szewczyk-bartosz/mikoshi";

  outputs = { nixpkgs, mikoshi, home-manager, ... }: {
    nixosConfigurations.myhostname = nixpkgs.lib.nixosSystem {
      modules = [
        home-manager.nixosModules.home-manager
        mikoshi.nixosModules.gnomoshi
        {
          mikoshi.stylix.base16Scheme = "catppuccin-mocha";
          mikoshi.gnome.kb = "us";
        }
        ./hardware-configuration.nix
      ];
    };
  };
}
```

Individual modules can also be imported directly:

```nix
mikoshi.nixosModules.neovim
mikoshi.nixosModules.tmux
```

---

## Features

### audio
Configures PipeWire with PulseAudio compatibility.

**Options:**
| Option | Default | Description |
|--------|---------|-------------|
| `mikoshi.audio.enable` | `true` | Enable Mikoshi's audio setup |

---

### fonts
Sets up system-wide font rendering with sane defaults.

**Installed fonts:** Noto (serif, sans, CJK, emoji), Liberation, JetBrainsMono Nerd Font

**Defaults:**
- Serif: Noto Serif
- Sans: Noto Sans
- Monospace: JetBrainsMono Nerd Font
- Emoji: Noto Color Emoji

**Options:**
| Option | Default | Description |
|--------|---------|-------------|
| `mikoshi.fonts.enable` | `true` | Enable font setup |

---

### network
Enables NetworkManager.

**Options:**
| Option | Default | Description |
|--------|---------|-------------|
| `mikoshi.network.enable` | `true` | Enable NetworkManager |

---

### ghostty
Installs and enables Ghostty as the default terminal.

**Options:**
| Option | Default | Description |
|--------|---------|-------------|
| `mikoshi.ghostty.enable` | `true` | Enable Ghostty |

---

### gnome
Full GNOME desktop setup with Pop Shell tiling extension, dark mode, and a vim-inspired keyboard-driven workflow.

**Includes:** GDM display manager, Nautilus, GNOME Calculator, Loupe image viewer, Seahorse, Evince, Pop Shell extension.

**Defaults:** dark mode, `Europe/London` timezone, `en_US.UTF-8` locale, `gb` keyboard layout.

**Options:**
| Option | Default | Description |
|--------|---------|-------------|
| `mikoshi.gnome.enable` | `true` | Enable Mikoshi's GNOME setup |
| `mikoshi.gnome.kb` | `"gb"` | Keyboard layout |

#### Pop Shell Keybinds

**Focus:**
| Binding | Action |
|---------|--------|
| `Alt+h` | Focus left |
| `Alt+j` | Focus down |
| `Alt+k` | Focus up |
| `Alt+l` | Focus right |

**Move window:**
| Binding | Action |
|---------|--------|
| `Ctrl+Alt+h` | Move window left |
| `Ctrl+Alt+j` | Move window down |
| `Ctrl+Alt+k` | Move window up |
| `Ctrl+Alt+l` | Move window right |

**Workspaces:**
| Binding | Action |
|---------|--------|
| `Alt+1-9` | Switch to workspace 1-9 |
| `Alt+Shift+1-9` | Move window to workspace 1-9 |

---

### hyprland
Hyprland compositor setup with Waybar, swaync, rofi, and GDM.

**Includes:** Hyprland, Waybar, swaync, rofi, nm-applet, pavucontrol, wlogout, brightnessctl, playerctl, lxqt-policykit.

**Options:**
| Option | Default | Description |
|--------|---------|-------------|
| `mikoshi.hyprland.enable` | `true` | Enable Hyprland setup |
| `mikoshi.hyprland.mainMod` | `"ALT"` | Modifier key |
| `mikoshi.hyprland.keyboardLayout` | `"gb"` | Keyboard layout |
| `mikoshi.hyprland.monitors` | `[",preferred,auto,auto"]` | Monitor configuration list |
| `mikoshi.hyprland.terminal` | `ghostty` | Default terminal package |
| `mikoshi.hyprland.fileManager` | `nautilus` | Default file manager package |

#### Hyprland Keybinds

**Core:**
| Binding | Action |
|---------|--------|
| `$mainMod+Return` | Open terminal |
| `$mainMod+Shift+Q` | Kill active window |
| `$mainMod+Shift+O` | Exit Hyprland |
| `$mainMod+E` | Open file manager |
| `$mainMod+V` | Toggle floating |
| `$mainMod+Space` | Open rofi launcher |

**Focus:**
| Binding | Action |
|---------|--------|
| `$mainMod+H` | Focus left |
| `$mainMod+J` | Focus down |
| `$mainMod+K` | Focus up |
| `$mainMod+L` | Focus right |

**Move window:**
| Binding | Action |
|---------|--------|
| `$mainMod+Shift+H` | Move window left |
| `$mainMod+Shift+J` | Move window down |
| `$mainMod+Shift+K` | Move window up |
| `$mainMod+Shift+L` | Move window right |

**Workspaces:**
| Binding | Action |
|---------|--------|
| `$mainMod+1-9,0` | Switch to workspace 1-10 |
| `$mainMod+Shift+1-9,0` | Move window to workspace 1-10 (silent) |

**Mouse:**
| Binding | Action |
|---------|--------|
| `$mainMod+LMB drag` | Move window |
| `$mainMod+RMB drag` | Resize window |

**Media / System:**
| Binding | Action |
|---------|--------|
| `XF86AudioRaiseVolume` | Volume +5% |
| `XF86AudioLowerVolume` | Volume -5% |
| `XF86AudioMute` | Toggle mute |
| `XF86AudioMicMute` | Toggle mic mute |
| `XF86MonBrightnessUp` | Brightness +5% |
| `XF86MonBrightnessDown` | Brightness -5% |
| `XF86AudioNext` | Next track |
| `XF86AudioPrev` | Previous track |
| `XF86AudioPlay/Pause` | Play/pause |

---

### icons
GTK theming with adw-gtk3 and Adwaita icons.

**Defaults:** adw-gtk3 theme, Adwaita icon theme and cursor.

**Options:**
| Option | Default | Description |
|--------|---------|-------------|
| `mikoshi.icons.enable` | `true` | Enable icon and GTK theming |

---

### steam
Installs Steam with GameMode and 32-bit graphics support.

**Includes:** Steam, GameMode, ProtonUp-Qt, hardware graphics with 32-bit enabled.

---

### stylix
System-wide theming via [Stylix](https://github.com/danth/stylix) using base16 schemes. Applies consistently across all supported applications.

**Options:**
| Option | Default | Description |
|--------|---------|-------------|
| `mikoshi.stylix.enable` | `true` | Enable Stylix theming |
| `mikoshi.stylix.base16Scheme` | `"eris"` | Base16 scheme name |

**Custom themes** are available in `features/stylix/themes/`. To use one:
```nix
mikoshi.stylix.base16Scheme = "purple-dream-proto";
```

Standard base16 schemes from `base16-schemes` are also available. Browse them at [tinted-theming/base16-schemes](https://github.com/tinted-theming/base16-schemes).

---

### tmux
Tmux configured with vi keybindings, vim-style pane navigation, and sensible defaults.

**Configuration:** `Ctrl+Space` prefix, vi mode, 24h clock, mouse support, base index 1, 10000 line history.

**Keybinds (after prefix):**
| Binding | Action |
|---------|--------|
| `h` | Select left pane |
| `j` | Select down pane |
| `k` | Select up pane |
| `l` | Select right pane |
| `a` | Last window |

**Options:**
| Option | Default | Description |
|--------|---------|-------------|
| `mikoshi.tmux.enable` | `true` | Enable tmux |

---

### neovim — Mikoshi Vim
*A Samurai's Editor. Focus is on simplicity and building muscle memory.*

Neovim configured via [nvf](https://github.com/NotAShelf/nvf). LSP, treesitter, git integration, telescope, and more — all declaratively configured.

**Languages with LSP + formatting:** Nix, Python, Rust, Java, TypeScript/JavaScript, CSS, HTML.

**Theme:** Tokyo Night (night variant). Overridden by Stylix when present.

#### Quick Access Bindings

| Binding | Action |
|---------|--------|
| `jk` (insert) | Exit to normal mode |
| `Ctrl+h/j/k/l` | Window navigation |
| `Tab` / `Shift+Tab` | Next / previous buffer |
| `]d` / `[d` | Next / previous diagnostic |
| `]c` / `[c` | Next / previous git hunk |
| `]x` / `[x` | Next / previous git conflict |
| `F12` | Toggle terminal |
| `K` | Hover documentation |
| `gcc` / `gc` | Toggle line / motion comment |
| `gbc` / `gb` | Toggle block comment |
| `s` | Flash jump |
| `S` | Flash treesitter |
| `<leader>e` | Toggle Neo-tree file explorer |

#### LSP (`<leader>l*`)

| Binding | Action |
|---------|--------|
| `<leader>ld` | Go to definition |
| `<leader>lr` | Show references |
| `<leader>li` | Go to implementation |
| `<leader>lt` | Go to type definition |
| `<leader>ln` | Rename symbol |
| `<leader>la` | Code action |
| `<leader>ls` | Document symbols |
| `<leader>lh` | Hover documentation |
| `<leader>lf` | Format buffer |
| `<leader>lo` | Outline (Aerial) |

#### Diagnostics (`<leader>d*`)

| Binding | Action |
|---------|--------|
| `<leader>dd` | Show diagnostic at cursor |
| `<leader>dn` | Next diagnostic |
| `<leader>dp` | Previous diagnostic |

#### Git (`<leader>g*`)

| Binding | Action |
|---------|--------|
| `<leader>gg` | Open Lazygit |
| `<leader>gs` | Stage hunk |
| `<leader>gr` | Reset hunk |
| `<leader>gu` | Undo stage hunk |
| `<leader>gp` | Preview hunk |
| `<leader>gb` | Blame line |
| `<leader>gdd` | Diff this |
| `<leader>gdp` | Diff project |
| `<leader>gS` | Stage buffer |
| `<leader>gR` | Reset buffer |
| `<leader>gtb` | Toggle blame |
| `<leader>gtd` | Toggle deleted |

**Git conflicts:**

| Binding | Action |
|---------|--------|
| `<leader>gco` | Choose ours |
| `<leader>gct` | Choose theirs |
| `<leader>gcb` | Choose both |
| `<leader>gcn` | Choose none |

#### Buffers (`<leader>b*`)

| Binding | Action |
|---------|--------|
| `<leader>bc` | Choose buffer (pick) |
| `<leader>bq` | Close buffer |
| `<leader>bsd` | Sort by directory |
| `<leader>bse` | Sort by extension |
| `<leader>bsi` | Sort by ID |

#### Find / Telescope (`<leader>f*`)

| Binding | Action |
|---------|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help tags |
| `<leader>ft` | Open Telescope |
| `<leader>fr` | Resume previous search |
| `<leader>fs` | Treesitter symbols |

**LSP via Telescope (`<leader>fl*`):**

| Binding | Action |
|---------|--------|
| `<leader>fld` | Diagnostics |
| `<leader>flD` | LSP definitions |
| `<leader>fli` | LSP implementations |
| `<leader>flr` | LSP references |
| `<leader>flt` | LSP type definitions |
| `<leader>flsb` | Document symbols |
| `<leader>flsw` | Workspace symbols |

**Git via Telescope (`<leader>fv*`):**

| Binding | Action |
|---------|--------|
| `<leader>fvf` | Git files |
| `<leader>fvcw` | Git commits |
| `<leader>fvcb` | Git buffer commits |
| `<leader>fvb` | Git branches |
| `<leader>fvs` | Git status |
| `<leader>fvx` | Git stash |

---

## License
GPL-3.0
