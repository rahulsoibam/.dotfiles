return {
    "folke/todo-comments.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        -- TODO: set key bindings
        local todo_comments = require("todo-comments")
        todo_comments.setup({})
        vim.keymap.set("n", "]t", function()
            todo_comments.jump_next()
        end, { desc = "Next todo comment" })

        vim.keymap.set("n", "[t", function()
            todo_comments.jump_prev()
        end, { desc = "Previous todo comment" })
        vim.keymap.set("n", "<leader>td", "<cmd>TodoTelescope<CR>", { desc = "Open TodoTelescope" })
    end,
}
