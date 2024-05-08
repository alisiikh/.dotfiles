local nmap = require('utils').nmap
local neotest = require('neotest')

local neotest_namespace = vim.api.nvim_create_namespace('neotest')
vim.diagnostic.config({
  virtual_text = {
    format = function(d)
      local v = d.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
      return v
    end,
  },
}, neotest_namespace)

neotest.setup({
  adapters = {
    require('neotest-go')({
      dap_adapter = 'delve',
    }),
    require('neotest-scala')({
      runner = 'sbt', -- or sbt
      extra_args = { '--no-colors' },
      framework = 'specs2', -- one of scalatest, munit, utest, specs2
    }),
    require('rustaceanvim.neotest'),
  },
  diagnostic = {
    enabled = true,
    severity = vim.diagnostic.severity.ERROR, -- show as errors
  },
  status = {
    enabled = true,
    signs = false,
    virtual_text = true,
  },
})

nmap('<leader>tr', neotest.run.run, { desc = 'neotest: run nearest test' })
nmap('<leader>td', function()
  neotest.run.run({ strategy = 'dap' })
end, { desc = 'neotest: debug nearest test' })
nmap('<leader>tR', function()
  neotest.run.run(vim.fn.expand('%'))
end, { desc = 'neotest: run current file' })
nmap('<leader>tD', function()
  neotest.run.run({ vim.fn.expand('%'), strategy = 'dap' })
end, { desc = 'neotest: debug current file' })
nmap('<leader>ta', neotest.run.attach, { desc = 'neotest: attach to nearest test' })
nmap('<leader>tS', neotest.summary.toggle, { desc = 'neotest: toggle test summary' })
nmap('<leader>ts', neotest.run.stop, { desc = 'neotest: stop nearest test' })
nmap('<leader>to', neotest.output.open, { desc = 'neotest: open test output' })
