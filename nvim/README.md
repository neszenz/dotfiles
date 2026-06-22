# Neovim config

A minimal, from-scratch config for **Neovim 0.12**, built on native tooling:
`vim.pack` (package manager), native LSP (`vim.lsp.config`/`enable`), and native
treesitter. The previous lazy.nvim config is kept as `old_*` / `old_lua/` for
reference while the rewrite is in progress.

## Requirements

- Neovim >= 0.12
- `git` — vim.pack clones plugins
- `tree-sitter` CLI + a C compiler — `nvim-treesitter` `main` builds parsers with
  `tree-sitter build`. Without it only the bundled parsers work
  (`c lua vim vimdoc markdown markdown_inline query`).
- A Nerd Font — for `mini.icons` glyphs.

## Layout

```
init.lua                    entry; requires options, keymaps, then each plugin
lua/neszenz/options.lua     editor options + autocmds
lua/neszenz/keymaps.lua     non-plugin keymaps
lua/neszenz/plugins/*.lua   one file per plugin (vim.pack.add + its config)
nvim-pack-lock.json         vim.pack lockfile — committed, pins exact revs
```

## Plugin management

- Native `vim.pack`. Each file in `lua/neszenz/plugins/` calls `vim.pack.add{...}`
  then configures the plugin.
- Plugins are **required explicitly** in `init.lua` — order is load order, and
  commenting a `require` disables a plugin without removing its file.
- A dependency that needs its own config or is shared gets its own file
  (e.g. `icons.lua`); a single-use dep with no config can be added inline.
- Pinning: `version = 'vX.Y.Z'` for tagged plugins, a branch for rolling ones
  (treesitter). `nvim-pack-lock.json` is committed so the exact `rev` reproduces
  on other machines (vim.pack installs from the lockfile rev when present).
- Update: `:lua vim.pack.update()`; inspect: `:checkhealth vim.pack`.

## Plugins

| File | Plugin | Purpose |
|---|---|---|
| `icons.lua` | mini.icons | icon provider (mocks nvim-web-devicons) |
| `oil.lua` | oil.nvim | edit the filesystem like a buffer |
| `gitsigns.lua` | gitsigns.nvim | git hunk signs + navigation |
| `fugitive.lua` | vim-fugitive | `:Git` commands |
| `treesitter.lua` | nvim-treesitter (main) | parser install; native highlight + fold |
| `treesitter-context.lua` | nvim-treesitter-context | sticky enclosing scope |
| `lsp.lua` | nvim-lspconfig | native LSP: server defaults + `vim.lsp.enable` |
| `blink.lua` | blink.cmp (+ friendly-snippets) | completion |

## Roadmap

- [ ] **treesitter textobjects** — decide whether to re-add via
      `nvim-treesitter/nvim-treesitter-textobjects` (`main` branch). Old config had:
      select `aa/ia`=@parameter, `af/if`=@function, `ac/ic`=@class;
      move `]m`/`[m`/`]M`/`[M`=@function, `]]`/`[[`/`][`/`[]`=@class;
      swap `<leader>a`/`<leader>A`=@parameter.inner. The plugin is also rewritten
      now (setup + `require('nvim-treesitter-textobjects.select')` etc.).
- [x] **LSP default maps** — duplicates of the 0.11 defaults (`grn gra grr gri grt
      gO K`) dropped; `plugins/lsp.lua` keeps only the non-defaults (`grc grd grD grh`,
      `<leader>th`). `[d`/`]d` stay in `keymaps.lua` (zz-centered).
- [x] **completion** — blink.cmp (defaults) + `friendly-snippets` via native
      `vim.snippet`. `<C-Space>` disabled; manual trigger is `<C-x><C-m>` (bound
      directly since blink's table doesn't take a 2-key chord). LSP capabilities
      auto-wired by blink on 0.11+.
- [x] **blink completion behavior** — manual-only (`trigger.show_on_keyword` and
      `show_on_trigger_character = false`; open with `<C-x><C-m>`), `documentation.auto_show
      = true`, `buffer` source dropped. `selection.auto_insert` left at default (on).
      Note: snippets expand by *accepting* the item, not `<Tab>` on a typed trigger.
- [x] **lua_ls / Neovim API** — dropped lazydev (its library injection never fired
      under native LSP: lua_ls rooted at the git root, `lazydev.lsp.attached` stayed empty,
      `vim` undefined). Now configured directly in `lsp.lua`: `diagnostics.globals = { 'vim' }`
      + `workspace.library = { $VIMRUNTIME }`. Broaden the library to
      `nvim_get_runtime_file('lua', true)` if you want plugin-module resolution too.
- [x] **`mkview` / `loadview`** — guarded to real named file buffers (`buftype == ''`,
      excluding gitcommit/gitrebase/oil), and `viewoptions` dropped `folds` so saved
      views no longer override treesitter folding. (Existing stale views were cleared.)
- [x] **treesitter folding** — `foldmethod=expr`, `foldexpr=v:lua.vim.treesitter.foldexpr()`,
      `foldlevelstart=99` in `plugins/treesitter.lua`.
- [x] **fugitive maps** — restored in `plugins/fugitive.lua` (`<leader>gb` blame
      moved there from gitsigns).
- [x] **`winborder='rounded'`** — set globally; styles LSP hover/signature and
      picker floats, replacing the old per-plugin Telescope borders.

## Open decisions

- Fuzzy finder: keep telescope vs fzf-lua vs mini.pick.
- Statusline: native vs lualine.
- Colorscheme: onedark was the active one; ~7 others were installed.
