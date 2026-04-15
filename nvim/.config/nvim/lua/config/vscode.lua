local keymap = vim.keymap.set

local function notify(cmd)
    return string.format("<cmd>call VSCodeNotify('%s')<CR>", cmd)
end

local function v_notify(cmd)
    return string.format("<cmd>call VSCodeNotifyVisual('%s', 1)<CR>", cmd)
end

-- File navigation (telescope equivalents)
keymap('n', '<leader>pf', notify 'workbench.action.quickOpen', { silent = true })           -- find files
keymap('n', '<C-p>', notify 'workbench.action.quickOpen', { silent = true })                 -- git files
keymap('n', '<leader>ps', notify 'workbench.action.findInFiles', { silent = true })          -- grep
keymap('v', '<leader>ps', v_notify 'workbench.action.findInFiles', { silent = true })        -- grep selection
keymap('n', '<leader>pp', notify 'workbench.action.showAllSymbols', { silent = true })       -- workspace symbols
keymap('n', '<leader>pd', notify 'workbench.actions.view.problems', { silent = true })       -- diagnostics
keymap('n', '<leader>vh', notify 'workbench.action.showCommands', { silent = true })         -- help/commands

-- LSP
keymap('n', 'gd', notify 'editor.action.revealDefinition', { silent = true })
keymap('n', 'gi', notify 'editor.action.goToImplementation', { silent = true })
keymap('n', 'gD', notify 'editor.action.revealDeclaration', { silent = true })
keymap('n', 'go', notify 'editor.action.goToTypeDefinition', { silent = true })
keymap('n', 'gu', notify 'editor.action.goToReferences', { silent = true })
keymap('n', 'gs', notify 'editor.action.triggerParameterHints', { silent = true })
keymap('n', 'K', notify 'editor.action.showHover', { silent = true })
keymap('n', 'L', notify 'editor.action.showHover', { silent = true })                       -- diagnostics float
keymap('n', '<leader>rr', notify 'editor.action.rename', { silent = true })
keymap('n', '<leader>ca', notify 'editor.action.quickFix', { silent = true })
keymap('v', '<leader>ca', v_notify 'editor.action.quickFix', { silent = true })
keymap('n', '<leader>f', notify 'editor.action.formatDocument', { silent = true })
keymap('v', '<leader>f', v_notify 'editor.action.formatSelection', { silent = true })

-- Error navigation (quickfix equivalents)
keymap('n', '<C-k>', notify 'editor.action.marker.next', { silent = true })
keymap('n', '<C-j>', notify 'editor.action.marker.prev', { silent = true })
keymap('n', 'ge', notify 'editor.action.marker.next', { silent = true })
keymap('n', 'gp', notify 'editor.action.marker.prev', { silent = true })

-- Buffer/tab navigation (barbar equivalents)
keymap('n', '<C-h>', notify 'workbench.action.previousEditor', { silent = true })
keymap('n', '<C-l>', notify 'workbench.action.nextEditor', { silent = true })
keymap('n', '<C-q>', notify 'workbench.action.closeActiveEditor', { silent = true })
keymap('n', '<leader>q', notify 'workbench.action.closeOtherEditors', { silent = true })

-- File tree (nvim-tree equivalents)
keymap('n', '<leader>nt', notify 'workbench.action.toggleSidebarVisibility', { silent = true })
keymap('n', '<leader>nf', notify 'workbench.files.action.showActiveFileInExplorer', { silent = true })

-- Terminal
keymap('n', '<leader>ot', notify 'workbench.action.terminal.toggleTerminal', { silent = true })

-- Git
keymap('n', '<leader>gb', notify 'gitlens.toggleFileBlame', { silent = true })
keymap('n', '<leader>gd', notify 'workbench.view.scm', { silent = true })
keymap('n', '<leader>lg', notify 'workbench.view.scm', { silent = true })

-- Debug (dap equivalents)
keymap('n', '<F5>', notify 'workbench.action.debug.continue', { silent = true })
keymap('n', '<F10>', notify 'workbench.action.debug.stepOver', { silent = true })
keymap('n', '<F11>', notify 'workbench.action.debug.stepInto', { silent = true })
keymap('n', '<F7>', notify 'workbench.debug.action.toggleRepl', { silent = true })
keymap('n', '<leader>b', notify 'editor.debug.action.toggleBreakpoint', { silent = true })
keymap('n', '<leader>ds', notify 'workbench.action.debug.stop', { silent = true })

-- Testing (neotest equivalents)
keymap('n', '<leader>tr', notify 'testing.runAtCursor', { silent = true })
keymap('n', '<leader>tt', notify 'testing.runCurrentFile', { silent = true })
keymap('n', '<leader>tT', notify 'testing.runAll', { silent = true })
keymap('n', '<leader>td', notify 'testing.debugAtCursor', { silent = true })
keymap('n', '<leader>tl', notify 'testing.reRunLastRun', { silent = true })
keymap('n', '<leader>ts', notify 'testing.showMostRecentOutput', { silent = true })
keymap('n', '<leader>to', notify 'testing.showMostRecentOutput', { silent = true })
