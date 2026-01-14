{
    config,
    pkgs,
    lib,
    ...
}: {
    home-manager.users.soma.programs.fish = {
        enable = true;
        functions = {
            fish_prompt = "string join '' -- (set_color red) '%' (set_color white)  (prompt_pwd --dir-length=0) (set_color green) '>' (set_color normal)";
            fish_mode_prompt = "";
            s = ''links "https://lite.duckduckgo.com/lite/?q=$argv"'';
            sdh = ''links "https://lite.duckduckgo.com/lite/?q=$argv&kl=hu-hu"'';
            sud = ''links "https://rd.vern.cc/define.php?term=$argv"'';
            sg = ''links "https://github.com/search?q=$argv&s=stars"'';
            w = ''links "https://en.wikipedia.org/wiki/$argv?useskin=minerva#bodyContent"'';
            we = ''links "https://en.wiktionary.org/wiki/$argv#English"'';
            pb = ''links "https://thepiratebay.party/search/$argv"'';
            ay = ''
                yt-dlp --write-auto-sub -q --no-warnings --skip-download -o /tmp/sub $(wl-paste | sed 's|inv.nadeko.net|youtube.com|');
                cat /tmp/sub.en.vtt|
                sed -e '/^[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}\.[0-9]\{3\} -->/d' -e '/^[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}\.[0-9]\{3\}/d' -e 's/<[^>]*>//g'|
                awk 'NF'|
                uniq -d|
                sed 's/$/ /'|
                tr -d '\n'|
                aichat "give a detailed summary of the previous text with the main points. Do not mention any promotions or sponsors."'';
            "4" = ''
                curl -sL $(wl-paste)|
                grep -o 'is2.4chan.org[^"]*webm'|
                uniq|
                sed s.^.https://.|
                mpv --playlist=-'';
            "4d" = ''
                curl -sL $(wl-paste)|
                grep -o 'is2.4chan.org[^"]*webm'|
                uniq|
                sed s.^.https://.|
                xargs -I {} wget -nc -P ~/Videos/$argv[1] {}'';
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
            sn = ''iwctl station wlan0 scan;iwctl station wlan0 get-networks'';
            cn = ''
                watch -c -n 1 "iwctl station wlan0 scan ; iwctl station wlan0 get-networks"
                set ssid $(iwctl station wlan0 get-networks | fzf --ansi |sed -e 's/ \{10,\}.*//' -e 's/^[[:space:]]*//')
                read -P "Password: " password
                iwctl --passphrase="$password" station wlan0 connect "$ssid"'';
            cnf = ''
                set ssid $(iwctl known-networks list | fzf --ansi |sed -e 's/ \{10,\}.*//' -e 's/^[[:space:]]*//')
                iwctl known-networks $ssid forget'';
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
            wformat = ''
                [ "$(pwd)" = "/mnt" ] && cd ~
                    ls /mnt 2>/dev/null || doas mkdir -p /mnt
                    doas umount /mnt 2>/dev/null;
                    doas parted -s /dev/mmcblk0 mklabel msdos;
                    doas parted -s /dev/mmcblk0 mkpart primary 0% 100%;
                    doas mkfs.ext4 -q /dev/mmcblk0p1 &>/dev/null;
                    doas mount /dev/mmcblk0p1 /mnt/;
                    doas rm -r /mnt/lost+found
                    doas chown -R "$USER":users /mnt/;
                    cd /mnt;'';
            wmnt = ''
                [ "$(pwd)" = "/mnt" ] && cd ~
                    ls /mnt 2>/dev/null || doas mkdir -p /mnt
                    doas umount /mnt 2>/dev/null;
                    doas mount /dev/mmcblk0p1 /mnt/;
                    doas chown -R "$USER":users /mnt/;
                    cd /mnt;'';
            wumnt = ''
                [ "$(pwd)" = "/mnt" ] && cd ~
                    ls /mnt 2>/dev/null || doas mkdir -p /mnt
                    doas umount /mnt/;'';
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
            rebuild = ''
                set nixos_dir ~/dx/nixos
                alejandra --experimental-config /home/soma/dx/nixos/misc/alejandra.toml --quiet $nixos_dir
                git -C $nixos_dir diff --quiet '*.nix' &&
                    echo "No changes detected, exiting." &&
                    return 1
                git -C $nixos_dir diff --color=always -U0 '*.nix' | tail -n +5
                echo "NixOS Rebuilding..."
                doas nice -n 19 nixos-rebuild switch &> $nixos_dir/misc/nixos-switch.log && {
                  set generation $(git -C $nixos_dir diff -U20 HEAD '*.nix' | aichat summarize what changed in my nixos config in one short sentence | sed 's/.$//' )
                  git -C $nixos_dir commit -q -am $generation
                  git -C $nixos_dir push -q -u origin main
                  echo "$generation"
                  notify-send -e -t 5000 "Rebuild successful"
                } || {
                  cat $nixos_dir/misc/nixos-switch.log | grep -i --color error | tail -n 1
                  notify-send -e -t 5000 "Rebuild Failed"
                  return 1
                  }'';
            rebuildu = ''
                set nixos_dir ~/dx/nixos
                alejandra --experimental-config /home/soma/dx/nixos/misc/alejandra.toml --quiet $nixos_dir
                git -C $nixos_dir diff -U0 '*.nix'
                echo "NixOS Rebuilding..."
                doas nice -n 19 nixos-rebuild switch --upgrade &> $nixos_dir/misc/nixos-switch.log && {
                    set generation $(git -C $nixos_dir diff -U20 HEAD '*.nix' | aichat summarize what changed in my nixos config in one short sentence | sed 's/.$//' )
                    git -C $nixos_dir commit -q -am $generation
                    git -C $nixos_dir push -q -u origin main
                    echo "\n$generation"
                    notify-send -e -t 5000 "Rebuild successful"
                } || {
                    cat $nixos_dir/misc/nixos-switch.log | grep --color error | tail -n 1
                    notify-send -e -t 5000 "Rebuild Failed"
                    return 1
                }'';
            pdfr = ''
                pdftk $argv[1] cat 1-end"$argv[2]" output $(echo "$argv[1]" | sed 's/\.[^.]*$//')-"$argv[2]".pdf'';
            cb = ''curl -F "reqtype=fileupload" -F "time=72h" -F "fileToUpload=@$argv" https://litterbox.catbox.moe/resources/internals/api.php | wl-copy ; notify-send "File uploaded"'';
        };
        shellAbbrs = {
            "8" = "cd -";
            "9" = "cd ..";
            d = "doas";
            q = "qalc";
            o = "handlr open";
            f = "yazi";
            qr = "qrrs";
            cr = "cook r (fd cook ~/dx/Backups/cook | fzf )";
            h = "hledger";
            ha = "hledger add";
            mc = "man configuration.nix";
            mh = "man home-configuration.nix";
            z = "zathura";
            nb = "newsboat";
            nsp = "nix-shell -p";
            nt = "ping google.com";
            cdcook = "cd ~/dx/Backups/cook";
            pomo = "doas systemctl stop iwd.service ; timer -f 30m ; notify-send \"Pomodoro over\" ; doas systemctl start iwd.service ; timer -f 5m";
            nr = "doas systemctl restart iwd.service wg-quick-wg0.service";
            y = "pipe-viewer";
            wq = "wl-paste | xargs -I {} qrrs {}";
            color = "pastel color";
            tempmail = "mailsy";
            yd = "yt-dlp";
            yda = "yt-dlp -x";
            ydap = "yt-dlp -x -o \"%(playlist_index)s - %(title)s.%(ext)s\"";
            mkexec = "chmod +x";
            ta = "task add";
            tl = "task list";
            nrs = "rebuild";
            nrst = "tail -c +0 -f ~/dx/nixos/misc/nixos-switch.log";
            nrsv = "vi ~/dx/nixos/misc/nixos-switch.log";
            nrsu = "rebuildu";
            nconf = "vi ~/dx/nixos/configuration.nix";
            nconfl = "vi ~/dx/nixos/librewolf.nix";
            nconfs = "vi ~/dx/nixos/sway.nix";
            nconff = "vi ~/dx/nixos/fish.nix";
            ns = "nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history";
            sw = "sway";
            gal = "shotwell";
            po = "poweroff";
            hn = "hibernate";
            rb = "reboot";
            la = "ls -A";
            ll = "ls -Al";
            lv = "ls -hpNFl --color";
            lt = "ls -hpNFltr --color";
            lS = "ls -hpNFlSr --color";
            tree = "tree --dirsfirst -CF";
            da = "date \"+%H:%M\"|figlet;cal";
            nf = "fastfetch";
            tra = "transmission-cli";
            #tra="transmission-cli $(wl-paste)";
            l = "links";
            v = "vi";
            m = "mpv";
            mt = "mpv --no-really-quiet";
            mtp = "mpv --no-really-quiet *";
            p = "mpv *";
            cdn = "cd ~/dn";
            cdx = "cd ~/dx";
            cdc = "cd ~/dx/nixos/misc";
            b = "btop";
            wgu = "doas systemctl start wg-quick-wg0.service";
            wgd = "doas systemctl stop wg-quick-wg0.service";
            wgr = "doas systemctl restart wg-quick-wg0.service";
            mkd = "mkdir";
            lb = "lsblk";
            t = "trans";
            td = "trans :de";
            tm = "trans :hu";
            tr = "trans :ru";
            a = "aichat";
            as = "aichat -s";
            wa = "wl-paste | aichat";
            aex = "aichat -e";
            ax = "aichat explain";
            ae = "aichat give an example for";
            ad = "aichat what is the difference between";
            aw = "aichat provide the etymology, pronounciation without using phonetic symbols, meaning, and usage examples, all on new lines with markdown formatting, of the word";
        };
        shellAliases = {
            cdmnt = ''cd /mnt/'';
            "0" = "cd ~;clear";
            hibernate = "systemctl hibernate";
            #zathura = "swallow zathura";
            fastfetch = "fastfetch --logo nixos_old";
            "rec" = "pactl set-source-volume @DEFAULT_SOURCE@ 50% ; /run/current-system/sw/bin/rec -c 1 /home/soma/dx/Recordings/$(date \"+%Y-%m-%d %H.%M.%S\").ogg";
            irec = "ffmpeg -ac 1 -f pulse -i record_sink.monitor /home/soma/dx/Recordings/$(date \"+%Y-%m-%d %H.%M.%S\").ogg";
            qalc = "qalc -c -s 'upxrates 1'";
            ls = "ls -hpNF --color";
            mv = "mv -vu";
            rm = "gtrash put";
            cat = "bat --pager less";
            gpg = "/run/current-system/sw/bin/gpg --pinentry-mode loopback";
            trash = "gtrash restore";
            fontname = ''/run/current-system/sw/bin/ls /nix/var/nix/profiles/system/sw/share/X11/fonts | fzf | xargs -I {} fc-query /nix/var/nix/profiles/system/sw/share/X11/fonts/{} | grep '^\s\+family:' | cut -d'"' -f2'';
            trashinfo = "gtrash summary";
            newsboat = "newsboat -q -u /home/soma/dx/nixos/misc/newsboat";
            grep = "grep -i --color";
            mkdir = "mkdir -pv";
            mw = "mpv $(wl-paste)";
            head = "head -v";
            cp = "cp -rvp";
            cal = "cal -mw";
            wget = "wget -c --hsts-file=~/.cache/wget-hsts";
            rename = "rename -iv";
            ln = "ln -ivP";
            chown = "chown -Rv";
            chmod = "chmod -Rv";
            shred = "shred -uvf -n 1 --remove=wipe";
            wttr = "curl https://wttr.in/budapest;sunwait list 47.62344395N 19.04990553124715E";
            speedtest = "speedtest-go -u decimal-bytes";
            trans = "echo ; /run/current-system/sw/bin/trans -b -j";
            diff = "grc --colour on diff";
            du = "grc --colour=auto du -h";
            env = "grc --colour=auto env";
            lsblk = "grc --colour=auto lsblk -n -o NAME,FSTYPE,SIZE,MOUNTPOINT";
            lsmod = "grc --colour=auto lsmod";
            lspci = "grc --colour=auto lspci";
            make = "grc --colour=auto make";
            ping = "grc --colour=auto ping";
            stat = "grc --colour=auto stat";
        };
        shellInit = ''
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

            set TTY1 (tty)
            [ "$TTY1" = "/dev/tty1" ] && exec sway

            set -q LS_AFTER_CD || set -xg LS_AFTER_CD true
            function __ls_after_cd__on_variable_pwd --on-variable PWD
                if test "$LS_AFTER_CD" = true; and status --is-interactive
                    ls -hpNF --color
                end
            end

            any-nix-shell fish | source

        '';
    };
}
