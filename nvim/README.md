# Neovim config

My new from-scratch config for **Neovim 0.12**, built on native tooling:
`vim.pack` (package manager), native LSP (`vim.lsp.config`/`enable`), and native
treesitter.

## Requirements

- Neovim == 0.12
- `git` — vim.pack clones plugins
- `tree-sitter` CLI + a C compiler — `nvim-treesitter` `main` builds parsers with
  `tree-sitter build`. Without it only the bundled parsers work
  (`c lua vim vimdoc markdown markdown_inline query`).
- A Nerd Font — for `mini.icons` glyphs.
- (optional) `fd`, `ripgrep` for optimized Telescope
- (optional) `python-neovim` Support for python-based plugins

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
|------|--------|---------|
| `icons.lua` | mini.icons | icon provider (mocks nvim-web-devicons) |
| `oil.lua` | oil.nvim | edit the filesystem like a buffer |
| `gitsigns.lua` | gitsigns.nvim | git hunk signs + navigation |
| `fugitive.lua` | vim-fugitive | `:Git` commands |
| `treesitter.lua` | nvim-treesitter (main) | parser install; native highlight + fold |
| `treesitter-context.lua` | nvim-treesitter-context | sticky enclosing scope |
| `lsp.lua` | nvim-lspconfig (+ fidget.nvim) | native LSP: server config + `vim.lsp.enable`; progress UI |
| `blink.lua` | blink.cmp (+ friendly-snippets) | completion |
| `telescope.lua` | telescope.nvim (+ plenary.nvim) | fuzzy finder (`<leader>s*`, `<leader>g*`) |
| `aerial.lua` | aerial.nvim | symbol/code outline (`<leader>a`) |
| `tmux.lua` | tmux.nvim | seamless vim/tmux pane nav (`C-hjkl`) + resize |
| `colorscheme.lua` | onedark.nvim | colorscheme (`darker`) |
| `statusline.lua` | mini.statusline | minimal statusline (reuses mini.icons) |

## Roadmap

- [x] **treesitter textobjects** — decided against (nice in theory, never used them).
- [x] **telescope-fzf-native** — decided against it. The `load_extension('fzf')` line
      was a dead kickstart leftover (the fzf *sorter* extension was never installed); it
      needs a C build hook, so it's not worth the complexity. Removed the dead line; `rg`
      already makes file-listing fast and the default sorter is fine.
- [x] **LSP default maps** — duplicates of the 0.11 defaults (`grn gra grr gri grt
      gO K`) dropped; `plugins/lsp.lua` keeps only the non-defaults (`grc grd grD grh`,
      `<leader>th`). `[d`/`]d` stay in `keymaps.lua` (zz-centered).
- [x] **completion** — blink.cmp (defaults) + `friendly-snippets` via native
      `vim.snippet`. `<C-Space>` disabled; manual trigger is `<C-x><C-m>` (bound
      directly since blink's table doesn't take a 2-key chord). LSP capabilities
      auto-wired by blink on 0.11+.
- [x] **blink completion behavior** — no popup while typing words
      (`trigger.show_on_keyword = false`) but auto-shows after trigger characters
      (`show_on_trigger_character = true`); manual open with `<C-x><C-m>`.
      `documentation.auto_show = true`, `buffer` source dropped, `selection.auto_insert`
      at default (on). Snippets expand by *accepting* the item, not `<Tab>`.
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
- [x] **float borders** — `winborder = 'none'` (no border on LSP hover/signature/
      picker floats); Telescope borders are styled via onedark highlight overrides in
      `colorscheme.lua`.
- [x] **statusline** — mini.statusline (defaults; reuses mini.icons).

## Open decisions

- None outstanding. (statusline → mini.statusline, fuzzy finder → telescope,
  colorscheme → onedark.)
