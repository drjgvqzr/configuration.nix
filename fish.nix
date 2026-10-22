let
    nixos = "/home/soma/dx/nixos";
in {
    home-manager.users.soma.programs.fish = {
        enable = true;
        functions = {
            # === Fish ===
            fish_prompt = "string join '' -- (set_color red) '%' (set_color white)  (prompt_pwd --dir-length=0) (set_color green) '>' (set_color normal)";
            fish_right_prompt = ''
                set -l age (math "($(date +%s) - $(date -d (cat ~/dx/nixos/misc/secrets/birthdate) +%s)) / (80*365.2425*86400) * 100")
                set_color brred
                printf '%.2f%%' $age | string replace -r '0+%$' '%'
            '';

            # === Disk / USB ===
            isomount = ''doas mount $argv /mnt ; cd /mnt'';
            nformat = ''
                set dev (ls /dev | grep sd | fzf) ||
                    return 1
                [ (pwd) = /mnt ] &&
                    cd ~
                ls /mnt 2>/dev/null ||
                    doas mkdir -p /mnt
                doas umount /mnt 2>/dev/null
                doas cryptsetup close sd"$dev"1 2>/dev/null
                doas parted -s /dev/sd"$dev" mklabel msdos
                doas parted -s /dev/sd"$dev" mkpart primary 0% 100%
                doas cryptsetup luksFormat -q /dev/sd"$dev"1
                doas cryptsetup open /dev/sd"$dev"1 sd"$dev"1
                doas mkfs.ext4 -q /dev/mapper/sd"$dev"1
                doas mount /dev/mapper/sd"$dev"1 /mnt/
                doas rm -r /mnt/lost+found
                doas chown -R "$USER":users /mnt/
                cd /mnt
            '';
            format = ''
                set dev (ls /dev | grep sd | fzf) ||
                    return 1
                [ (pwd) = /mnt ] &&
                    cd ~
                ls /mnt 2>/dev/null ||
                    doas mkdir -p /mnt
                doas umount /mnt 2>/dev/null
                doas cryptsetup close sd"$dev"1 2>/dev/null
                doas parted -s /dev/sd"$dev" mklabel msdos
                doas parted -s /dev/sd"$dev" mkpart primary 0% 100%
                doas mkfs.ext4 -q /dev/sd"$dev"1 &>/dev/null
                doas mount /dev/sd"$dev"1 /mnt/
                doas rm -r /mnt/lost+found
                doas chown -R "$USER":users /mnt/
                cd /mnt
            '';
            formatcomp = ''
                set dev (ls /dev | grep sd | fzf) ||
                    return 1
                [ (pwd) = /mnt ] &&
                    cd ~
                ls /mnt 2>/dev/null ||
                    doas mkdir -p /mnt
                doas umount /mnt 2>/dev/null
                doas cryptsetup close sd"$dev"1 2>/dev/null
                doas parted -s /dev/sd"$dev" mklabel msdos
                doas parted -s /dev/sd"$dev" mkpart primary 0% 100%
                doas parted /dev/sd"$dev" type 1 07
                doas mkfs.exfat -q /dev/sd"$dev"1 &>/dev/null
                doas mount /dev/sd"$dev"1 /mnt/
                doas rm -r /mnt/lost+found
                cd /mnt
            '';
            mnt = ''
                set dev (ls /dev | grep sd | fzf) ||
                    return 1
                [ (pwd) = /mnt ] &&
                    cd ~
                ls /mnt 2>/dev/null ||
                    doas mkdir -p /mnt
                doas umount /mnt 2>/dev/null
                doas cryptsetup close sd"$dev"1 2>/dev/null
                doas cryptsetup open /dev/sd"$dev"1 sd"$dev[1]"1 2>/dev/null
                doas mount /dev/mapper/sd"$dev"1 /mnt/ 2>/dev/null ||
                    doas mount /dev/sd"$dev[1]"1 /mnt/
                doas chown -R "$USER":users /mnt/
                cd /mnt
            '';
            umnt = ''
                [ (pwd) = /mnt ] && cd ~
                ls /mnt 2>/dev/null ||
                    doas mkdir -p /mnt
                doas umount /mnt/
                doas cryptsetup close sd"$dev"1 2>/dev/null
            '';

            # === Misc ===
            ay = ''
                yt-dlp --write-auto-sub -q --no-warnings --skip-download -o /tmp/sub $(wl-paste | sed 's|inv.nadeko.net|youtube.com|');
                cat /tmp/sub.en.vtt |
                sed -e '/^[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}\.[0-9]\{3\} -->/d' -e '/^[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}\.[0-9]\{3\}/d' -e 's/<[^>]*>//g' |
                awk 'NF' |
                uniq -d |
                sed 's/$/ /' |
                tr -d '\n' |
                aichat Summarize the YouTube video. Do not mention any promotions or sponsors.
            '';
            catbox = ''
                curl -# -F files[]=@$argv https://uguu.se/upload?output=text |
                    wl-copy &&
                        notify-send "File uploaded"
                qrrs $(wl-paste)
                echo $(wl-paste)
            '';
            pdfr = ''
                pdftk $argv[1] cat 1-end"$argv[2]" output "$argv[1]_$argv[2]".pdf
            '';
            sn = ''
                iwctl station wlan0 scan
                iwctl station wlan0 get-networks
            '';

            # === NixOS ===
            rebuild = ''
                ${nixos}/misc/rebuild.sh
            '';
        };
        shellAbbrs = {
            # === Navigation ===
            "8" = "cd -";
            "9" = "cd ..";
            "0" = "cd ~ ; clear";
            cdn = "cd ~/dn";
            cdx = "cd ~/dx";
            cdc = "cd ${nixos}";
            cdm = "cd /mnt";

            # === File Ops ===
            catpdf = "pdftotext -";
            downscale = "mogrify -resize 50%";
            mkexec = "chmod +x";
            selfdestruct = "doas cryptsetup luksErase /dev/nvme0n1p2";

            # === Editors / Viewers ===
            o = "handlr open";
            f = "fzf | xargs -I {} handlr open {} 2>/dev/null";
            z = "zathura";
            mc = "links -dump /run/current-system/sw/share/doc/nixos/options.html | nvim -R -";
            mh = "man home-configuration.nix";

            # === NixOS ===
            nrs = "rebuild";
            nrst = "tail -c +0 -f ~/dx/nixos/misc/.nixos-switch.log";
            nconf = "vi ~/dx/nixos/configuration.nix";
            nconfl = "vi ~/dx/nixos/librewolf.nix";
            nconfs = "vi ~/dx/nixos/sway.nix";
            nconff = "vi ~/dx/nixos/fish.nix";
            nsp = "nix-shell -p";

            # === System / Power ===
            d = "doas";
            po = "poweroff";
            rb = "reboot";

            # === Network ===
            nt = "ping google.com";
            ipinfo = "curl -s ipinfo.io | jaq";
            wgu = "doas systemctl start wg-quick-wg0.service";
            wgd = "doas systemctl stop wg-quick-wg0.service";
            wgr = "doas systemctl restart wg-quick-wg0.service";
            nr = "doas systemctl restart iwd.service";

            # === Finance ===
            eur = "qalc eur to huf";
            huf = "curl crrcy.sh/last/EUR/HUF/30d";

            # === Media / Video ===
            porn = "mpv --shuffle ~/px/basketweaving/gif";
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
            ai = "aichat --model internet";
            ais = "aichat --model internet -s";
            as = "aichat -s";
            wa = "wl-paste | aichat";
            wai = "wl-paste | aichat --model internet";
            waf = "wl-paste | aichat how to fix";
            waif = "wl-paste | aichat --model internet how to fix";
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
            lt = "ls -l -s modified";
            lS = "ls -l -s size --total-size";
            nf = "fastfetch";
            b = "btop";
            nb = "newsboat";
            nbv = "vi ~/dx/nixos/misc/newsboat";
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
            cal = "cal -m";
            mv = "mv -u";
            rm = "gtrash put";
            cat = "bat --pager less";
            cp = "cp -rp";
            mkdir = "mkdir -p";
            wget = "wget -c --hsts-file=~/.cache/wget-hsts";
            ln = "ln -ivP";
            chown = "chown -Rv";
            chmod = "chmod -Rv";
            shred = "shred -uvf -n 1 --remove=wipe";
            jq = "jaq";
            zathura = "zathura-sandbox";
            qalc = "qalc -c -s 'upxrates 1'";
            trans = "trans -b -j";
            newsboat = "newsboat -q -u ${nixos}/misc/newsboat";
            lsblk = "grc lsblk -n -o NAME,FSTYPE,SIZE,MOUNTPOINT";
            gpg = "gpg --pinentry-mode loopback";

            # === Search / FZF ===

            fzf = "SHELL=bash FZF_DEFAULT_COMMAND=' fd --type f --type l --type d --strip-cwd-prefix' /run/current-system/sw/bin/fzf --preview 'fzf-preview {}' 2>/dev/null";
            fzfa = "SHELL=bash FZF_DEFAULT_COMMAND=' fd --type f --type l --type d --hidden --strip-cwd-prefix' /run/current-system/sw/bin/fzf --preview 'fzf-preview {}' 2>/dev/null";

            # === Trash ===

            trash = "gtrash restore";
            trashinfo = "gtrash summary";
            trashempty = "gtrash prune --day 0";

            # === Misc ===

            speedtest = "speedtest-go -u decimal-bytes";
            steamguard = "steamguard -v warn -m ${nixos}/misc/secrets/steamguard-cli";
        };
        shellInit = ''
            set fish_greeting
            fish_default_key_bindings

            [ (tty) = /dev/tty1 ] && exec sway

            function __ls_after_cd__on_variable_pwd --on-variable PWD
                if status --is-interactive
                    eza -F --no-quotes --group-directories-first
                end
            end

            rm -d ~/Downloads 2> /dev/null

            any-nix-shell fish | source
        '';
    };
}
