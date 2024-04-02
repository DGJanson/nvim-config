-- settings for lsps

lspconf = require("lspconfig")

-- rust
lspconf.rust_analyzer.setup{}

-- odin
lspconf.ols.setup{
    cmd = {"/home/djansen/opt/ols/ols"},
    filetype = {"odin"},
    lspconf.util.root_pattern("ols.json")
}

-- add some extra treesitter stuff for odin
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.odin = {
    install_info = {
        url = "/home/david/opt/lsp/tree-sitter-odin",
        branch = "main",
        files = {"src/parser.c"}
    },
    filetype = "odin"
}

-- Python
lspconf.pylsp.setup({
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    ignore = {"E302", "E251", "E305", "W293"},
                    maxLineLength = 120
                }
            }
        }
    }
})

-- Markdown
lspconf.marksman.setup{}

-- purescript
lspconf.purescriptls.setup {
    settings = {
        purescript = {
            addSpagoSources = true
        }
    }
}

-- tsserver
lspconf.tsserver.setup {

}
