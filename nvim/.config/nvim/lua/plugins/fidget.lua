return {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
    opts = {
        -- Options for the legacy version tagged as 'legacy'
        text = {
            spinner = "pipe",         -- animation shown when tasks are ongoing
            done = "✔",              -- character shown when all tasks are complete
            commenced = "Started",    -- message shown when task starts
            completed = "Completed",  -- message shown when task completes
        },
        align = {
            bottom = true,           -- align fidgets along bottom edge of buffer
            right = true,            -- align fidgets along right edge of buffer
        },
        timer = {
            spinner_rate = 125,      -- frame rate of spinner animation, in ms
            fidget_decay = 2000,     -- how long to keep around empty fidget, in ms
            task_decay = 1000,       -- how long to keep around completed task, in ms
        },
        window = {
            relative = "win",        -- where to anchor the window, either "win" or "editor"
            blend = 0,               -- &winblend for the window (0 to respect theme background)
            zindex = nil,            -- the zindex value for the window
            border = "none",         -- style of border for the fidget window
        },
        sources = {
            ["*"] = {    -- Options for all sources
                hl = {
                    normal = "Normal",        -- Base highlight group
                    progress = "Comment",     -- Progress text highlight
                    done = "String",          -- Completed task highlight
                    error = "DiagnosticError" -- Error highlight
                }
            }
        },
        fmt = {
            leftpad = true,          -- right-justify text in fidget box
            stack_upwards = true,    -- list of tasks grows upwards
            max_width = 0,           -- maximum width of the fidget box
            fidget =                 -- function to format fidget title
                function(fidget_name, spinner)
                    return string.format("%s %s", spinner, fidget_name)
                end,
            task =                   -- function to format each task line
                function(task_name, message, percentage)
                    return string.format(
                        "%s%s [%s]",
                        message,
                        percentage and string.format(" (%s%%)", percentage) or "",
                        task_name
                    )
                end,
        },
        debug = {
            logging = false,         -- whether to enable logging, for debugging
            strict = false,          -- whether to interpret LSP strictly
        },
    },
}

