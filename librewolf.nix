{
    config,
    pkgs,
    lib,
    ...
}: {
    home-manager.users.soma.programs.librewolf = {
        enable = true;
        #package = pkgs.librewolf-bin;
        policies.ExtensionSettings = {
            "redirector@einaregilsson.com" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/redirector/latest.xpi";
                installation_mode = "force_installed";
            };
            "addon@darkreader.org" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
                installation_mode = "force_installed";
            };
            "vimium-c@gdh1995.cn" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-c/latest.xpi";
                installation_mode = "force_installed";
            };
            "newtab-adapter@gdh1995.cn" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/newtab-adapter/latest.xpi";
                installation_mode = "force_installed";
            };
            "contact@example.com" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/smartreader/latest.xpi";
                installation_mode = "force_installed";
            };
            "sponsorBlocker@ajay.app" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
                installation_mode = "force_installed";
            };
            "extraneous@sysrqmagician.github.io" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/extraneous/latest.xpi";
                installation_mode = "force_installed";
            };
        };
        profiles.default = {
            settings = {
                "browser.startup.page" = 3;
                "browser.startup.homepage" = "about:newtab";
                "browser.newtabpage.enabled" = false;
                "browser.download.open_pdf_attachments_inline" = true;
                "findbar.highlightAll" = true;
                "font.name.monospace.x-western" = "Roboto Mono";
                "font.name.sans-serif.x-western" = "Roboto Mono";
                "font.name.serif.x-western" = "Roboto Mono";
                "font.size.variable.x-western" = "18";
                "sidebar.verticalTabs" = true;
                "sidebar.expandOnHoverMessage.dismissed" = true;
                "sidebar.backupState" = "{\"command\":\"\",\"launcherWidth\":55,\"launcherExpanded\":false,\"launcherVisible\":true}";
                "sidebar.main.tools" = "aichat";
                "privacy.resistFingerprinting.letterboxing" = true;
                "privacy.clearOnShutdown.history" = false;
                "browser.download.useDownloadDir" = false;
                "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
                "browser.search.suggest.enabled" = true;
                "identity.fxaccounts.enabled" = true;
                "network.http.referer.XOriginPolicy" = 2;
                "browser.toolbars.bookmarks.visibility" = "never";
                "privacy.userContext.enabled" = false;
                "browser.bookmarks.editDialog.showForNewBookmarks" = false;
                "browser.download.autohideButton" = true;
                "browser.urlbar.suggest.engines" = false;
                "extensions.webextensions.ExtensionStorageIDB.enabled" = false;
                "browser.translations.neverTranslateLanguages" = "hu,de";
                "librewolf.hidePasswdmgr" = true;
                "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
                "ui.systemUsesDarkTheme" = 1;
                "network.protocol-handler.expose.magnet" = false;
                "widget.use-xdg-desktop-portal.file-picker" = 2;
                "privacy.trackingprotection.allow_list.baseline.enabled" = true;
                "privacy.trackingprotection.allow_list.convenience.enabled" = true;
                "xpinstall.signatures.required" = false;
                "browser.download.start_downloads_in_tmp_dir" = false;
                "browser.uiCustomization.state" = ''{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["sponsorblocker_ajay_app-browser-action","addon_darkreader_org-browser-action","vimium-c_gdh1995_cn-browser-action","extraneous_sysrqmagician_github_io-browser-action","redirector_einaregilsson_com-browser-action","contact_example_com-browser-action","_aecec67f-0d10-4fa7-b7c7-609a2db280cf_-browser-action"],"nav-bar":["sidebar-button","back-button","forward-button","urlbar-container","downloads-button","ublock0_raymondhill_net-browser-action","unified-extensions-button","vertical-spacer"],"toolbar-menubar":["menubar-items"],"TabsToolbar":[],"vertical-tabs":["tabbrowser-tabs"],"PersonalToolbar":["personal-bookmarks"]},"seen":["ublock0_raymondhill_net-browser-action","developer-button","screenshot-button","addon_darkreader_org-browser-action","vimium-c_gdh1995_cn-browser-action","extraneous_sysrqmagician_github_io-browser-action","redirector_einaregilsson_com-browser-action","contact_example_com-browser-action","_aecec67f-0d10-4fa7-b7c7-609a2db280cf_-browser-action","sponsorblocker_ajay_app-browser-action"],"dirtyAreaCache":["unified-extensions-area","nav-bar","TabsToolbar","vertical-tabs","toolbar-menubar","PersonalToolbar"],"currentVersion":23,"newElementCount":7}'';
                "browser.uiCustomization.navBarWhenVerticalTabs" = ''["back-button","forward-button","urlbar-container","downloads-button","ublock0_raymondhill_net-browser-action","unified-extensions-button"]'';
            };
            isDefault = true;
            extensions.force = true;
            extensions.settings."addon@darkreader.org".settings = {
                theme = {
                    contrast = 150;
                };
                syncSettings = false;
                detectDarkTheme = false;
                changeBrowserTheme = true;
                enableForProtectedPages = true;
            };
            extensions.settings = {
                "extraneous@sysrqmagician.github.io".settings = {
                    config = {
                        watched.enabled = false;
                        hideSlop = {
                            enabled = true;
                            badTitleRegex = "^.*#short.*$";
                            minDuration = "00:02:00";
                        };
                        deArrow = {
                            enabled = true;
                            trustedOnly = true;
                            highlightReplacedTitles = true;
                        };
                        additionalLinks.cobaltTools = false;
                    };
                };
                "uBlock0@raymondhill.net".settings = {
                    advancedUserEnabled = true;
                    contextMenuEnabled = false;
                    externalLists = "https://divested.dev/blocklists/Fingerprinting.ubl";
                    popupPanelSections = 31;
                    selectedFilterLists = [
                        "user-filters"
                        "ublock-filters"
                        "ublock-badware"
                        "ublock-privacy"
                        "ublock-quick-fixes"
                        "ublock-unbreak"
                        "easylist"
                        "adguard-generic"
                        "adguard-mobile"
                        "easyprivacy"
                        "LegitimateURLShortener"
                        "adguard-spyware"
                        "adguard-spyware-url"
                        "block-lan"
                        "urlhaus-1"
                        "curben-phishing"
                        "plowe-0"
                        "dpollock-0"
                        "fanboy-cookiemonster"
                        "ublock-cookies-easylist"
                        "adguard-cookies"
                        "ublock-cookies-adguard"
                        "fanboy-social"
                        "adguard-social"
                        "fanboy-thirdparty_social"
                        "easylist-chat"
                        "easylist-newsletters"
                        "easylist-notifications"
                        "easylist-annoyances"
                        "adguard-mobile-app-banners"
                        "adguard-other-annoyances"
                        "adguard-popup-overlays"
                        "adguard-widgets"
                        "ublock-annoyances"
                        "HUN-0"
                        "https://divested.dev/blocklists/Fingerprinting.ubl"
                    ];
                    dynamicFilteringString = ''
                        no-csp-reports: * true
                        no-large-media: behind-the-scene false
                        no-large-media: duckduckgo.com false
                        no-remote-fonts: * true
                        no-remote-fonts: github.com false
                        no-remote-fonts: monkeytype.com false
                        * * 3p-frame block
                        * * 3p-script block
                        * cloudflare.com * noop
                        boards.4chan.org * 3p-script noop
                        bandcamp.com * 3p-script noop
                        soundcloud.com sndcdn.com * noop
                        soundcloud.com cloudfront.net * noop
                        behind-the-scene * * noop
                        behind-the-scene * 1p-script noop
                        behind-the-scene * 3p noop
                        behind-the-scene * 3p-frame noop
                        behind-the-scene * 3p-script noop
                        behind-the-scene * image noop
                        behind-the-scene * inline-script noop
                        no-remote-fonts: www.duolingo.com false
                        www.duolingo.com * 3p-frame noop
                        www.duolingo.com * 3p-script noop
                        login.microsoftonline.com * 3p-frame noop
                        login.microsoftonline.com * 3p-script noop
                        outlook.office.com * 3p-frame noop
                        outlook.office.com * 3p-script noop
                        elte.dkodaj.net * * noop
                        elte.dkodaj.net * 3p-frame noop
                        elte.dkodaj.net * 3p-script noop
                        www.dropbox.com * 3p-frame noop
                        www.dropbox.com * 3p-script noop
                        www.etsy.com * 3p-frame noop
                        www.etsy.com * 3p-script noop
                        genius.com * 3p-script noop
                        github.com githubassets.com * noop
                        www.google.com * 3p-script noop
                        www.hasznaltauto.hu * 3p-frame noop
                        www.hasznaltauto.hu * 3p-script noop
                        messenger.com * 3p-frame noop
                        messenger.com * 3p-script noop
                        imgur.com * 3p-script noop
                        www.jofogas.hu * 3p-script noop
                        login.live.com * 3p-script noop
                        monkeytype.com * * noop
                        mynixos.com * 3p-script noop
                        ncore.pro * 3p-frame noop
                        ncore.pro * 3p-script noop
                        ingatlan.com * 3p-frame noop
                        ingatlan.com * 3p-script noop
                        ebay.de * 3p-frame noop
                        ebay.de * 3p-script noop
                        amazon.de * 3p-frame noop
                        amazon.de * 3p-script noop
                        steampowered.com * 3p-frame noop
                        steampowered.com * 3p-script noop
                        www.gsmarena.com * 3p-frame noop
                        www.gsmarena.com * 3p-script noop
                        www.jofogas.hu * 3p-frame noop
                        www.jofogas.hu * 3p-script noop
                        teams.microsoft.com * 3p-script noop
                        www.patreon.com cloudflare.com * noop
                        www.pinterest.com * 3p-script noop
                        www.pornhub.com * 3p-script noop
                        www.reddit.com * 3p-script noop
                        www.reddit.com reddit.map.fastly.net * noop
                        www.reddit.com redditstatic.com * noop
                        rsf.org * 3p-frame noop
                        rsf.org * 3p-script noop
                        openrouter.ai * 3p-frame noop
                        openrouter.ai * 3p-script noop
                        www.rt.com * 3p-frame noop
                        www.rt.com * 3p-script noop
                        booru.soyjak.st * 3p-frame noop
                        booru.soyjak.st * 3p-script noop
                        vocaroo.com * 3p-script noop
                        x.com * 3p-script noop
                        xhamster.com * 3p-script noop'';
                    urlFilteringString = "";
                    hostnameSwitchesString = "no-large-media: behind-the-scene false\nno-remote-fonts: * true\nno-csp-reports: * true\nno-remote-fonts: github.com false\nno-large-media: duckduckgo.com        false\nno-strict-blocking: rentry.co true\nno-remote-fonts: monkeytype.com false\nno-strict-blocking: mobee.hu true";
                };
                "redirector@einaregilsson.com".settings = {
                    redirects = [
                        {
                            includePattern = "https://*youtube.com/*";
                            redirectUrl = "https://inv.nadeko.net/$2";
                            appliesTo = ["main_frame"];
                        }
                        {
                            includePattern = "https://*reddit.com/*";
                            excludePattern = "*old.reddit.com*|*preview.redd.it*|*reddit.com/media*|*reddit.com/gallery*";
                            redirectUrl = "https://old.reddit.com/$2";
                            appliesTo = ["main_frame"];
                        }
                        {
                            includePattern = "https://x.com/*";
                            redirectUrl = "https://xcancel.com/$1";
                            appliesTo = ["main_frame"];
                        }
                        {
                            includePattern = "https://inv.nadeko.net/feed/popular";
                            redirectUrl = "https://inv.nadeko.net/search";
                            appliesTo = ["main_frame"];
                        }
                        {
                            includePattern = "https://*.wikipedia.org/wiki/*";
                            excludePattern = "*?useskin=minerva|*#*";
                            redirectUrl = "https://$1.wikipedia.org/wiki/$2?useskin=minerva#bodyContent";
                            appliesTo = ["main_frame"];
                        }
                        {
                            includePattern = "https://wiki.archlinux.org/*";
                            excludePattern = "*?useskin=vector#bodyContent|*anubis*|*#*";
                            redirectUrl = "https://wiki.archlinux.org/$1?useskin=vector#bodyContent";
                            appliesTo = ["main_frame"];
                        }
                    ];
                };
                "vimium-c@gdh1995.cn".settings = {
                    keyMappings = ''
                        #!no-check
                        unmapAll

                        map m goBack
                        map n scrollDown keepHover=false
                        map e scrollUp keepHover=false
                        map i goForward

                        map l nextTab
                        map u previousTab
                        map L moveTabRight
                        map U moveTabLeft
                        map yt duplicateTab
                        map x removeTab
                        map X restoreTab

                        map gi focusInput
                        map gI LinkHints.activateEdit

                        map f LinkHints.activate
                        map F LinkHints.activateOpenInNewTab

                        map / enterFindMode
                        map N performFind
                        map E performBackwardsFind


                        map p openCopiedUrlInCurrentTab
                        map P openCopiedUrlInNewTab

                        map gg scrollToTop
                        map G scrollToBottom

                        map r reload
                        map R reload hard

                        map yf LinkHints.activateCopyLinkUrl
                        map yy copyCurrentUrl
                        map yi LinkHints.activateCopyImage

                        map d LinkHints.activateDownloadImage
                        map D LinkHints.activateDownloadLink

                        map gu goUp
                        map gU goToRoot

                        map ]] goNext
                        map [[ goPrevious

                        map ' enterInsertMode

                        ##map v enterVisualMode
                        map V enterVisualLineMode
                        map c LinkHints.activateSelect use caret
                        map v LinkHints.activateSelect use visual
                        mapkey <m:v> h
                        mapkey <n:v> j
                        mapkey <e:v> k
                        mapkey <i:v> l

                        map o Vomnibar.activate
                        map O Vomnibar.activateInNewTab

                        map b Vomnibar.activateBookmarks
                        map B Vomnibar.activateBookmarksInNewTab

                        map h Vomnibar.activateHistory
                        map H Vomnibar.activateHistoryInNewTab

                        map T Vomnibar.activateTabs

                        map ge Vomnibar.activateEditUrl
                        map gE Vomnibar.activateEditUrlInNewTab

                        map gm toggleMuteTab all
                        map gr toggleReaderMode

                        ##map c zoomReset
                        map ? showHelp
                        map w reset

                    '';
                    searchEngines = ''
                        w: https://en.wikipedia.org/wiki/%s Wikipedia
                        y: https://inv.nadeko.net/search?q=%s Invidious
                        ns: https://search.nixos.org/packages?channel=unstable&from=0&size=999&sort=relevance&type=packages&query=%s NixOS Packages
                        nw: https://wiki.nixos.org/wiki/%s NixOS Wiki
                        gm: https://www.google.com/maps?q=%s Google Maps
                        gmn: https://www.google.com/maps/dir/$s{$1/$2} Google Maps Navigation
                        g: https://www.google.com/search?q=%s Google
                        az: https://www.amazon.de/s/?field-keywords=%s Amazon
                        i: https://duckduckgo.com/?&q=%s&ia=images&iax=images Images
                        h: https://lite.duckduckgo.com/lite/?&q=%s&kl=hu-hu Hungary
                        gh: https://github.com/search?q=%s&type=repositories&s=stars&ref=opensearch Github
                        ghg: https://gist.github.com/search?q=%s&ref=opensearch Github Gist
                        ud: https://rd.vern.cc/define.php?term=%s Urban Dictionary
                        pb: https://thepiratebay.party/search/%s Torrents
                        we: https://en.wiktionary.org/wiki/%s#English Wiktionary
                        r: https://www.reddit.com/search?q=%s Reddit
                        sr: https://www.reddit.com/r/%s/top?t=all Subreddit
                        fa: https://addons.mozilla.org/en-US/firefox/search/?q=%s Firefox Addons
                        lib: https://annas-archive.li/search?q=%s
                        wl: https://search.wikileaks.org/?q=%s
                        elib: https://opac.elte.hu/Search/Results?lookfor=%s&type=AllFields
                        aw: https://wiki.archlinux.org/title/%s
                        gw: https://wiki.gentoo.org/wiki/%s
                        jf: https://www.jofogas.hu/magyarorszag?q=%s
                        ak: https://www.arukereso.hu/CategorySearch.php?st=%s
                        eb: https://www.ebay.de/sch/i.html?_nkw=%s
                        ph: https://www.pornhub.com/video/search?search=%s
                        4: https://boards.4chan.org/%s/
                        sh: javascript:location='https://sci-hub.st/https://'%20+%20escape(location.hostname%20+%20location.pathname)%20+%20'%20%S'%20;%20void%200
                        4pol: https://archive.4plebs.org/pol/search/type/op/text/%s
                        4g: https://desuarchive.org/g/search/type/op/text/%s/
                        r34: https://rule34.xxx/index.php?page=post&s=list&tags=%s
                        gs: https://scholar.google.com/scholar?q=%s&hl=en
                        et: https://www.etsy.com/search?q=%s
                        ya: https://yandex.com/search?text=%s&lr=10466
                        ali: https://www.aliexpress.com/w/wholesale-%s.html
                        phil: https://plato.stanford.edu/search/searcher.py?query=%s'';
                    linkHintCharacters = "arstf";
                    preferBrowserSearch = true;
                    newTabUrl_f = "about:newtab";
                    previousPatterns = "prev,previous,back,older,<,‹,←,«,≪,<<";
                    nextPatterns = "next,more,newer,>,›,→,»,≫,>>";
                    titleIgnoreList = "porn,4chan";
                    omniBlockList = "porn,4chan";
                };
            };
            search = {
                default = "lite";
                force = true;
                engines = {
                    lite = {
                        name = "lite";
                        urls = [{template = "https://lite.duckduckgo.com/lite/?q={searchTerms}";}];
                        definedAliases = ["@lite"];
                    };
                    wiki = {
                        name = "Wikipedia";
                        urls = [{template = "https://en.wikipedia.org/wiki/{searchTerms}";}];
                        definedAliases = ["w"];
                    };
                    inv = {
                        name = "Invidious";
                        urls = [{template = "https://inv.nadeko.net/search?q={searchTerms}";}];
                        definedAliases = ["y"];
                    };
                    images = {
                        name = "Images";
                        urls = [{template = "https://duckduckgo.com/?&q={searchTerms}&ia=images&iax=images";}];
                        definedAliases = ["i"];
                    };
                    hun = {
                        name = "Magyar";
                        urls = [{template = "https://lite.duckduckgo.com/lite/?&q={searchTerms}&kl=hu-hu";}];
                        definedAliases = ["m"];
                    };
                    github = {
                        name = "Github";
                        urls = [{template = "https://github.com/search?q={searchTerms}&type=repositories&s=stars";}];
                        definedAliases = ["gh"];
                    };
                    githubgist = {
                        name = "Github Gist";
                        urls = [{template = "https://gist.github.com/search?q={searchTerms}&ref=opensearch";}];
                        definedAliases = ["ghg"];
                    };
                    urbdict = {
                        name = "Urban Dictionary";
                        urls = [{template = "https://rd.vern.cc/define.php?term={searchTerms}";}];
                        definedAliases = ["ud"];
                    };
                    pb = {
                        name = "Torrents";
                        urls = [{template = "https://torrents-csv.com/search?q={searchTerms}";}];
                        definedAliases = ["pb"];
                    };
                    wiktionary = {
                        name = "Wiktionary";
                        urls = [{template = "https://en.wiktionary.org/wiki/{searchTerms}#English";}];
                        definedAliases = ["we"];
                    };
                    reddit = {
                        name = "Reddit";
                        urls = [{template = "https://www.reddit.com/search?q={searchTerms}";}];
                        definedAliases = ["r"];
                    };
                    subreddit = {
                        name = "Subreddit";
                        urls = [{template = "https://www.reddit.com/r/{searchTerms}/top?t=all";}];
                        definedAliases = ["sr"];
                    };
                    pinterest = {
                        name = "Pinterest";
                        urls = [{template = "https://bn.bloat.cat/search.php?q={searchTerms}";}];
                        definedAliases = ["p"];
                    };
                    maps = {
                        name = "Google Maps";
                        urls = [{template = "https://www.google.com/maps?q={searchTerms}";}];
                        definedAliases = ["gm"];
                    };
                    google = {
                        name = "Google";
                        urls = [{template = "https://www.google.com/search?q={searchTerms}";}];
                        definedAliases = ["g"];
                    };
                    amazon = {
                        name = "Amazon";
                        urls = [{template = "https://www.amazon.de/s/?field-keywords={searchTerms}";}];
                        definedAliases = ["az"];
                    };
                    nixwiki = {
                        name = "Nixos Wiki";
                        urls = [{template = "https://wiki.nixos.org/wiki/{searchTerms}";}];
                        definedAliases = ["nw"];
                    };
                    nixpkgs = {
                        name = "Nixos Packages";
                        urls = [{template = "https://search.nixos.org/packages?channel=unstable&from=0&size=999&sort=relevance&type=packages&query={searchTerms}";}];
                        definedAliases = ["ns"];
                    };
                    addons = {
                        name = "Firefox Addons";
                        urls = [{template = "https://addons.mozilla.org/en-US/firefox/search/?q={searchTerms}";}];
                        definedAliases = ["fa"];
                    };
                    library = {
                        name = "Library";
                        urls = [{template = "https://annas-archive.li/search?q={searchTerms}";}];
                        definedAliases = ["lib"];
                    };
                    wikileaks = {
                        name = "WikiLeaks";
                        urls = [{template = "https://search.wikileaks.org/?q={searchTerms}";}];
                        definedAliases = ["wl"];
                    };
                    eltelibrary = {
                        name = "Elte Könyvtár";
                        urls = [{template = "https://opac.elte.hu/Search/Results?lookfor={searchTerms}&type=AllFields";}];
                        definedAliases = ["elib"];
                    };
                    arch = {
                        name = "Arch Wiki";
                        urls = [{template = "https://wiki.archlinux.org/title/{searchTerms}";}];
                        definedAliases = ["aw"];
                    };
                    gentoo = {
                        name = "Gentoo Wiki";
                        urls = [{template = "https://wiki.gentoo.org/wiki/{searchTerms}";}];
                        definedAliases = ["gw"];
                    };
                    jofogas = {
                        name = "Jófogás";
                        urls = [{template = " https://www.jofogas.hu/magyarorszag?q={searchTerms}";}];
                        definedAliases = ["jf"];
                    };
                    arukereso = {
                        name = "Árukereső";
                        urls = [{template = "https://www.arukereso.hu/CategorySearch.php?st={searchTerms}";}];
                        definedAliases = ["ak"];
                    };
                    ebay = {
                        name = "Ebay";
                        urls = [{template = "https://www.ebay.de/sch/i.html?_nkw={searchTerms}";}];
                        definedAliases = ["eb"];
                    };
                    pornhub = {
                        name = "PornHub";
                        urls = [{template = "https://www.pornhub.com/video/search?search={searchTerms}";}];
                        definedAliases = ["ph"];
                    };
                    fourchan = {
                        name = "4chan.org";
                        urls = [{template = "https://boards.4chan.org/{searchTerms}";}];
                        definedAliases = ["4"];
                    };
                    polarchive = {
                        name = "/pol/ Archive";
                        urls = [{template = "https://archive.4plebs.org/pol/search/type/op/text/{searchTerms}";}];
                        definedAliases = ["4pol"];
                    };
                    garchive = {
                        name = "/g/ Archive";
                        urls = [{template = "https://desuarchive.org/g/search/type/op/text/{searchTerms}";}];
                        definedAliases = ["4g"];
                    };
                    r34 = {
                        name = "Rule 34";
                        urls = [{template = "https://rule34.xxx/index.php?page=post&s=list&tags={searchTerms}";}];
                        definedAliases = ["r34"];
                    };
                    scholar = {
                        name = "Google Scholar";
                        urls = [{template = "https://scholar.google.com/scholar?q={searchTerms}&hl=en";}];
                        definedAliases = ["gs"];
                    };
                    etsy = {
                        name = "Etsy";
                        urls = [{template = "https://www.etsy.com/search?q={searchTerms}";}];
                        definedAliases = ["et"];
                    };
                    yandex = {
                        name = "Yandex";
                        urls = [{template = "https://yandex.com/search?text={searchTerms}&lr=10466";}];
                        definedAliases = ["ya"];
                    };
                    aliexpress = {
                        name = "AliExpress";
                        urls = [{template = "https://www.aliexpress.com/w/wholesale-{searchTerms}.html";}];
                        definedAliases = ["ali"];
                    };
                    stanford = {
                        name = "Stanford Encyclopedia of Philosophy";
                        urls = [{template = "https://plato.stanford.edu/search/searcher.py?query={searchTerms}";}];
                        definedAliases = ["phil"];
                    };
                    bing.metaData.hidden = true;
                    google.metaData.hidden = true;
                    wikipedia.metaData.hidden = true;
                    duckduckgo.metaData.hidden = true;
                };
            };
            userChrome = ''                /* Source file https://github.com/MrOtherGuy/firefox-csshacks/tree/master/chrome/autohide_toolbox.css made available under Mozilla Public License v. 2.0
                See the above repository for updates as well as full license text. */

                /* Hide the whole toolbar area unless urlbar is focused or cursor is over the toolbar
                 * Dimensions on non-Win10 OS probably needs to be adjusted.
                 */

                :root{
                  --uc-autohide-toolbox-delay: 200ms; /* Wait 0.1s before hiding toolbars */
                  --uc-toolbox-rotation: 82deg;  /* This may need to be lower on mac - like 75 or so */
                }

                :root[sizemode="maximized"]{
                  --uc-toolbox-rotation: 88.5deg;
                }

                @media  (-moz-platform: windows){
                  :root:not([lwtheme]) #navigator-toolbox{ background-color: -moz-dialog !important; }
                }

                :root[sizemode="fullscreen"],
                :root[sizemode="fullscreen"] #navigator-toolbox{ margin-top: 0 !important; }

                #navigator-toolbox{
                  --browser-area-z-index-toolbox: 3;
                  position: fixed !important;
                  background-color: var(--lwt-accent-color,black) !important;
                  transition: transform 82ms linear, opacity 82ms linear !important;
                  transition-delay: var(--uc-autohide-toolbox-delay) !important;
                  transform-origin: top;
                  transform: rotateX(var(--uc-toolbox-rotation));
                  opacity: 0;
                  line-height: 0;
                  z-index: 1;
                  pointer-events: none;
                  width: 100vw;
                }
                :root[sessionrestored] #urlbar[popover]{
                  pointer-events: none;
                  opacity: 0;
                  transition: transform 82ms linear var(--uc-autohide-toolbox-delay), opacity 0ms calc(var(--uc-autohide-toolbox-delay) + 82ms);
                  transform-origin: 0px calc(0px - var(--tab-min-height) - var(--tab-block-margin) * 2);
                  transform: rotateX(89.9deg);
                }
                #mainPopupSet:has(> [panelopen]:not(#ask-chat-shortcuts,#selection-shortcut-action-panel,#chat-shortcuts-options-panel,#tab-preview-panel)) ~ toolbox #urlbar[popover],
                #navigator-toolbox:is(:hover,:focus-within,[movingtab]) #urlbar[popover],
                #urlbar-container > #urlbar[popover]:is([focused],[open]){
                  pointer-events: auto;
                  opacity: 1;
                  transition-delay: 33ms;
                  transform: rotateX(0deg);
                }
                #mainPopupSet:has(> [panelopen]:not(#ask-chat-shortcuts,#selection-shortcut-action-panel,#chat-shortcuts-options-panel,#tab-preview-panel)) ~ toolbox,
                #navigator-toolbox:has(#urlbar:is([open],[focus-within])),
                #navigator-toolbox:is(:hover,:focus-within,[movingtab]){
                  transition-delay: 33ms !important;
                  transform: rotateX(0);
                  opacity: 1;
                }
                /* This makes things like OS menubar/taskbar show the toolbox when hovered in maximized windows.
                 * Unfortunately it also means that other OS native surfaces (such as context menu on macos)
                 * and other always-on-top applications will trigger toolbox to show up. */
                @media (-moz-bool-pref: "userchrome.autohide-toolbox.unhide-by-native-ui.enabled"),
                       -moz-pref("userchrome.autohide-toolbox.unhide-by-native-ui.enabled"){
                  :root[sizemode="maximized"]:not(:hover){
                    #navigator-toolbox:not(:-moz-window-inactive),
                    #urlbar[popover]:not(:-moz-window-inactive){
                      transition-delay: 33ms !important;
                      transform: rotateX(0);
                      opacity: 1;
                    }
                  }
                }

                #navigator-toolbox > *{ line-height: normal; pointer-events: auto }

                /* Don't apply transform before window has been fully created */
                :root:not([sessionrestored]) #navigator-toolbox{ transform:none !important }

                :root[customizing] #navigator-toolbox{
                  position: relative !important;
                  transform: none !important;
                  opacity: 1 !important;
                }

                #navigator-toolbox[inFullscreen] > #PersonalToolbar,
                #PersonalToolbar[collapsed="true"]{ display: none }

                /* This is a bit hacky fix for an issue that will make urlbar zero pixels tall after you enter customize mode */
                #urlbar[breakout][breakout-extend] > .urlbar-input-container{
                  padding-block: calc(min(4px,(var(--urlbar-container-height) - var(--urlbar-height)) / 2) + var(--urlbar-container-padding)) !important;
                }

                /* Uncomment this if tabs toolbar is hidden with hide_tabs_toolbar.css */
                 /*#titlebar{ margin-bottom: -9px }*/

                /* Uncomment the following for compatibility with tabs_on_bottom.css - this isn't well tested though */
                /*
                #navigator-toolbox{ flex-direction: column; display: flex; }
                #titlebar{ order: 2 }
                */'';
        };
    };
}
