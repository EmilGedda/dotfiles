return {

    {
        "mfussenegger/nvim-dap",

        dependencies = {

            -- fancy UI for the debugger
            {
                "rcarriga/nvim-dap-ui",
        -- stylua: ignore
        keys = {
          { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
          { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
        },

                opts = {},
                config = function(_, opts)
                    -- setup dap config by VsCode launch.json file
                    -- require("dap.ext.vscode").load_launchjs()
                    local dap = require("dap")
                    local dapui = require("dapui")
                    dapui.setup(opts)
                    dap.listeners.after.event_initialized["dapui_config"] = function()
                        dapui.open({})
                    end
                    dap.listeners.before.event_terminated["dapui_config"] = function()
                        dapui.close({})
                    end
                    dap.listeners.before.event_exited["dapui_config"] = function()
                        dapui.close({})
                    end
                end,
            },

            -- virtual text for the debugger
            {
                "theHamsta/nvim-dap-virtual-text",
                opts = {},
            },

            -- which key integration
            {
                "folke/which-key.nvim",
                optional = true,
                opts = {
                    defaults = {
                        ["<leader>d"] = { name = "+debug" },
                        ["<leader>da"] = { name = "+adapters" },
                    },
                },
            },
        },

        opts = function()
            local dap = require("dap")
            --if not dap.adapters["codelldb"] then
            dap.adapters["lldb"] = {
                type = "executable",
                command = vim.fn.exepath("lldb-vscode"),
                name = "lldb",
            }
            dap.adapters["cppdbg"] = {
                id = "cppdbg",
                type = "executable",
                command = vim.env.HOME .. ".local/vscode-cpptools/extension/debugAdapters/bin/OpenDebugAD7",
            }
            --end
            for _, lang in ipairs({ "c", "cpp" }) do
                dap.configurations[lang] = {
                    {
                        name = "Launch file",
                        type = "cppdbg",
                        request = "launch",
                        -- TODO: save this somehow
                        program = function()
                            --local actions = require("telescope.actions")
                            --local action_state = require("telescope.actions.state")
                            --require("telescope.builtin").find_files({
                            --    attach_mappings = function(prompt_bufnr, _)
                            --        actions.select_default:replace(function()
                            --            actions.close(prompt_bufnr)
                            --            local selection = action_state.get_selected_entry()
                            --            vim.api.nvim_put({ selection[1] }, "", false, true)
                            --        end)
                            --        return true
                            --    end,
                            --})
                            --local selection = action_state.get_selected_entry()
                            --print(selection)
                            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                        end,
                        cwd = "${workspaceFolder}",
                        stopAtEntry = true,
                        setupCommands = {
                            {
                                text = "-enable-pretty-printing",
                                description = "enable pretty printing",
                                ignoreFailures = false,
                            },
                        },
                    },
                    {
                        name = "Attach to gdbserver :1234",
                        type = "cppdbg",
                        request = "launch",
                        MIMode = "gdb",
                        miDebuggerServerAddress = "localhost:1234",
                        miDebuggerPath = "/usr/bin/gdb",
                        cwd = "${workspaceFolder}",
                        program = function()
                            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                        end,
                        setupCommands = {
                            {
                                text = "-enable-pretty-printing",
                                description = "enable pretty printing",
                                ignoreFailures = false,
                            },
                        },
                    },
                    -- {
                    --     type = "lldb",
                    --     request = "launch",
                    --     name = "Launch file",
                    --     program = function()
                    --         return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    --     end,
                    --     cwd = "${workspaceFolder}",
                    --     stopOnEntry = false,
                    -- },
                    -- {
                    --     type = "codelldb",
                    --     request = "attach",
                    --     name = "Attach to process",
                    --     processId = require("dap.utils").pick_process,
                    --     cwd = "${workspaceFolder}",
                    --     stopOnEntry = false,
                    -- },
                }
            end
        end,

    -- stylua: ignore
    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>dk", function() require("dap").up() end, desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    },

        config = function()
            local Config = require("util")
            vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

            for name, sign in pairs(Config.icons.dap) do
                sign = type(sign) == "table" and sign or { sign }
                vim.fn.sign_define(
                    "Dap" .. name,
                    { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
                )
            end
        end,
    },
}
