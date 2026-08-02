{
    config,
    pkgs,
    lib,
    ...
}: {
    home-manager.users.soma.programs.fish = {
        enable = true;
        shellInit = ''
            rem -n -b1 | sort -r | tail -n 3 | sed 's|^[0-9]\{4\}/||'
            echo -e "\033[31m$(date '+%m/%d %R %A') \033[91m$(echo "scale=5; ($(date +%s)-$(date -d"$(cat /home/soma/dx/nixos/misc/secrets/birthdate)" +%s))/(80*365.2425*86400)*100"|bc|sed 's/0*$//')%\033[0m \033[92m$(cat /tmp/webn)\033[0m"
            remind ~/dx/Backups/remind/chores.rem | tail -n +2 | grep -v '^$'

            set fish_color_command green
            set fish_greeting
            set -g fish_key_bindings fish_vi_key_bindings

            set fish_cursor_default block blink
            set fish_cursor_insert underscore blink
            set fish_cursor_replace_one line blink
            set fish_cursor_replace line blink
            set fish_cursor_external line blink
            set fish_cursor_visual block blink

            bind m backward-char
            bind n down-or-search
            bind e up-or-search
            bind i forward-char

            bind -M visual m backward-char
            bind -M visual n down-line
            bind -M visual e up-line
            bind -M visual i forward-char

            bind \' "set fish_bind_mode insert"
            bind \" beginning-of-line "set fish_bind_mode insert"

            #set TTY1 (tty)
            #[ "$TTY1" = "/dev/tty1" ] && exec sway

            [ (tty) = "/dev/tty1" ] && exec sway

            function __ls_after_cd__on_variable_pwd --on-variable PWD
                if status --is-interactive
                    eza -F --no-quotes --group-directories-first
                end
            end

            any-nix-shell fish | source

        '';
        functions = {
            # === Fish ===
            fish_prompt = "string join '' -- (set_color red) '%' (set_color white)  (prompt_pwd --dir-length=0) (set_color green) '>' (set_color normal)";
            fish_mode_prompt = "";

            # === Links ===
            w = ''links "https://en.wikipedia.org/wiki/$argv?useskin=minerva#bodyContent"'';
            we = ''links "https://en.wiktionary.org/wiki/$argv#English"'';
            pb = ''links "https://thepiratebay.party/search/$argv"'';

            # === Bluetooth ===
            bcnp = ''
                bluetoothctl power on
                set btexists $(pgrep -f bluetoothctl)
                [[ -z $btexists ]] && bluetoothctl -t 60 scan on > /dev/null &
                watch -c -n 1 "bluetoothctl devices| grep Device | grep -v '.*-.*-.*-.*-.*-.*' | sort"
                set selected $(bluetoothctl devices | grep Device | grep -v '.*-.*-.*-.*-.*-.*' | sort | fzf | cut -d' ' -f2)
                bluetoothctl pair $selected
                bluetoothctl connect $selected'';
            bcn = ''
                bluetoothctl power on
                set btexists $(pgrep -f bluetoothctl)
                [[ -z $btexists ]] && bluetoothctl -t 60 scan on > /dev/null &
                watch -c -n 1 "bluetoothctl devices| grep Device | grep -v '.*-.*-.*-.*-.*-.*' | sort"
                bluetoothctl devices | grep Device | grep -v '.*-.*-.*-.*-.*-.*' | sort | fzf | cut -d' ' -f2 | xargs -I {} bluetoothctl connect {}'';
            bdcn = ''bluetoothctl devices Connected | grep Device | sort | fzf | cut -d' ' -f2 | xargs -I {} bluetoothctl disconnect {}'';
            bcnf = ''bluetoothctl devices Paired | grep Device | sort | fzf | cut -d' ' -f2 | xargs -I {} bluetoothctl remove {}'';

            # === WiFi ===
            sn = ''iwctl station wlan0 scan;iwctl station wlan0 get-networks'';
            cn = ''
                watch -c -n 2 "iwctl station wlan0 scan ; iwctl station wlan0 get-networks"
                set ssid $(iwctl station wlan0 get-networks | fzf --ansi |sed -e 's/ \{10,\}.*//' -e 's/^[[:space:]]*//')
                read -P "Password: " password
                iwctl --passphrase="$password" station wlan0 connect "$ssid"'';
            cnf = ''
                set ssid $(iwctl known-networks list | fzf --ansi |sed -e 's/ \{10,\}.*//' -e 's/^[[:space:]]*//')
                iwctl known-networks $ssid forget'';

            # === Disk / USB ===
            isomount = ''doas mount $argv /mnt ; cd /mnt'';
            nformat = ''
                [ "$(pwd)" = "/mnt" ] && cd ~
                    ls /mnt 2>/dev/null || doas mkdir -p /mnt
                    doas umount /mnt 2>/dev/null;
                    doas cryptsetup close sd"$argv[1]"1 2>/dev/null;
                    doas parted -s /dev/sd"$argv[1]" mklabel msdos;
                    doas parted -s /dev/sd"$argv[1]" mkpart primary 0% 100%;
                    doas cryptsetup luksFormat -q /dev/sd"$argv[1]"1;
                    doas cryptsetup open /dev/sd"$argv[1]"1 sd"$argv[1]"1;
                    doas mkfs.ext4 -q /dev/mapper/sd"$argv[1]"1;
                    doas mount /dev/mapper/sd"$argv[1]"1 /mnt/;
                    doas rm -r /mnt/lost+found
                    doas chown -R "$USER":users /mnt/;
                    cd /mnt;'';
            format = ''
                [ "$(pwd)" = "/mnt" ] && cd ~
                    ls /mnt 2>/dev/null || doas mkdir -p /mnt
                    doas umount /mnt 2>/dev/null;
                    doas cryptsetup close sd"$argv[1]"1 2>/dev/null;
                    doas parted -s /dev/sd"$argv[1]" mklabel msdos;
                    doas parted -s /dev/sd"$argv[1]" mkpart primary 0% 100%;
                    doas mkfs.ext4 -q /dev/sd"$argv[1]"1 &>/dev/null;
                    doas mount /dev/sd"$argv[1]"1 /mnt/;
                    doas rm -r /mnt/lost+found
                    doas chown -R "$USER":users /mnt/;
                    cd /mnt;'';
            formatcomp = ''
                [ "$(pwd)" = "/mnt" ] && cd ~
                    ls /mnt 2>/dev/null || doas mkdir -p /mnt
                    doas umount /mnt 2>/dev/null;
                    doas cryptsetup close sd"$argv"1 2>/dev/null;
                    doas parted -s /dev/sd"$argv" mklabel msdos;
                    doas parted -s /dev/sd"$argv" mkpart primary 0% 100%;
                    doas parted /dev/sd"$argv" type 1 07;
                    doas mkfs.exfat -q /dev/sd"$argv"1 &>/dev/null;
                    doas mount /dev/sd"$argv"1 /mnt/;
                    doas rm -r /mnt/lost+found
                    cd /mnt;'';
            mnt = ''
                [ "$(pwd)" = "/mnt" ] && cd ~
                    ls /mnt 2>/dev/null || doas mkdir -p /mnt
                    doas umount /mnt 2>/dev/null;
                    doas cryptsetup close sd"$argv[1]"1 2>/dev/null;
                    doas cryptsetup open /dev/sd"$argv[1]"1 sd"$argv[1]"1 2>/dev/null;
                    doas mount /dev/mapper/sd"$argv[1]"1 /mnt/ 2>/dev/null || doas mount /dev/sd"$argv[1]"1 /mnt/;
                    doas chown -R "$USER":users /mnt/;
                    cd /mnt;'';
            umnt = ''
                [ "$(pwd)" = "/mnt" ] && cd ~
                    ls /mnt 2>/dev/null || doas mkdir -p /mnt
                    doas umount /mnt/;
                    doas cryptsetup close sd"$argv[1]"1 2>/dev/null;'';

            # === Media / Misc ===
            ay = ''
                yt-dlp --write-auto-sub -q --no-warnings --skip-download -o /tmp/sub $(wl-paste | sed 's|inv.nadeko.net|youtube.com|');
                cat /tmp/sub.en.vtt|
                sed -e '/^[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}\.[0-9]\{3\} -->/d' -e '/^[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}\.[0-9]\{3\}/d' -e 's/<[^>]*>//g'|
                awk 'NF'|
                uniq -d|
                sed 's/$/ /'|
                tr -d '\n'|
                aichat "give a detailed summary of the previous text with the main points. Do not mention any promotions or sponsors."'';
            catbox = ''curl -i -F files[]=@$argv https://uguu.se/upload?output=text | tail -n 1 | wl-copy ; qrrs $(wl-paste) ; echo $(wl-paste) && notify-send "File uploaded"'';
            pdfr = ''pdftk $argv[1] cat 1-end"$argv[2]" output "$argv[1]_$argv[2]".pdf'';

            # === NixOS ===
            rebuild = ''
                set -l upgrade
                contains -- --upgrade $argv
                and set upgrade --upgrade

                set -l nixos_dir ~/dx/nixos
                alejandra --experimental-config /home/soma/dx/nixos/misc/alejandra.toml --quiet $nixos_dir

                git -C $nixos_dir diff --quiet '*.nix'
                and echo "No changes detected, exiting."
                and return 1

                git -C $nixos_dir diff -U0 '*.nix' | tail -n +5
                echo "NixOS Rebuilding..."
                doas nice -n 19 nixos-rebuild switch $upgrade &> $nixos_dir/misc/nixos-switch.log
                and begin
                    set generation $(git -C $nixos_dir diff -U20 HEAD '*.nix' | aichat summarize what changed in my nixos config in one short sentence | sed 's/.$//')
                    git -C $nixos_dir commit -q -am $generation
                    git -C $nixos_dir push -q -u origin main
                    notify-send "Rebuild successful"
                end
                or begin
                    cat $nixos_dir/misc/nixos-switch.log | grep error | tail -n 1
                    notify-send "Rebuild Failed"
                    return 1
                end
            '';
            rebuildu = ''
                rebuild --upgrade
            '';
        };
        shellAbbrs = {
            # === Navigation ===
            "8" = "cd -";
            "9" = "cd ..";
            "0" = "cd ~ ; clear";
            cdn = "cd ~/dn";
            cdx = "cd ~/dx";
            cdc = "cd ~/dx/nixos/misc";
            cdmnt = "cd /mnt/";

            # === File Ops ===
            catpdf = "pdftotext -";
            downscale = "mogrify -resize 50%";
            mkexec = "chmod +x";
            mkd = "mkdir";

            # === Editors / Viewers ===
            o = "handlr open";
            f = "fzf | xargs -I {} handlr open {}";
            z = "zathura";
            mc = "links -dump /run/current-system/sw/share/doc/nixos/options.html | nvim -R -";
            mh = "man home-configuration.nix";

            # === NixOS ===
            nrs = "rebuild";
            nrst = "tail -c +0 -f ~/dx/nixos/misc/nixos-switch.log";
            nrsu = "rebuildu";
            nconf = "vi ~/dx/nixos/configuration.nix";
            nconfl = "vi ~/dx/nixos/librewolf.nix";
            nconfs = "vi ~/dx/nixos/sway.nix";
            nconff = "vi ~/dx/nixos/fish.nix";
            ns = "nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history";
            nsp = "nix-shell -p";

            # === System / Power ===
            d = "doas";
            po = "poweroff";
            rb = "reboot";

            # === Network ===
            nt = "ping google.com";
            ipinfo = "curl -s ipinfo.io | jaq";
            tra = "transmission-cli";
            wgu = "doas systemctl start wg-quick-wg0.service";
            wgd = "doas systemctl stop wg-quick-wg0.service";
            wgr = "doas systemctl restart wg-quick-wg0.service";
            nr = "doas systemctl restart iwd.service";

            # === Finance ===
            eur = "qcalc eur to huf";
            huf = "curl crrcy.sh/last/EUR/HUF/30d";

            # === Tasks / Calendar ===
            vitodo = "vi /home/soma/dx/Backups/todo/todo.txt";
            rv = "vi ~/dx/Backups/remind/remind.rem";
            rp = "vi ~/dx/Backups/remind/past.rem";

            # === Media / Video ===
            porn = "mpv --shuffle /home/soma/px/basketweaving/gif";
            m = "mpv";
            p = "mpv *";
            y = "pipe-viewer";
            yd = "yt-dlp";
            yda = "yt-dlp -x";
            ydp = "yt-dlp -o \"%(playlist_index)s - %(title)s.%(ext)s\"";
            ydap = "yt-dlp -x -o \"%(playlist_index)s - %(title)s.%(ext)s\"";

            # === Translate ===
            t = "trans";
            td = "trans :de";
            tm = "trans :hu";
            tr = "trans :ru";

            # === AI ===
            a = "aichat";
            ai = "aichat --model internet:deepseek/deepseek-v4-pro";
            as = "aichat -s";
            wa = "wl-paste | aichat";
            was = "wl-paste | aichat summarize";
            wae = "wl-paste | aichat explain";
            ae = "aichat explain";
            aex = "aichat give an example for";
            ad = "aichat what is the difference between";
            aw = "aichat provide the etymology, pronounciation without using phonetic symbols, meaning, and usage examples, all on new lines with markdown formatting, of the word";

            # === Misc / Tools ===
            oc = "opencode";
            la = "ls -A";
            ll = "ls -Al";
            lt = "ls -l --sort=modified --reverse";
            nf = "fastfetch";
            b = "btop";
            nb = "newsboat";
            lb = "lsblk";
            qr = "qrrs";
            wq = "wl-paste | xargs -I {} qrrs {}";
            color = "pastel color";
            q = "qalc";
        };
        shellAliases = {
            # === Core File Commands ===
            ls = "eza -F --no-quotes --color-scale-mode=gradient --color-scale=all --group-directories-first --smart-group -o --no-permissions";
            du = "dust";
            grep = "rg -S";
            #ls = "ls -hNF --color";
            mv = "mv -vu";
            rm = "gtrash put";
            cat = "bat --pager less";
            cp = "cp -rvp";
            mkdir = "mkdir -pv";
            head = "head -v";
            wget = "wget -c --hsts-file=~/.cache/wget-hsts";
            ln = "ln -ivP";
            chown = "chown -Rv";
            chmod = "chmod -Rv";
            shred = "shred -uvf -n 1 --remove=wipe";
            jq = "jaq";
            #zathura = "swallow zathura-sandbox";
            zathura = "zathura-sandbox";
            qalc = "qalc -c -s 'upxrates 1'";
            trans = "echo ; /run/current-system/sw/bin/trans -b -j";
            newsboat = "newsboat -q -u /home/soma/dx/nixos/misc/newsboat";
            lsblk = "grc lsblk -n -o NAME,FSTYPE,SIZE,MOUNTPOINT";
            gpg = "/run/current-system/sw/bin/gpg --pinentry-mode loopback";

            # === Search / FZF ===
            fzf = "SHELL=bash FZF_DEFAULT_COMMAND='fd --type f --type l --type d --strip-cwd-prefix' /run/current-system/sw/bin/fzf --preview 'fzf-preview {}' 2>/dev/null";
            fzfa = "SHELL=bash FZF_DEFAULT_COMMAND='fd --type f --type l --type d --hidden --strip-cwd-prefix' /run/current-system/sw/bin/fzf --preview 'fzf-preview {}' 2>/dev/null";

            # === Tasks / Reminders ===
            todo = "ttdl --auto-hide-cols --always-hide-cols=created --no-headers";
            rc = "rem -cumb1";
            rc2 = "rem -cu2mb1";
            rc3 = "rem -cu3mb1";

            # === Recording ===
            "rec" = "pactl set-source-volume @DEFAULT_SOURCE@ 50% ; /run/current-system/sw/bin/rec -c 1 /home/soma/dx/Recordings/$(date \"+%Y-%m-%d %H.%M.%S\").ogg";
            irec = "ffmpeg -ac 1 -f pulse -i record_sink.monitor /home/soma/dx/Recordings/$(date \"+%Y-%m-%d %H.%M.%S\").ogg";

            # === Misc ===
            webn = ''curl -s https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=WEBN.DEX&apikey=7MDJ3EFDVAYP245U | jaq -r '."Global Quote"."05. price"' | sed 's/\(.*\...\).*/\1€/' '';
            life = "watch -t -n 1 -c 'echo \"\\033[91m$(echo \"scale=10; ($(date +%s)-$(date -d $(cat /home/soma/dx/nixos/misc/secrets/birthdate) +%s))/(80*365.2425*86400)*100\"|bc|sed \"s/0*$//\")%\"'";
            wttr = "curl https://wttr.in/budapest?format=1;sunwait list 47.5N 19E";
            speedtest = "speedtest-go -u decimal-bytes";
            steamguard = "steamguard -v warn -m /home/soma/dx/nixos/misc/secrets/steamguard-cli";
            trash = "gtrash restore";
            trashinfo = "gtrash summary";
            trashempty = "gtrash prune --day 0";
        };
    };
}
