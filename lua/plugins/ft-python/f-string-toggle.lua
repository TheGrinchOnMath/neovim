-- https://github.com/roobert/f-string-toggle.nvim
-- toggle strings to f-strings when adding curly braces
return {
	"roobert/f-string-toggle.nvim",
	config = function()
		require("f-string-toggle").setup({
			key_binding = "<leader>fff",
			key_binding_desc = "Toggle f-string",
			ft = { "python" },
		})
	end,
}
