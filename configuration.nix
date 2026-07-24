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
        astroterm
        autotiling-rs
        backgroundremover
        bat
        bc
        catdocx
        cointop
        cook-cli
        dash
        dejsonlz4
        doxx
        exfatprogs
        exiftool
        f3
        fastfetch
        fbcat
        fd
        fdupes
        ffmpeg
        figlet
        fishPlugins.autopair
        fishPlugins.grc
        fishPlugins.puffer
        fzf
        fzf-preview
        gallery-dl
        gcc
        gh
        ghc
        glow
        gnumake
        grc
        #groff
        gtrash
        handlr-regex
        heimdall
        hledger
        html2text
        hyperfine
        iftop
        imagemagick
        inxi
        iwqr
        jq
        keepass-diff
        #ladybird
        libnotify
        libqalculate
        libreoffice
        links2
        lm_sensors
        lolcat
        mailsy
        mapscii
        nautilus
        ncdu
        meme-image-generator
        nixos-anywhere
        nix-search-tv
        ocrmypdf
        openai-whisper
        oterm
        ouch-rar
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
        smartmontools
        solitaire-tui
        sox
        speedread
        speedtest-go
        stc-cli
        steamguard-cli
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
        ttdl
        unoconv
        vulkan-tools
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
        sway-scratch
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
        bluejay
        brave
        electron-mail
        firefox
        fluffychat
        gamescope
        gimp
        #google-chrome
        googleearth-pro
        iwgtk
        #kdePackages.kdenlive
        kdePackages.kolourpaint
        kdiskmark
        logseq
        lutris
        mullvad-browser
        onlyoffice-desktopeditors
        pavucontrol
        qdirstat
        rustdesk-flutter
        #starsector # TEITW-HP9ON-A7HMK-WA6YA
        tor-browser
        ungoogled-chromium
        vesktop
        zotero
    ];
    boot = {
        kernelParams = [
            "fbcon=rotate:1"
            "video=DSI-1:panel_orientation=right_side_up"
            "vm.dirty_writeback_centisecs=1500"
            "snd_hda_intel.power_save=1"
            "nmi_watchdog=0"
        ];
        initrd.luks.devices."luks".allowDiscards = true;
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
        pathsToLink = ["/share/xdg-desktop-portal" "/share/applications"];
        shells = with pkgs; [fish];
        sessionVariables = {
            BROWSER = "handlr open";
            EDITOR = "nvim";
            GIT_PAGER = "less -R";
            DOTREMINDERS = "$HOME/dx/Backups/remind/remind.rem";
            LEDGER_FILE = "$HOME/dx/Backups/finance/2025.journal";
            TTDL_FILENAME = "$HOME/dx/Backups/todo/todo.txt";
            MANPAGER = "nvim +Man!";
            PAGER = "nvim -R +AnsiEsc";
            XDG_CACHE_HOME = "$HOME/.cache";
            XDG_CONFIG_HOME = "$HOME/.config";
            XDG_DATA_HOME = "$HOME/.local/share";
            XDG_STATE_HOME = "$HOME/.local/state";
            XDG_DESKTOP_DIR = "$HOME/ar";
            XDG_DOCUMENTS_DIR = "$HOME/dx";
            XDG_DOWNLOAD_DIR = "$HOME/dn";
            XDG_PICTURES_DIR = "$HOME/px";
            XDG_VIDEOS_DIR = "$HOME/vs";
        };
    };
    fonts = {
        packages = with pkgs; [roboto-mono noto-fonts-color-emoji unifont];
        fontconfig.defaultFonts = {
            monospace = ["Roboto Mono"];
            serif = ["Roboto Mono"];
            sansSerif = ["Roboto Mono"];
            emoji = ["Noto Color Emoji"];
        };
    };
    hardware = {
        bluetooth = {
            enable = false;
            powerOnBoot = false;
        };
        cpu.intel.updateMicrocode = true;
        graphics.enable = true;
    };
    i18n.defaultLocale = "en_US.UTF-8";
    networking = {
        dhcpcd.enable = false;
        hostName = "laptop";
        nameservers = ["9.9.9.10#dns10.quad9.net"];
        wg-quick.interfaces.wg0.configFile = "/home/soma/dx/nixos/misc/secrets/wg.conf";
        wireless.iwd = {
            enable = true;
            settings.General = {
                EnableNetworkConfiguration = true;
                AddressRandomization = "network";
            };
        };
    };
    nix = {
        gc = {
            automatic = true;
            dates = "Sunday";
        };
        optimise = {
            automatic = true;
            dates = "monthly";
        };
    };
    nixpkgs.config = {
        allowUnfreePredicate = pkg:
            builtins.elem (lib.getName pkg) [
                "googleearth-pro"
                "steam"
                "steam-unwrapped"
                "starsector"
                "vim-plugin-AnsiEsc"
                "nvim-highlight-colors"
                "google-chrome"
                "ouch"
            ];
        permittedInsecurePackages = [
            "googleearth-pro-7.3.7.1155"
            "electron-39.8.10"
            "electron-40.10.5"
            "librewolf-151.0.2-1"
            "librewolf-unwrapped-151.0.2-1"
            "librewolf-bin-151.0.1-2"
            "librewolf-bin-unwrapped-151.0.1-2"
            "pnpm-10.29.2"
        ];
    };
    programs = {
        bash.shellInit = "export HISTFILE=/tmp/bash_history";
        command-not-found.enable = true;
        dconf.enable = true;
        fish.enable = true;
        gamemode.enable = true;
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
        autoUpgrade = {
            enable = true;
            dates = "Saturday";
        };
        stateVersion = "26.05";
    };
    systemd.sleep.settings.Sleep.HibernateDelaySec = "3h";
    services = {
        auto-cpufreq = {
            enable = true;
            settings = {
                charger = {
                    governor = "powersave";
                    energy_performance_preference = "balance_power";
                    energy_perf_bias = "balance_power";
                    turbo = "auto";
                };
                battery = {
                    governor = "powersave";
                    energy_performance_preference = "power";
                    energy_perf_bias = "power";
                    turbo = "never";
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
            IdleAction = "suspend-then-hibernate";
            IdleActionSec = "30min";
        };
        ollama = {
            enable = true;
            loadModels = ["gemma4:e2b"];
        };
        pipewire = {
            enable = true;
            alsa.enable = true;
            pulse.enable = true;
        };
        playerctld.enable = true;
        resolved = {
            enable = true;
            settings.Resolve = {
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
        xserver.xkb = {
            layout = "us";
            variant = "colemak_dh";
            options = "caps:backspace";
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
        accounts.email.accounts.mailbox = {
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
        programs = {
            thunderbird = {
                enable = true;
                profiles.default.isDefault = true;
            };
            aichat = {
                enable = true;
                settings = {
                    clients = [
                        {
                            type = "openai-compatible";
                            name = "openrouter";
                            api_base = "https://openrouter.ai/api/v1";
                            api_key = lib.strings.trim (builtins.readFile /home/soma/dx/nixos/misc/secrets/openrouter);
                            patch.chat_completions.".*".body = {
                                provider.order = ["deepseek"]; #https://openrouter.ai/docs/api/api-reference/chat/send-chat-completion-request
                                reasoning.effort = "none"; #"xhigh", "high", "medium", "low", "minimal" or "none"
                                tools = [
                                    #{
                                    #    type = "openrouter:web_search";
                                    #}
                                    #{
                                    #    type = "openrouter:datetime";
                                    #}
                                ];
                            };
                            models = [
                                {
                                    name = "deepseek/deepseek-v4-pro";
                                    system_prompt_prefix = lib.strings.trim (builtins.readFile /home/soma/dx/nixos/misc/ai_sysprompt);
                                }
                                {
                                    name = "qwen/qwen3-embedding-8b";
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
                                    name = "gemma4:e2b";
                                    temperature = 1.0;
                                    top_p = 0.95;
                                    top_k = 64;
                                }
                            ];
                        }
                    ];
                    save = true;
                    save_session = false;
                    wrap = "auto";
                    wrap_code = true;
                    keybindings = "vi";
                    rag_embedding_model = "openrouter:qwen/qwen3-embedding-8b";
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
            dircolors = {
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
            foot = {
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
                    colors-dark = {
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
                        scrollback-up-line = "Control+e";
                        scrollback-down-line = "Control+n";
                    };
                };
            };
            mpv = {
                enable = true;
                config = {
                    fullscreen = true;
                    term-osd-bar-chars = "[/|\\]";
                    gapless-audio = true;
                    image-display-duration = "inf";
                    audio-display = false;
                    msg-level = "vo/gpu=no,vo/ffmpeg=no,ffmpeg/demuxer=no,ffmpeg=no,input=no";
                    term-osd-bar = true;
                    slang = "en,de";
                    sid = false;
                    volume-max = "100";
                    osd-font = "Roboto Mono";
                    sub-font = "Roboto Mono";
                    input-default-bindings = false;
                    osc = false;
                    cache = true;
                    ytdl-format = "bestvideo[height<=?720]+bestaudio/best";
                };
                scriptOpts = {
                    stats.key_page_0 = "2";
                    webtorrent.path = "/home/soma/tr/";
                    sponsorblock_minimal.categories = "sponsor;selfpromo;interaction;intro;outro;preview;hook;music_offtopic;filler";
                    thumbfast.network = "yes";
                };
                scripts = with pkgs.mpvScripts; [
                    webtorrent-mpv-hook
                    sponsorblock-minimal
                    mpris
                    thumbfast
                    mpv-gallery-view
                    uosc
                ];
                bindings = {
                    "Shift+RIGHT" = "seek 1";
                    "DEL" = "run gtrash put \${path} ; playlist-next";
                    "Shift+LEFT" = "seek -1";
                    RIGHT = "seek 5";
                    LEFT = "seek -5";
                    UP = "seek 60";
                    DOWN = "seek -60";
                    MBTN_LEFT_DBL = "cycle fullscreen";
                    f = "cycle fullscreen";
                    "Ctrl+MBTN_LEFT" = "script-binding positioning/drag-to-pan";
                    a = "add video-pan-x  +0.1";
                    s = "add video-pan-x  -0.1";
                    w = "add video-pan-y  +0.1";
                    r = "add video-pan-y  -0.1";
                    R = "cycle_values video-rotate 90 180 270 0";
                    t = "add video-zoom   +0.1";
                    d = "add video-zoom   -0.1";
                    c = "set video-zoom 0 ; set video-pan-x 0 ; set video-pan-y 0";
                    m = "cycle mute";
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
                    g = "script-message playlist-view-toggle";
                    p = "script-binding webtorrent/toggle-info";
                };
            };
            neovim = {
                enable = true;
                defaultEditor = true;
                viAlias = true;
                vimdiffAlias = true;
                plugins = with pkgs.vimPlugins; [lightline-vim vim-plugin-AnsiEsc indentLine nvim-highlight-colors todo-txt-vim];
                initLua = ''
                    vim.o.shada = ""
                    require('nvim-highlight-colors').setup({})'';
                extraConfig = ''
                    " === General Settings ===
                    set nobackup
                    set noswapfile
                    set undofile
                    set undodir=~/.config/nvim/undo//
                    set clipboard=unnamedplus
                    set cmdheight=0

                    " === Search ===
                    set smartcase
                    set ignorecase

                    " === Display ===
                    set linebreak
                    colorscheme vim

                    " === Indentation ===
                    set expandtab
                    set tabstop=4
                    set shiftwidth=4

                    " === Filetype ===
                    "filetype plugin on
                    "filetype indent on

                    " === Lightline ===
                    let g:lightline = {
                    \ 'active': {
                    \   'right': [ [ 'lineinfo' ],
                    \              [ 'percent' ]]},
                    \}

                    " === Command Abbreviations ===
                    cabbrev wq silent wq
                    cabbrev w silent w

                    " === Remap Navigation Keys ===
                    noremap m h
                    noremap n j
                    noremap e k
                    noremap i l
                    noremap l e
                    noremap N n
                    noremap E N
                    noremap o i
                    noremap O I
                    noremap ' o
                    noremap " "

                    noremap h <Nop>
                    noremap j <Nop>
                    noremap k <Nop>
                    noremap l <Nop>

                    " === Alternacive Escape Mapping ===
                    inoremap ne <Esc>
                    inoremap en <Esc>

                    " === Disable Netrw History ===
                    "let g:netrw_dirhistmax = 0

                    " === Disable Arrow Keys ===
                    noremap <Up> <Nop>
                    noremap <Down> <Nop>
                    noremap <Left> <Nop>
                    noremap <Right> <Nop>
                    inoremap <Up> <Nop>
                    inoremap <Down> <Nop>
                    inoremap <Left> <Nop>
                    inoremap <Right> <Nop>'';
            };
            keepassxc = {
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
        };
        services = {
            batsignal = {
                enable = true;
                extraArgs = ["-D systemctl suspend-then-hibernate"];
            };
            mako = {
                enable = true;
                settings = {
                    default-timeout = 5000;
                    background-color = "#000000BF";
                    border-color = "#AAAAAABF";
                    layer = "overlay";
                };
            };
            tldr-update.enable = true;
            wl-clip-persist.enable = true;
            wlsunset = {
                enable = true;
                latitude = 47.5;
                longitude = 19;
                temperature.night = 2200;
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
                "<BackSpace>" = "exec \"gtrash put '$FILE'\"";
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
                "u" = "scroll full-up";
                "l" = "scroll full-down";
                "R" = "rotate";
            };
            options = {
                recolor = true;
                selection-clipboard = "clipboard";
                selection-notification = false;
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
                swap_disk = true;
                net_sync = false;
                check_temp = false;
            };
        };
        programs.yt-dlp = {
            enable = true;
            settings = {
                format-sort = "res:1080";
                progress = true;
                no-warnings = true;
                sub-langs = "en";
                embed-chapters = true;
                embed-thumbnail = true;
                embed-metadata = true;
                embed-subs = true;
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
