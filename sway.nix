let
    nixos = "/home/soma/dx/nixos";
in {
    home-manager.users.soma.wayland.windowManager.sway = {
        enable = true;
        checkConfig = false;
        config = {
            assigns = {
                "KeePassXC" = [{app_id = "org.keepassxc.KeePassXC";}];
                "Logseq" = [{app_id = "Logseq";}];
                "ONLYOFFICE" = [{class = "ONLYOFFICE";}];
                "electron-mail" = [{app_id = "electron-mail";}];
                "fluffychat" = [{app_id = "fluffychat";}];
                "librewolf" = [{app_id = "librewolf";}];
            };
            bars = [];
            bindswitches."lid:toggle".action = "exec swaylock -fFKc 222222";
            colors = {
                focused = {
                    background = "#aaaaaa";
                    border = "#aaaaaa";
                    childBorder = "#aaaaaa";
                    indicator = "#aaaaaa";
                    text = "#aaaaaa";
                };
            };
            defaultWorkspace = "workspace number 1";
            focus = {
                followMouse = "always";
                mouseWarping = "container";
            };
            input = {
                "type:keyboard" = {
                    xkb_layout = "us,hu";
                    xkb_options = "caps:backspace,grp:shifts_toggle";
                    xkb_variant = "colemak_dh,101_qwerty_dot_nodead";
                };
                "type:touchpad" = {
                    dwt = "disabled";
                    natural_scroll = "enabled";
                    tap = "enabled";
                };
            };
            keybindings = {
                # === Focus ===
                "mod1+e" = "focus up";
                "mod1+i" = "focus right";
                "mod1+m" = "focus left";
                "mod1+n" = "focus down";
                "mod1+space" = "focus mode_toggle";

                # === Move ===
                "mod1+Shift+e" = "move up";
                "mod1+Shift+i" = "move right";
                "mod1+Shift+m" = "move left";
                "mod1+Shift+n" = "move down";

                # === Resize ===
                "mod1+Ctrl+e" = "resize grow height";
                "mod1+Ctrl+i" = "resize grow width";
                "mod1+Ctrl+m" = "resize shrink width";
                "mod1+Ctrl+n" = "resize shrink height";

                # === Window Management ===
                "mod1+Shift+space" = "floating toggle";
                "mod1+c" = "kill";
                "mod1+f" = "fullscreen";

                # === Terminal ===
                "mod1+Return" = "exec foot";

                # === Clipboard ===
                "Ctrl+Shift+v" = "exec wl-paste | sed ':a;N;$!ba;s/-\\n//g;s/\\n/ /g' | wl-copy";

                # === Screenshot / OCR ===
                "Print" = "exec grim -g \"$(slurp)\"";
                "Shift+Print" = "exec grim -g \"$(slurp)\" - | tesseract - - | wl-copy";

                # === Brightness / Audio ===
                "XF86MonBrightnessUp" = "exec lightctl up";
                "XF86MonBrightnessDown" = "exec lightctl down";
                "XF86AudioRaiseVolume" = "exec volumectl -u up";
                "XF86AudioLowerVolume" = "exec volumectl -u down";
                "XF86AudioMute" = "exec volumectl toggle-mute";

                # === Workspaces ===
                "mod1+1" = "workspace number 1";
                "mod1+Tab" = "workspace back_and_forth";

                # === Scratchpad ===
                "mod1+BackSpace" = "scratchpad show";
                "mod1+Shift+BackSpace" = " move scratchpad";

                # === Media ===
                "mod1+p" = "exec mpv --force-window=immediate $(wl-paste | sed 's|inv.nadeko.net|youtube.com|')";

                # === System ===
                "mod1+b" = "exec notify-send \"$(cat /sys/class/power_supply/BAT0/capacity)%, $(cat /sys/class/power_supply/BAT0/status), $(date +%H:%M)\"";
                "mod1+r" = "exec ${nixos}/misc/rebuild.sh";

                # === Applications ===
                "mod1+k" = "exec swaymsg '[app_id=\"org.keepassxc.KeePassXC\"] focus' || exec keepassxc ~/dx/Backups/Keepass/keepass.kdbx ; exec swaymsg 'workspace KeePassXC'";
                "mod1+l" = "exec swaymsg '[app_id=\"Logseq\"] focus' || exec logseq ; exec swaymsg 'workspace Logseq'";
                "mod1+o" = "exec swaymsg '[class=\"ONLYOFFICE\"] focus' || exec onlyoffice-desktopeditors ; exec swaymsg 'workspace ONLYOFFICE'";
                "mod1+s" = "exec swaymsg '[app_id=\"fluffychat\"] focus' || exec fluffychat ; exec swaymsg 'workspace fluffychat'";
                "mod1+w" = "exec swaymsg '[app_id=\"librewolf\"] focus' || exec librewolf ; exec swaymsg 'workspace librewolf'";
                "mod1+t" = "exec swaymsg '[app_id=\"electron-mail\"] focus' || exec electron-mail ; exec swaymsg 'workspace electron-mail'";

                # === Keepass / Credentials ===
                "mod1+h" = ''exec foot -T password sh -c 'read -s -p "Enter password: " password ; entry=$( echo -e "$password\n" |  keepassxc-cli ls dx/Backups/Keepass/keepass.kdbx -q | fzf ) ; [[ -n "$entry" ]] && nohup librewolf --new-tab $( echo -e "$password\n" | keepassxc-cli show -q -a URL dx/Backups/Keepass/keepass.kdbx "$entry" ) &> /dev/null & echo -e "$password\n" |  keepassxc-cli show dx/Backups/Keepass/keepass.kdbx "$entry" -q -a UserName | wl-copy ; watch -t "echo Username copied" ; echo -e "$password\n" |  keepassxc-cli show dx/Backups/Keepass/keepass.kdbx "$entry" -q -a Password | wl-copy ; watch -t "echo Password copied" ; echo -e "$password\n" |  keepassxc-cli show dx/Backups/Keepass/keepass.kdbx "$entry" -q -t | wl-copy ; [[ -n "$(wl-paste)" ]] && watch -t "echo TOTP copied" ; wl-copy -c' '';
                "mod1+Shift+h" = ''exec foot -T password sh -c 'read -s -p "Enter password: " password ; entry=$( echo -e "$password\n" |  keepassxc-cli ls dx/Backups/Keepass/keepass.kdbx -q | fzf ) ; echo -e "$password\n" |  keepassxc-cli show dx/Backups/Keepass/keepass.kdbx "$entry" -q -a UserName | wl-copy ; watch -t  "echo Username copied" ; echo -e "$password\n" |  keepassxc-cli show dx/Backups/Keepass/keepass.kdbx "$entry" -q -a Password | wl-copy ; watch -t "echo Password copied" ; echo -e "$password\n" |  keepassxc-cli show dx/Backups/Keepass/keepass.kdbx "$entry" -q -t | wl-copy ; [[ -n "$(wl-paste)" ]] && watch -t "echo TOTP copied" ; wl-copy -c' '';
            };
            modes = {};
            output = {
                DSI-1 = {
                    scale = "1.5";
                };
            };
            startup = [
                {command = "autotiling-rs";}
                {command = "electron-mail";}
                {command = "fluffychat";}
                {command = "librewolf";}
                {command = "logseq";}
                {command = "mako";}
            ];
            window = {
                border = 1;
                commands = [
                    #{
                    #command = "opacity 0.75";
                    #criteria.class = ".*";
                    #}
                    {
                        command = "floating enable, move absolute position 540 0, resize set width 300 height 200";
                        criteria.title = "^password$";
                    }
                ];
                hideEdgeBorders = "smart_no_gaps";
                titlebar = false;
            };
        };
        extraConfig = ''
            bindsym --release Super_L exec wmenu-run
            bindgesture swipe:4:up exec "swaymsg input type:keyboard events toggle ; notify-send 'Keyboard Toggled'"'';
        wrapperFeatures = {
            gtk = true;
        };
    };
    home-manager.users.soma.services.avizo = {
        enable = true;
        settings = {
            default = {
                background = "rgba(160, 160, 160, 0.8)";
                bar-fg-color = "rgba(0, 0, 0, 0.8)";
                border-color = "rgba(90, 90, 90, 0.8)";
                image-opacity = 0.75;
                time = 0.5;
            };
        };
    };
}
