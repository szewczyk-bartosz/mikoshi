add xdg rules for nicer home dir

make the current keyboard layout visible on the waybar 

make sound control work on 

make workspaces clickable

fix the bug that makes windows fold to one screen on wakeup

MOVE TO NIXVIM

look into weird black block appearing when mousing over time

Do an overview of the nvf feature

Make OBS aspect work well on non-AMD cards (currently obs-amd hardcodes radeonsi/VAAPI)

Fold base.nix into default.nix now that nothing imports "base" by name anymore

Split network.nix, nix-garbage-collection.nix, nvf.nix, stylix.nix into their own standalone aspects (each already has its own enable option, just sharing the "base" key for historical import-selection reasons)
