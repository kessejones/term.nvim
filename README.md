# term.nvim

## Getting Started

[Neovim 0.7](https://github.com/neovim/neovim/releases/tag/v0.7.0) or higher is required for `term.nvim` to work.

### Installation

Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use { 'kessejones/term.nvim' }
```

Using [vim-plug](https://github.com/junegunn/vim-plug)

```viml
Plug 'kessejones/term.nvim'
```

Using [dein](https://github.com/Shougo/dein.vim)

```viml
call dein#add('kessejones/term.nvim')
```

### Configuration

You need to initialize `term.nvim` with the setup function.

For example:

```lua
require("term").setup({
    shell = vim.o.shell,
    width = 0.5,
    height = 0.5,
    anchor = "NW",
    position = "center",
    border = {
        style = nil,
        chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        hl = "TermBorder",
    },
})
```

You can create the mappings you want to manager yours terminals

```lua
vim.keymap.set({ 't' }, '<C-p>', require('term').new, { silent = true })
vim.keymap.set({ 'n', 't' }, '<C-\\>', require('term').toggle, { silent = true })
vim.keymap.set({ 't' }, '<C-n>', require('term').next, { silent = true })
vim.keymap.set({ 't' }, '<C-p>', require('term').prev, { silent = true })
```

## Contributing

All contributions are welcome! Just open a pull request.

Please look at the [Issues](https://github.com/kessejones/term.nvim/issues) page to see the current backlog, suggestions, and bugs to work.

## License

Distributed under the same terms as Neovim itself.
