{
    config,
    pkgs,
    lib,
    ...
}: {
    imports = [
        /etc/nixos/hardware-configuration.nix
        "${
            builtins.fetchTarball {
                url = "https://github.com/nix-community/home-manager/archive/master.tar.gz";
            }
        }/nixos"
        ./librewolf.nix
        ./sway.nix
        ./fish.nix
        ./misc/thunderbird.nix
        #./misc/printing.nix
    ];
    environment.systemPackages = with pkgs; [
        #CLI
        alejandra
        android-tools
        any-nix-shell
        autotiling-rs
        backgroundremover
        bat
        catdocx
        cointop
        cook-cli
        dash
        doxx
        exfatprogs
        f3
        fastfetch
        fbcat
        fd
        fdupes
        ffmpeg
        figlet
        fishPlugins.autopair
        fishPlugins.puffer
        fzf
        gallery-dl
        gh
        ghc
        glow
        gnumake
        grc
        groff
        gtrash
        handlr-regex
        heimdall
        hledger
        hyperfine
        iftop
        imagemagick
        inxi
        jmtpfs
        jq
        libnotify
        libqalculate
        libreoffice
        links2
        lolcat
        mailsy
        mapscii
        nautilus
        ncdu
        nixos-anywhere
        nix-search-tv
        ocrmypdf
        openai-whisper
        ouch
        pandoc
        parted
        pastel
        pciutils
        pdftk
        pipe-rename
        piper-tts
        pipe-viewer
        poppler-utils
        presenterm
        prismlauncher
        pulsemixer
        qrrs
        rclone
        remind
        ripgrep
        ripgrep-all
        rsync
        smartmontools
        sox
        speedread
        speedtest-go
        stc-cli
        stress
        sunwait
        ticker
        tickrs
        timer
        tldr
        toipe
        translate-shell
        transmission_4-gtk
        tree
        undollar
        unoconv
        wget
        woeusb
        xdg-utils
        zbar

        #Wayland
        brightnessctl
        grim
        hunspell
        hunspellDicts.en_US-large
        hunspellDicts.hu_HU
        hyprpicker
        i3-swallow
        slurp
        swaybg
        swayidle
        swaylock
        wayprompt
        wev
        wf-recorder
        wl-clipboard-rs
        wmenu

        #GUI
        audacity
        firefox
        fluffychat
        gimp
        #googleearth-pro
        kdePackages.kolourpaint
        kdiskmark
        logseq
        lutris
        mullvad-browser
        onlyoffice-desktopeditors
        pavucontrol
        qdirstat
        shotwell
        #starsector # TEITW-HP9ON-A7HMK-WA6YA
        tor-browser
        ungoogled-chromium
        vesktop
        zotero
    ];
    boot = {
        kernelParams = ["fbcon=rotate:1" "video=DSI-1:panel_orientation=right_side_up"];
        initrd = {
            checkJournalingFS = true;
            luks.devices."luks".allowDiscards = true;
            systemd.enable = true;
        };
        kernelPackages = pkgs.linuxPackages_latest;
        loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
            timeout = 0;
        };
    };
    console.useXkbConfig = true;
    environment = {
        binsh = "${pkgs.dash}/bin/dash";
        defaultPackages = [];
        pathsToLink = ["/share/xdg-desktop-portal" "/share/applications"];
        shells = with pkgs; [fish];
        sessionVariables = {
            BROWSER = "xdg-open";
            EDITOR = "nvim";
            GIT_PAGER = "less -R";
            DOTREMINDERS = "$HOME/dx/Backups/remind/remind.rem";
            LEDGER_FILE = "$HOME/dx/Backups/finance/2025.journal";
            MANPAGER = "nvim +Man!";
            PAGER = "nvim -R +AnsiEsc";
            XDG_CACHE_HOME = "$HOME/.cache";
            XDG_CONFIG_HOME = "$HOME/.config";
            XDG_DATA_HOME = "$HOME/.local/share";
            XDG_STATE_HOME = "$HOME/.local/state";
            XDG_DESKTOP_DIR = "$HOME/ar";
            XDG_DOCUMENTS_DIR = "$HOME/dx";
            XDG_DOWNLOAD_DIR = "$HOME/dn";
            XDG_MUSIC_DIR = "$HOME/mu";
            XDG_PICTURES_DIR = "$HOME/px";
            XDG_VIDEOS_DIR = "$HOME/vs";
        };
    };
    fonts = {
        fontDir.enable = true;
        packages = with pkgs; [roboto-mono noto-fonts-color-emoji unifont];
        fontconfig = {
            enable = true;
            defaultFonts = {
                monospace = ["Roboto Mono"];
                serif = ["Roboto Mono"];
                sansSerif = ["Roboto Mono"];
                emoji = ["Noto Color Emoji"];
            };
        };
    };
    hardware = {
        bluetooth = {
            enable = true;
            powerOnBoot = false;
        };
        cpu.intel.updateMicrocode = true;
        graphics.enable = true;
    };
    i18n.defaultLocale = "en_US.UTF-8";
    networking = {
        enableIPv6 = true;
        dhcpcd.enable = false;
        hostName = "Laptop";
        nameservers = ["1.1.1.1"];
        networkmanager.enable = false;
        nftables.enable = true;
        useDHCP = false;
        wg-quick.interfaces.wg0.configFile = "/home/soma/dx/nixos/misc/secrets/wg.conf";
        wireless.iwd = {
            enable = true;
            settings = {
                General = {
                    EnableNetworkConfiguration = true;
                    AddressRandomization = "network";
                };
            };
        };
    };
    nix = {
        gc = {
            automatic = true;
            dates = "weekly";
        };
        optimise = {
            automatic = true;
            dates = "monthly";
        };
    };
    nixpkgs.config = {
        permittedInsecurePackages = [
            "googleearth-pro-7.3.6.10201"
            "librewolf-bin-147.0.2-1"
            "librewolf-bin-unwrapped-147.0.2-1"
        ];
        allowUnfreePredicate = pkg:
            builtins.elem (lib.getName pkg) [
                "googleearth-pro"
                "steam"
                "steam-unwrapped"
            ];
    };
    programs = {
        bash.shellInit = "export HISTFILE=/tmp/bash_history";
        command-not-found.enable = true;
        dconf.enable = true;
        fish.enable = true;
        git = {
            enable = true;
            config = [
                {
                    user = {
                        name = "soma";
                        email = "ligma@mailbox.org";
                    };
                }
            ];
        };
        gnupg.agent = {
            enable = true;
            pinentryPackage = pkgs.wayprompt;
        };
        localsend.enable = true;
        nano.enable = false;
        steam.enable = true;
    };
    security = {
        doas = {
            enable = true;
            extraRules = [
                {
                    users = ["soma"];
                    keepEnv = true;
                    noPass = true;
                }
            ];
        };
        pam.services.swaylock = {};
        rtkit.enable = true;
        sudo.enable = false;
    };
    swapDevices = [
        {
            device = "/var/lib/swapfile";
            size = 16000;
        }
    ];
    system = {
        autoUpgrade.enable = true;
        stateVersion = "24.11";
    };
    systemd.sleep.extraConfig = "HibernateDelaySec=1h";
    services = {
        auto-cpufreq = {
            enable = true;
            settings = {
                charger = {
                    governor = "powersave";
                    energy_performance_preference = "balance_performance";
                    energy_perf_bias = "balance_performance";
                };
                battery = {
                    governor = "powersave";
                    energy_performance_preference = "power";
                    energy_perf_bias = "power";
                };
            };
        };
        getty = {
            autologinUser = "soma";
            autologinOnce = true;
            extraArgs = [
                "--noissue"
                "-N"
                "--nohostname"
            ];
            greetingLine = "";
        };
        gnome.gnome-keyring.enable = true;
        logind.settings.Login = {
            HandleLidSwitch = "suspend-then-hibernate";
            HandleLidSwitchExternalPower = "suspend-then-hibernate";
            HandlePowerKey = "suspend-then-hibernate";
            HandlePowerKeyLongPress = "suspend-then-hibernate";
        };
        ollama = {
            enable = true;
            loadModels = ["deepseek-r1:1.5b"];
        };
        pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
        };
        playerctld.enable = true;
        resolved = {
            enable = true;
            settings.Resolve = {
                DNS = config.networking.nameservers;
                DNSOverTLS = "true";
                DNSSEC = "true";
                Domains = ["~."];
            };
        };
        syncthing = {
            enable = true;
            dataDir = "/home/soma";
            group = "users";
            openDefaultPorts = true;
            user = "soma";
            cert = "/home/soma/dx/nixos/misc/secrets/cert.pem";
            key = "/home/soma/dx/nixos/misc/secrets/key.pem";
            settings = {
                devices = {
                    "Backup".id = lib.strings.trim (builtins.readFile /home/soma/dx/nixos/misc/secrets/Backup_st-id);
                    "Laptop".id = lib.strings.trim (builtins.readFile /home/soma/dx/nixos/misc/secrets/Laptop_st-id);
                    "Phone".id = lib.strings.trim (builtins.readFile /home/soma/dx/nixos/misc/secrets/Phone_st-id);
                };
                folders = {
                    "ar" = {
                        path = "~/ar";
                        id = "ciwug-fwawa";
                        devices = [
                            "Laptop"
                            "Backup"
                        ];
                        versioning = {
                            type = "trashcan";
                            params.cleanoutDays = "30";
                        };
                    };
                    "dn" = {
                        path = "~/dn";
                        id = "eztfs-xg2pf";
                        devices = [
                            "Laptop"
                            "Backup"
                            "Phone"
                        ];
                        versioning = {
                            type = "trashcan";
                            params.cleanoutDays = "30";
                        };
                    };
                    "dx" = {
                        path = "~/dx";
                        id = "oh2oz-9t565";
                        devices = [
                            "Laptop"
                            "Backup"
                            "Phone"
                        ];
                        versioning = {
                            type = "trashcan";
                            params.cleanoutDays = "30";
                        };
                    };
                    "mu" = {
                        path = "~/mu";
                        id = "sytcm-5kzcc";
                        devices = [
                            "Laptop"
                            "Backup"
                            "Phone"
                        ];
                        versioning = {
                            type = "trashcan";
                            params.cleanoutDays = "30";
                        };
                    };
                    "ph" = {
                        path = "~/ph";
                        id = "domno-sd3ps";
                        devices = [
                            "Laptop"
                            "Backup"
                            "Phone"
                        ];
                        versioning = {
                            type = "trashcan";
                            params.cleanoutDays = "30";
                        };
                    };
                    "px" = {
                        path = "~/px";
                        id = "d0ind-uzt2e";
                        devices = [
                            "Laptop"
                            "Backup"
                            "Phone"
                        ];
                        versioning = {
                            type = "trashcan";
                            params.cleanoutDays = "30";
                        };
                    };
                    "vs" = {
                        path = "~/vs";
                        id = "7sr22-b5ui1";
                        devices = [
                            "Laptop"
                            "Backup"
                        ];
                        versioning = {
                            type = "trashcan";
                            params.cleanoutDays = "30";
                        };
                    };
                };
            };
        };
        thermald.enable = true;
        vnstat.enable = true;
        xserver = {
            xkb.layout = "us";
            xkb.variant = "colemak_dh";
            xkb.options = "caps:backspace";
            exportConfiguration = true;
        };
    };
    time.timeZone = "Europe/Budapest";
    users = {
        defaultUserShell = pkgs.fish;
        users.soma = {
            isNormalUser = true;
            extraGroups = [
                "wheel"
                "adbusers"
            ];
        };
    };
    home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        backupFileExtension = "backup";
    };
    home-manager.users.soma = {
        accounts.email.accounts = {
            mailbox = {
                enable = true;
                thunderbird.enable = true;
                primary = true;
                address = lib.strings.trim (builtins.readFile /home/soma/dx/nixos/misc/secrets/email);
                realName = "John Smith";
                userName = lib.strings.trim (builtins.readFile /home/soma/dx/nixos/misc/secrets/email);
                imap.authentication = "plain";
                imap.host = "imap.mailbox.org";
                imap.port = 993;
                smtp.authentication = "plain";
                smtp.host = "smtp.mailbox.org";
                smtp.port = 465;
            };
        };
        programs.thunderbird = {
            enable = true;
            profiles.default.isDefault = true;
        };
        programs.yazi = {
            enable = true;
            settings = {
                mgr = {
                    sort_by = "natural";
                    sort_sensitive = false;
                    sort_dir_first = true;
                    sort_translit = true;
                    show_symlink = true;
                };
            };
            initLua = ''
                require("full-border"):setup()
                require("no-status"):setup()'';
            keymap = {
                confirm.prepend_keymap = [
                    {
                        on = ["i"];
                        run = "close --submit";
                    }
                    {
                        on = ["m"];
                        run = "close";
                    }
                ];
                mgr.prepend_keymap = [
                    {
                        on = ["m"];
                        run = "leave";
                    }
                    {
                        on = ["n"];
                        run = "arrow 1";
                    }
                    {
                        on = ["e"];
                        run = "arrow -1";
                    }
                    {
                        on = ["i"];
                        run = "plugin smart-enter";
                    }
                    {
                        on = ["N"];
                        run = "find_arrow";
                    }
                    {
                        on = ["E"];
                        run = "find_arrow --previous";
                    }
                    {
                        on = ["k"];
                        run = "seek 5";
                    }
                    {
                        on = ["j"];
                        run = "seek -5";
                    }
                    {
                        on = ["C-["];
                        run = "escape";
                    }
                    {
                        on = ["q"];
                        run = "quit";
                    }
                    {
                        on = ["C-c"];
                        run = "close";
                    }
                    {
                        on = ["C-z"];
                        run = "suspend";
                    }
                ];
            };
        };
        programs.aichat = {
            enable = true;
            settings = {
                clients = [
                    {
                        type = "openai-compatible";
                        name = "openrouter";
                        api_base = "https://openrouter.ai/api/v1";
                        api_key = lib.strings.trim (builtins.readFile /home/soma/dx/nixos/misc/secrets/openrouter);
                        models = [
                            {
                                name = "deepseek/deepseek-v3.2";
                                system_prompt_prefix = lib.strings.trim (builtins.readFile /home/soma/dx/nixos/misc/ai_sysprompt);
                                reasoning = {
                                    exclude = true;
                                };
                            }
                            {
                                name = "thenlper/gte-base";
                                type = "embedding";
                            }
                        ];
                    }
                    {
                        type = "openai-compatible";
                        name = "ollama";
                        api_base = "http://localhost:11434/v1";
                        models = [
                            {
                                name = "deepseek-r1:1.5b";
                                system_prompt_prefix = lib.strings.trim (builtins.readFile /home/soma/dx/nixos/misc/ai_sysprompt);
                            }
                        ];
                    }
                ];
                save = true;
                save_session = false;
                wrap = "auto";
                wrap_code = true;
                keybindings = "vi";
                rag_embedding_model = "openrouter:thenlper/gte-base";
                rag_chunk_size = 1000;
                rag_chunk_overlap = 50;
                document_loaders = {
                    pdf = "pdftotext $1 -";
                    epub = "pandoc --to plain $1";
                    docx = "pandoc --to plain $1";
                    odt = "pandoc --to plain $1";
                    pptx = "sh -c \"unoconv -d presentation -f pdf --stdout $1 |pdftotext - -\"";
                };
            };
        };
        programs.dircolors = {
            enable = true;
            settings = {
                ".pdf" = "01;93";
                ".epub" = "01;93";
                ".pptx" = "01;33";
                ".docx" = "01;33";
                ".odt" = "01;33";
                ".xlsx" = "01;33";
                ".rtf" = "01;33";
            };
        };
        programs.foot = {
            enable = true;
            settings = {
                main = {
                    font = "Roboto Mono:size=14";
                    selection-target = "clipboard";
                    pad = "5x0";
                };
                bell.system = false;
                scrollback.lines = 100000;
                cursor.underline-thickness = "2px";
                mouse.hide-when-typing = true;
                colors = {
                    background = "000000";
                    foreground = "ffffff";
                    regular0 = "000000";
                    regular1 = "aa0000";
                    regular2 = "00aa00";
                    regular3 = "aa5500";
                    regular4 = "3333ff";
                    regular5 = "aa00aa";
                    regular6 = "00aaaa";
                    regular7 = "aaaaaa";
                    bright0 = "555555";
                    bright1 = "ff5555";
                    bright2 = "55ff55";
                    bright3 = "ffff55";
                    bright4 = "5555ff";
                    bright5 = "ff55ff";
                    bright6 = "55ffff";
                    bright7 = "ffffff";
                };
                key-bindings = {
                    clipboard-paste = "Control+v";
                    scrollback-up-page = "Control+Page_Up";
                    scrollback-down-page = "Control+Page_Down";
                    scrollback-home = "Control+Home";
                    scrollback-end = "Control+End";
                    show-urls-copy = "Control+y";
                    search-start = "Control+Shift+r";
                };
            };
        };
        programs.taskwarrior = {
            enable = true;
            config = {
                data.location = "/home/soma/dx/Backups/task";
                verbose = "nothing";
            };
        };
        programs.mpv = {
            enable = true;
            config = {
                fullscreen = "yes";
                volume = "100";
                term-osd-bar-chars = "[/|\\]";
                gapless-audio = "yes";
                gpu-context = "wayland";
                image-display-duration = "inf";
                audio-display = "no";
                msg-level = "vo/gpu=no,vo/ffmpeg=no,ffmpeg/demuxer=no";
                term-osd-bar = "yes";
                slang = "en,de";
                sid = "no";
                volume-max = "100";
                osd-font = "Roboto Mono";
                sub-font = "Roboto Mono";
                input-default-bindings = false;
            };
            scriptOpts = {
                stats.key_page_0 = "2";
                webtorrent.path = "/home/soma/tr/";
                sponsorblock_minimal.categories = "sponsor;selfpromo;interaction;intro;outro;preview;hook;music_offtopic;filler";
            };
            scripts = with pkgs.mpvScripts; [
                webtorrent-mpv-hook
                sponsorblock-minimal
                mpris
            ];
            bindings = {
                "Shift+RIGHT" = "seek 1";
                "Shift+LEFT" = "seek -1";
                RIGHT = "seek 5";
                LEFT = "seek -5";
                UP = "seek 60";
                DOWN = "seek -60";
                a = "add video-pan-x  +0.1";
                s = "add video-pan-x  -0.1";
                w = "add video-pan-y  +0.1";
                r = "add video-pan-y  -0.1";
                R = "cycle_values video-rotate 90 180 270 0";
                t = "add video-zoom   +0.1";
                d = "add video-zoom   -0.1";
                c = "set video-zoom 0 ; set video-pan-x 0 ; set video-pan-y 0";
                "]" = "script-binding stats/display-stats";
                "\\" = "show-progress";
                "0" = "cycle sub-visibility";
                "9" = "add sub-delay +0.1";
                "8" = "add sub-delay -0.1";
                "+" = "cycle video";
                _ = "cycle audio";
                ")" = "cycle sub";
                S = "playlist-shuffle";
                q = "quit-watch-later";
                o = "multiply speed 1/1.1";
                "'" = "multiply speed 1.1";
                i = "set speed 1.0";
                HOME = "seek 0 absolute";
                PGUP = "add chapter 1";
                PGDWN = "add chapter -1";
                BS = "playlist-prev";
                ENTER = "playlist-next";
                "." = "frame-step";
                "," = "frame-back-step";
                "ctrl+c" = "quit-watch-later";
                SPACE = "cycle pause";
                l = "ab-loop";
                L = "cycle-values loop-file \"inf\" \"no\"";
                b = "script-binding sponsorblock_minimal/sponsorblock";
            };
        };
        programs.neovim = {
            enable = true;
            defaultEditor = true;
            viAlias = true;
            vimdiffAlias = true;
            plugins = with pkgs.vimPlugins; [lightline-vim vim-plugin-AnsiEsc indentLine nvim-highlight-colors vim-plug];
            initLua = ''
                vim.o.shada = ""
                require('nvim-highlight-colors').setup({})'';
            extraConfig = ''
                autocmd VimLeave * set guicursor=a:hor1-blinkwait500-blinkon250-blinkoff250
                set ignorecase
                set shortmess=I
                set linebreak
                set noerrorbells
                set hls is
                set wildmode=longest,list,full
                set incsearch
                set mouse=a
                set splitright
                set encoding=utf-8
                set smartcase
                set nocompatible
                set expandtab
                set tabstop=4
                set softtabstop=4
                set shiftwidth=4
                "set autoindent
                set noshowmode
                set clipboard=unnamedplus
                set nobackup
                set noswapfile
                set shm=csCFSW
                set cmdheight=0
                let g:lightline = {
                \ 'active': {
                \   'right': [ [ 'lineinfo' ],
                \              [ 'percent' ]]},}
                "Plug 'luizribeiro/vim-cooklang', { 'for': 'cook' }
                cabbrev wq silent wq
                cabbrev w silent w
                syntax on
                colorscheme vim
                filetype plugin on
                filetype indent on
                autocmd InsertEnter * norm zz
                autocmd BufWritePre * %s/\s\+$//e
                autocmd WinNew * wincmd L
                nnoremap S :%s///g<Left><Left><Left>
                inoremap <Esc> <Nop>
                map <F1> <Nop>
                imap <F1> <Nop>
                map <F9> :q!<CR>
                imap <F9> mn:q!<CR>
                map <F10> :q<CR>
                imap <F10> mn:q<CR>
                map <F11> :update<CR>
                imap <F11> mn:update<CR>
                map <F12> :x<CR>
                imap <F12> mn:x<CR>
                noremap m h
                noremap n j
                noremap e k
                noremap i l
                noremap l e
                noremap N n
                noremap E N
                noremap ' i
                noremap " I
                inoremap ne <Esc>
                inoremap en <Esc>
                nmap <A-F1> <Nop>
                let g:netrw_dirhistmax = 0
                autocmd VimEnter * :MatchDisable
                noremap <Up> <Nop>
                noremap <Down> <Nop>
                noremap <Left> <Nop>
                noremap <Right> <Nop>
                inoremap <Up> <Nop>
                inoremap <Down> <Nop>
                inoremap <Left> <Nop>
                inoremap <Right> <Nop>
                noremap <PageDown> <Nop>
                noremap <PageUp> <Nop>
                noremap <Home> <Nop>
                noremap <End> <Nop>'';
        };
        programs.keepassxc = {
            enable = true;
            settings = {
                GUI = {
                    ApplicationTheme = "dark";
                    HideGroupPanel = true;
                };
                Security = {
                    ClearClipboardTimeout = 15;
                    IconDownloadFallback = true;
                    LockDatabaseIdle = true;
                    LockDatabaseIdleSeconds = 600;
                    PasswordsHidden = false;
                    HidePasswordPreviewPanel = false;
                };
            };
        };
        services = {
            batsignal = {
                enable = true;
                extraArgs = ["-D systemctl suspend-then-hibernate" "-e"];
            };
            mako = {
                enable = true;
                settings = {
                    default-timeout = 5000;
                    background-color = "#000000BF";
                    border-color = "#AAAAAABF";
                };
            };
            tldr-update.enable = true;
            wl-clip-persist.enable = true;
            wlsunset = {
                enable = true;
                latitude = 47.5;
                longitude = 19;
                temperature.night = 2700;
            };
        };
        xdg = {
            enable = true;
            desktopEntries = {
                librewolf = {
                    name = "LibreWolf";
                    exec = "librewolf";
                };
                zathura = {
                    name = "Zathura";
                    exec = "zathura-sandbox";
                };
                transmission = {
                    name = "Transmission";
                    exec = "transmission-cli -er -w /home/soma/tr";
                };
            };
            mimeApps = {
                enable = true;
                defaultApplications = {
                    "text/html" = "librewolf.desktop";
                    "x-scheme-handler/http" = "librewolf.desktop";
                    "x-scheme-handler/https" = "librewolf.desktop";
                    "x-scheme-handler/about" = "librewolf.desktop";
                    "x-scheme-handler/unknown" = "librewolf.desktop";
                    "x-scheme-handler/mailto" = "thunderbird.desktop";
                    "application/pdf" = "zathura.desktop";
                    "video/mp4" = "mpv.desktop";
                    "video/webm" = "mpv.desktop";
                    "video/quicktime" = "mpv.desktop";
                    "video/mpeg" = "mpv.desktop";
                    "video/x-matroska" = "mpv.desktop";
                    "audio/mpeg" = "mpv.desktop";
                    "audio/wav" = "mpv.desktop";
                    "audio/ogg" = "mpv.desktop";
                    "audio/aac" = "mpv.desktop";
                    "audio/flac" = "mpv.desktop";
                    "image/png" = "mpv.desktop";
                    "image/jpeg" = "mpv.desktop";
                    "image/webp" = "mpv.desktop";
                    "text/plain" = "nvim.desktop";
                    "application/json" = "nvim.desktop";
                    "application/xml" = "nvim.desktop";
                    "text/css" = "nvim.desktop";
                    "text/javascript" = "nvim.desktop";
                    "application/javascript" = "nvim.desktop";
                    "text/markdown" = "nvim.desktop";
                    "application/yaml" = "nvim.desktop";
                    "text/x-python" = "nvim.desktop";
                    "text/x-sh" = "nvim.desktop";
                    "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "onlyoffice-desktopeditors.desktop";
                    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "onlyoffice-desktopeditors.desktop";
                    "application/vnd.openxmlformats-officedocument.presentationml.presentation" = "onlyoffice-desktopeditors.desktop";
                    "application/rft" = "onlyoffice-desktopeditors.desktop";
                    "application/x-bittorrent" = "transmission.desktop";
                };
            };
            portal = {
                enable = true;
                extraPortals = [pkgs.xdg-desktop-portal-gtk];
                config.common.default = ["gtk"];
                xdgOpenUsePortal = false;
            };
            userDirs = {
                enable = true;
                desktop = "/home/soma/ar";
                documents = "/home/soma/dx";
                download = "/home/soma/dn";
                music = "/home/soma/mu";
                pictures = "/home/soma/px";
                videos = "/home/soma/vs";
            };
        };
        gtk = {
            enable = true;
            theme.name = "Adwaita-dark";
            theme.package = pkgs.gnome-themes-extra;
        };
        qt = {
            enable = true;
            platformTheme.name = "adwaita";
            style.name = "Adwaita-dark";
            style.package = pkgs.adwaita-qt;
        };
        dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
        programs.zathura = {
            enable = true;
            mappings = {
                "w" = "scroll up";
                "a" = "scroll left";
                "r" = "scroll down";
                "s" = "scroll right";
                "m" = "scroll left";
                "n" = "scroll down";
                "e" = "scroll up";
                "i" = "scroll right";
                "t" = "zoom in";
                "d" = "zoom out";
                "p" = "snap_to_page";
                "x" = "adjust_window best-fit";
                "c" = "adjust_window width";
                "E" = "search backward";
                "N" = "search forward";
                "D" = "toggle_page_mode";
                "u" = "navigate previous";
                "l" = "navigate next";
                "R" = "rotate";
            };
            options = {
                recolor = "true";
                selection-clipboard = "clipboard";
            };
        };
        programs.newsboat = {
            enable = true;
            browser = "/etc/profiles/per-user/soma/bin/mpv";
            extraConfig = ''
                color listfocus black white
                color listfocus_unread black white bold
                color title black black
                color info black black
                macro , open-in-browser
                ignore-mode "display"
                ignore-article "*" "title # \"#shorts\" or description # \"#shorts\" or content # \"#shorts\" or link # \"shorts\""
                cleanup-on-quit yes
                macro a set browser "yt-dlp --write-auto-sub -q --no-warnings --skip-download -o /tmp/sub %u ; cat /tmp/sub.en.vtt| sed -e '/^[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}\.[0-9]\{3\} -->/d' -e '/^[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}\.[0-9]\{3\}/d' -e 's/<[^>]*>/g'| awk 'NF'| sed 's/$/ /'| tr -d '\n'| aichat 'give a detailed summary of the previous text with the main points. Do not mention any promotions or sponsors.'|less";open-in-browser;set browser mpv'';
        };
        programs.btop = {
            enable = true;
            settings = {
                net_iface = "wlan0";
                update_ms = 100;
                proc_sorting = "cpu direct";
                proc_per_core = true;
                proc_left = true;
                proc_filter_kernel = true;
                cpu_single_graph = true;
                show_coretemp = false;
                base_10_sizes = true;
                mem_graphs = false;
                show_swap = true;
                swap_disk = false;
                net_sync = false;
                check_temp = false;
            };
        };
        programs.yt-dlp = {
            enable = true;
            settings = {
                format-sort = "res:720";
                retries = "infinite";
                file-access-retries = "infinite";
                fragment-retries = "infinite";
                extractor-retries = "infinite";
                concurrent-fragments = 4;
                progress = true;
                embed-subs = true;
                no-warnings = true;
                audio-quality = 0;
                write-auto-subs = true;
                sub-langs = "en";
                embed-chapters = true;
                embed-thumbnail = true;
                embed-metadata = true;
                sponsorblock-remove = "all";
            };
        };
        home = {
            pointerCursor = {
                enable = true;
                package = pkgs.vanilla-dmz;
                name = "Vanilla-DMZ-AA";
                size = 24;
                sway.enable = true;
            };
            stateVersion = "26.05";
            preferXdgDirectories = true;
            file = {
                mime_handlers = {
                    enable = true;
                    force = true;
                    target = ".librewolf/default/handlers.json";
                    text = ''
                        {
                        "defaultHandlersVersion": {},
                            "mimeTypes": {
                                "application/pdf": {
                                    "action": 4,
                                    "extensions": [
                                        "pdf"
                                    ]
                                },
                                "application/vnd.openxmlformats-officedocument.wordprocessingml.document": {
                                    "action": 4,
                                    "extensions": [
                                        "docx"
                                    ]
                                },
                                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet": {
                                    "action": 4,
                                    "extensions": [
                                        "xlsx"
                                    ]
                                },
                                "application/vnd.openxmlformats-officedocument.presentationml.presentation": {
                                    "action": 4,
                                    "extensions": [
                                        "pptx"
                                    ]
                                },
                                "application/rtf": {
                                    "action": 4,
                                    "extensions": [
                                        "rtf"
                                    ]
                                },
                                "image/webp": {
                                    "action": 3,
                                    "extensions": [
                                        "webp"
                                    ]
                                },
                                "image/avif": {
                                    "action": 3,
                                    "extensions": [
                                        "avif"
                                    ]
                                }
                            },
                            "schemes": {
                                "mailto": {
                                    "handlers": [
                                        {
                                            "name": "Thunderbird",
                                            "command": "thunderbird --name thunderbird %U"
                                        }
                                    ],
                                    "action": 2
                                },
                                "magnet": {
                                    "action": 2,
                                    "handlers": [
                                        {
                                            "name": "mpv",
                                            "path": "/etc/profiles/per-user/soma/bin/mpv"
                                        }
                                    ],
                                    "ask": false
                                }
                            },
                            "isDownloadsImprovementsAlreadyMigrated": false
                        }
                    '';
                };
                dotpulse-cookie = {
                    enable = true;
                    force = true;
                    target = ".config/pulse/client.conf";
                    text = "cookie-file = ~/.config/pulse/cookie";
                };
                links = {
                    enable = true;
                    force = true;
                    target = ".links";
                    source = "/home/soma/dx/nixos/misc/.links";
                };
            };
        };
    };
}
