{inputs, ...}: {
  flake.modules.nixos.base = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.mikoshi.nvf;
  in {
    options.mikoshi.nvf = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable the nvf (Neovim) configuration";
      };
    };
    imports = [inputs.nvf.nixosModules.default];
    config = lib.mkIf cfg.enable {
      nixpkgs.overlays = [inputs.neovim-nightly-overlay.overlays.default];
      environment.variables.EDITOR = "nvim";
      programs.nvf = {
        enable = true;
        settings.vim = {
          vimAlias = true;

          globals = {
            mapleader = " ";
          };

          lineNumberMode = "number";

          telescope = {
            enable = true;
          };

          utility.motion.flash-nvim = {
            enable = true;
            mappings.jump = "s";
          };

          utility.outline.aerial-nvim = {
            enable = true;
            mappings = {
              toggle = "<leader>lo";
            };
          };

          ui = {
            noice.enable = true;
            colorizer = {
              enable = true;
              setupOpts = {
                "*" = {};
                javascript = {
                  AARRGGBB = false;
                };
              };
            };
          };

          mini = {
            ai.enable = true;
            statusline.enable = true;
          };

          autopairs.nvim-autopairs.enable = true;

          visuals.indent-blankline = {
            enable = true;
            setupOpts = {
              exclude = {
                filetypes = [
                  "dashboard"
                  "neo-tree"
                  "lazy"
                  "help"
                ];
              };
            };
          };

          dashboard.dashboard-nvim = {
            enable = true;
            setupOpts = {
              disable_move = true;
              theme = "doom";
              config = {
                header = [
                  "███████████████████████████████████████████████████████████████████████████████████"
                  "█▌                                                                               ▐█"
                  "█▌ ███╗   ███╗██╗██╗  ██╗ ██████╗ ███████╗██╗  ██╗██╗    ██╗   ██╗██╗███╗   ███╗ ▐█"
                  "█▌ ████╗ ████║██║██║ ██╔╝██╔═══██╗██╔════╝██║  ██║██║    ██║   ██║██║████╗ ████║ ▐█"
                  "█▌ ██╔████╔██║██║█████╔╝ ██║   ██║███████╗███████║██║    ██║   ██║██║██╔████╔██║ ▐█"
                  "█▌ ██║╚██╔╝██║██║██╔═██╗ ██║   ██║╚════██║██╔══██║██║    ╚██╗ ██╔╝██║██║╚██╔╝██║ ▐█"
                  "█▌ ██║ ╚═╝ ██║██║██║  ██╗╚██████╔╝███████║██║  ██║██║     ╚████╔╝ ██║██║ ╚═╝ ██║ ▐█"
                  "█▌ ╚═╝     ╚═╝╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝      ╚═══╝  ╚═╝╚═╝     ╚═╝ ▐█"
                  "█▌                                                                               ▐█"
                  "███████████████████████████████████████████████████████████████████████████████████"
                  "                Wake the fuck up Samurai, we've got a city to burn                 "
                  "                                                                                   "
                  "                                                                                   "
                  "                                                                                   "
                ];

                center = [
                  {
                    icon = " ";
                    desc = "Find file";
                    action = "Telescope find_files";
                    key = "f";
                  }
                  {
                    icon = " ";
                    desc = "Recent files";
                    action = "Telescope oldfiles";
                    key = "r";
                  }
                  {
                    icon = " ";
                    desc = "Find Text";
                    action = "Telescope live_grep";
                    key = "g";
                  }
                ];
              };
            };
          };
          comments.comment-nvim = {
            enable = true;
            setupOpts = {
              mappings.basic = true;
            };
          };

          git = {
            enable = true;

            git-conflict.mappings = {
              ours = "<leader>gco";
              theirs = "<leader>gct";
              both = "<leader>gcb";
              none = "<leader>gcn";
              nextConflict = "]x"; # Keep the existing one
              prevConflict = "[x"; # Keep the existing one
            };
            gitsigns.mappings = {
              blameLine = "<leader>gb";
              diffProject = "<leader>gdp";
              diffThis = "<leader>gdd";

              resetBuffer = "<leader>gR";
              stageBuffer = "<leader>gS";
              toggleBlame = "<leader>gtb";
              toggleDeleted = "<leader>gtd";

              previewHunk = "<leader>gp";
              previousHunk = "[c";
              nextHunk = "]c";
              stageHunk = "<leader>gs";
              undoStageHunk = "<leader>gu";
            };
          };
          terminal.toggleterm = {
            enable = true;
            lazygit = {
              enable = true;
              direction = "float";
            };
            mappings = {
              open = "<F12>";
            };
            setupOpts = {
              direction = "float";
            };
          };
          tabline = {
            nvimBufferline = {
              enable = true;
              mappings = {
                closeCurrent = "<leader>bq";
                cycleNext = "<Tab>";
                cyclePrevious = "<S-Tab>";
                pick = "<leader>bc";
                sortByDirectory = "<leader>bsd";
                sortByExtension = "<leader>bse";
                sortById = "<leader>bsi";
                moveNext = "<leader>bmn"; # Disable
                movePrevious = "<leader>bmp"; # Disable
              };
              setupOpts = {
                options = {
                  always_show_bufferline = true;
                };
              };
            };
          };
          clipboard = {
            enable = true;
            registers = "unnamedplus";
            providers.wl-copy.enable = true;
          };

          options = {
            tabstop = 4;
            shiftwidth = 4;
            expandtab = true;
            ignorecase = true;
            smartcase = true;
          };

          binds.whichKey = {
            enable = true;
          };
          keymaps = [
            {
              key = "jk";
              mode = "i";
              action = "<Esc>";
            }
            {
              key = "<Esc>";
              mode = ["t"];
              action = "<C-\\><C-n>";
              desc = "Exit terminal insert mode";
            }
            {
              key = "<leader>e";
              mode = "n";
              action = ":Neotree toggle<CR>";
              desc = "Toggle neotree";
            }
            {
              key = " ";
              mode = "t";
              action = " ";
              desc = "workaround for lazygit and terminal integration";
            }

            {
              key = "<C-h>";
              mode = "n";
              action = "<C-w>h";
              desc = "Move to left split";
            }
            {
              key = "<C-j>";
              mode = "n";
              action = "<C-w>j";
              desc = "Move to bottom split";
            }
            {
              key = "<C-k>";
              mode = "n";
              action = "<C-w>k";
              desc = "Move to top split";
            }
            {
              key = "<C-l>";
              mode = "n";
              action = "<C-w>l";
              desc = "Move to right split";
            }
            {
              key = "<leader>sh";
              mode = "n";
              action = "<C-w>s";
              desc = "Split horizontally";
            }
            {
              key = "<leader>sv";
              mode = "n";
              action = "<C-w>v";
              desc = "Split vertically";
            }
          ];

          autocomplete.blink-cmp = {
            enable = true;
            friendly-snippets.enable = true;
            setupOpts = {
              signature.enabled = true;
            };
            mappings = {
              close = "<Esc>";
              confirm = "<CR>";
              next = "<Tab>";
              previous = "<S-Tab>";
            };
          };

          lsp = {
            enable = true;
            formatOnSave = false;
            # inlayHints.enable = true;
            mappings = {
              goToDefinition = "<leader>ld";
              listReferences = "<leader>lr";
              listImplementations = "<leader>li";
              goToType = "<leader>lt";
              renameSymbol = "<leader>ln";
              codeAction = "<leader>la";
              listDocumentSymbols = "<leader>ls";
              hover = "<leader>lh";
              format = "<leader>lf";

              # Diagnostics
              openDiagnosticFloat = "<leader>dd";
              nextDiagnostic = "<leader>dn";
              previousDiagnostic = "<leader>dp";

              # Not needed
              goToDeclaration = null;
              documentHighlight = null;
              addWorkspaceFolder = null;
              removeWorkspaceFolder = null;
              listWorkspaceFolders = null;
              listWorkspaceSymbols = null;
              signatureHelp = null;
              toggleFormatOnSave = null;
            };
          };

          languages = {
            nix = {
              enable = true;
              format.enable = true;
              lsp.enable = true;
            };

            python = {
              enable = true;
              format.enable = true;
              lsp.enable = true;
            };

            rust = {
              enable = true;
              format.enable = true;
              lsp.enable = true;
            };

            java = {
              enable = true;
              lsp.enable = true;
            };

            # Javascript / Typescript
            ts = {
              enable = true;
              format.enable = true;
              lsp.enable = true;
            };

            css = {
              enable = true;
              format.enable = true;
              lsp.enable = true;
            };

            html = {
              enable = true;
              format.enable = true;
              lsp.enable = true;
            };
          };

          filetree.neo-tree = {
            enable = true;
            setupOpts = {
              window = {
                position = "float";
              };
              enable_cursor_hijack = true;
              enable_git_status = true;
              enable_modified_markers = true;
              enable_opened_markers = true;
              enable_git_status_async = true;
            };
          };
          treesitter = {
            enable = true;
            grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
              c
              python
              rust
              java
              javascript
              html
              css
              nix
            ];
          };

          autocmds = [
            {
              desc = "set tabstop and tabwidth to 2 for nix files";
              event = ["FileType"];
              pattern = ["nix"];
              callback = lib.generators.mkLuaInline ''
                function()
                		vim.opt.tabstop = 2
                		vim.opt.shiftwidth = 2
                end
              '';
            }
            {
              desc = "disable indentation for nix files (the indenter is broken)";
              event = ["FileType"];
              pattern = ["nix"];
              callback = lib.generators.mkLuaInline ''
                              function()
                                vim.opt.indentexpr = ""
                                vim.opt.autoindent = true
                                vim.opt.smartindent = true
                end
              '';
            }
          ];

          theme = {
            enable = lib.mkOverride 150 true;
            name = lib.mkOverride 150 "catppuccin";
            style = lib.mkOverride 150 "mocha";
          };
        };
      };
    };
  };
}
