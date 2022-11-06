# autosave.nvim

Provide autosave functionality to Neovim.

Inspired by [vim-auto-save](https://github.com/vim-scripts/vim-auto-save).

## Installation

[packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use { "mogulla3/autosave.nvim" }
```

[vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug "mogulla3/autosave.nvim"
```

## Usage

All you have to do is call the `setup()` function.

```lua
require('autosave').setup()
```

### Configuration

Some behaviors are customizable.

```lua
-- default settings
require('autosave').setup({
  enabled = true,
  silent = false,
  autosave_events = { "InsertLeave", "TextChanged", "CursorHold" },
  postsave_hook = nil,
})
```

#### enabled (type: boolean)

Default: `true`

If `true`, autosave is enabled.

#### silent (type: boolean)

Default: `false`

If `true`, no message is output during autosave.

#### autosave_events (type: table)

Default: `{ "InsertLeave", "TextChanged", "CursorHold" }`

Events that perform autosave.

If you want to enable autosave even while in INSERT mode, you may additionally specify `CursorHoldI` and `CompleteDone`.

See `:help events` for more information about events.

#### postsave_hook (type: function)

Default: `nil`

Specify the process you want to perform after auto save as a lua function.

### Commands

Several useful commands are built-in.

|Command|Description|
|:--|:--|
|`:AutosaveEnable`|Enable autosave.|
|`:AutosaveDisable`|Disable autosave.|
|`:AutosaveToggle`|Toggle autosave.|
