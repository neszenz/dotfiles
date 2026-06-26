vim.pack.add({
    { src = 'https://github.com/tpope/vim-fugitive', version = 'v3.7' },
})

-- :Git command wrappers (fugitive is vimscript: no setup, just maps)
vim.keymap.set('n', '<leader>gg', ':tabe<CR>:Git<CR><C-w>j:q<CR>')
vim.keymap.set('n', '<leader>gb', ':Git blame<CR>')

------------------------------------------------------------------------------------------------------------------------
-- Stash list in status page

local stash_section_group = vim.api.nvim_create_augroup("fugitive_stash_section", { clear = true })

-- Idempotent: strip any section we previously added, then re-add from `git stash list`.
local function render_stash_section(buf)
  if not vim.api.nvim_buf_is_valid(buf) then return end
  if vim.b[buf].fugitive_type ~= "index" then return end

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local hdr
  for i, l in ipairs(lines) do
    if l:match("^Stashed %(") then hdr = i; break end
  end

  vim.bo[buf].modifiable = true
  vim.bo[buf].readonly = false

  if hdr then
    local from = hdr - 1                                            -- 0-based header index
    if from > 0 and lines[hdr - 1] == "" then from = from - 1 end   -- drop our blank separator too
    vim.api.nvim_buf_set_lines(buf, from, -1, false, {})
  end

  local res = vim.fn.FugitiveExecute({ "stash", "list" }, buf)
  if res.exit_status == 0 then
    local entries = vim.tbl_filter(function(l) return l ~= "" end, res.stdout)
    if #entries > 0 then
      local block = { "", ("Stashed (%d):"):format(#entries) }
      for _, e in ipairs(entries) do block[#block + 1] = "  " .. e end
      vim.api.nvim_buf_set_lines(buf, -1, -1, false, block)
    end
  end

  vim.bo[buf].modifiable = false
  vim.bo[buf].readonly = true
  vim.bo[buf].modified = false        -- keep buffer "unmodified" so fugitive's reload guard won't skip
end

local function render_visible_index()
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(b) and vim.b[b].fugitive_type == "index" then
      render_stash_section(b)
    end
  end
end

-- 1. Initial open and full status reloads (FugitiveChanged does NOT fire on a plain :Git open).
vim.api.nvim_create_autocmd("User", {
  pattern = "FugitiveIndex", group = stash_section_group,
  callback = function(args) render_stash_section(args.buf) end,
})

-- 2. After any :Git command (stash push/pop, etc). Deferred so it runs *after* fugitive
--    finishes rebuilding the buffer.
vim.api.nvim_create_autocmd("User", {
  pattern = "FugitiveChanged", group = stash_section_group,
  callback = function() vim.schedule(render_visible_index) end,
})

-- 3. Terminal focus regained. fugitive's FocusGained autocmd isn't `nested`, so its rebuild
--    never re-fires FugitiveIndex to us; this independent handler covers that.
vim.api.nvim_create_autocmd("FocusGained", {
  group = stash_section_group,
  callback = function() vim.schedule(render_visible_index) end,
})

-- Stash list in status page
------------------------------------------------------------------------------------------------------------------------
