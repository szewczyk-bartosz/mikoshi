Move hyprland config to lua

REALLY MOVE IT TO LUA

Do an overview of the nvf feature

Fix checks.nix after the refactor

Make OBS aspect work well on non-AMD cards (currently obs-amd hardcodes radeonsi/VAAPI)

Refactor waybar out of hyprland

Fold base.nix into default.nix now that nothing imports "base" by name anymore

Split network.nix, nix-garbage-collection.nix, nvf.nix, stylix.nix into their own standalone aspects (each already has its own enable option, just sharing the "base" key for historical import-selection reasons)

Split audio.nix, fonts.nix, ghostty.nix out of "graphical" into their own honestly-named, independently-toggleable aspects — right now enabling graphical silently installs ghostty/fonts/pipewire, which nothing about the name implies

Re-check whether "graphical" survives as a real profile-style aspect (mikoshi.audio.enable = mkDefault true; etc, a deliberate bundle) or dissolves entirely into siblings hosts toggle individually — decide once the above split is done

Write up an install-guide section listing mkDefault'd real NixOS options (time.timeZone, i18n.defaultLocale, console.font) so users know what's defaulted and how to override — decided against a mikoshi.meta.timezone-style wrapper option, it's pure indirection with no transformation happening
