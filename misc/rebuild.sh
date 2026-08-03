#!/usr/bin/env bash
set -u

nixos_dir="$HOME/dx/nixos"
lock_file="$nixos_dir/misc/.rebuild.lock"

: > "$lock_file"
exec 9<"$lock_file"
flock -n 9 || { echo "Already rebuilding, exiting"; notify-send "Rebuild Failed"; exit 1; }

alejandra --experimental-config <(printf 'indentation = "FourSpaces"\n') --quiet "$nixos_dir"

if git -C "$nixos_dir" diff --quiet '*.nix'; then
    echo "No changes detected, exiting"
    exit 1
fi

git -C "$nixos_dir" diff --color=always -U0 '*.nix' | tail -n +5
echo "NixOS Rebuilding..."
notify-send "NixOS Rebuilding..."

args=(switch)
for arg in "$@"; do
    case "$arg" in
        --upgrade) args+=(--upgrade) ;;
    esac
done

if doas nice -n 19 nixos-rebuild "${args[@]}" > "$nixos_dir/misc/.nixos-switch.log" 2>&1; then
    generation="$(git -C "$nixos_dir" diff -U20 HEAD '*.nix' | aichat summarize what changed in my nixos config in one short sentence | sed 's/.$//')"
    git -C "$nixos_dir" commit -q -am "$generation"
    git -C "$nixos_dir" push -q -u origin main
    notify-send "Rebuild successful"
else
    cat "$nixos_dir/misc/.nixos-switch.log" | grep error | tail -n 1
    notify-send "Rebuild Failed"
    exit 1
fi
