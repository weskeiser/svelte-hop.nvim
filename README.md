# Svelte-Hop.nvim
_NOTE: Svelte-Hop is highly experimental and currently in alpha. Expect breaking changes._


Svelte-Hop is a quality of life plugin for Svelte programming in neovim. Jump between Svelte route files with keyboard shortcuts, create the files if they don't exist, and display it all in your statusline.

## Main features

- **Jump between route files**. Use the default keymaps or create your own.
- **Create route files** if they do not exist.
- **Route file templates** provide boilerplate. Use the defaults or create your own.
- **Statusline displays** show which route files are present in Svelte route file directories.


## Table of contents

- [Install](#Install)
- [Config](#Config)
- [Statusline](#Statusline)
- [Icons](#Icons)
- [Highlights](#Highlights)
- [Templates](#Templates)
- [Keymaps](#Keymaps)

## Install
### With [packer.nvim]( https://github.com/wbthomason/packer.nvim )
```lua
use({"weskeiser/svelte-hop.nvim"
  config = function()
    require("svelte-hop").setup({
      [[ your config goes here ]]
    })
  end,
})
```

### With [lazy.nvim]( https://github.com/folke/lazy.nvim )
```lua
{
  dir = svelte_hop,
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("svelte-hop").setup({
      [[ your config goes here ]]
    })
  end,
},
```

## Config
```lua
{
  enabled = true,
  routefiles = {
    dir = "src/routes", -- Path snippet to match for SvelteKit routes dir
    create_if_missing = true, -- Create route file if it does not exist when hopping
    templates = {
      enabled = true,
      dir = nil,
      templates = {
        ["+page.svelte"] = { 2, 3 },
        ["+page.ts"] = { 1, 20 },
        ["+page.server.ts"] = { 1, 27 },

        ["+layout.svelte"] = { 2, 3 },
        ["+layout.ts"] = { 1, 20 },
        ["+layout.server.ts"] = { 1, 27 },

        ["+server.ts"] = { 1, 17 },
        ["+error.ts"] = { 1, 20 },
      },
    },
  },
  statusline = {
    enabled = false,
    icons = {
      file = "└┘",
      file_none = "└┘",
      start = "",
      ending = "",
      separator = "  ",
    },
  },
  keymaps = {
    ["+page.svelte"] = "<leader>1",
    ["+page.ts"] = "<leader>2",
    ["+page.server.ts"] = "<leader>3",

    ["+server.ts"] = "<leader>4",
    ["+error.ts"] = "<leader>5",

    ["+layout.svelte"] = "<leader>7",
    ["+layout.ts"] = "<leader>8",
    ["+layout.server.ts"] = "<leader>9",
  }
}
```

## Statusline
Display the status of route files present in Svelte route directories.

To use the display you must set `config.statusline.enabled` to true. Now you can use `SvopStatus()` or `vim.b.svopstatus` anywhere in your statusline, winbar, or tabline.

### Example

To have a display at the end of the statusline, we could add this to our nvim config:
```lua
vim.opt.statusline:append("%{%v:lua.SvopStatus()%}")
```

### Icons

Style your statusline with custom icons.
<!-- Icons can be changed in `statusline.icons`. -->

| Default           | Name              | Icon represents                     |
|-------------------|-------------------|-------------------------------      |
| `└┘`              | `file`            | Existing route file                |
| `└┘`              | `file_none`       | Non-existing route file            |
| two spaces        | `separator`       | Between route file groupings       |
| none              | `start`           | The start of the statusline display |
| none              | `ending`          | The end of the statusline display   |

### Highlights

Most of the highlights are set programmatically and based on the first four Svop highlights (`Svop[1-4]`).

The background color for `Svop[1-4]` defaults to your `Statusline` background color.

The highlights with `None`, `Current` or `Creation` appended are set programmatically. The algorithm for each highlight is described in the [Default](###Default) table.


#### Set highlights
Every highlight can be overridden, but it is recommended to only change the first four (`Svop[1-4]`) and `SvopSep` It is best to let the algorithm handle the rest to ensure correct highlighting.

Set a highlight with vim.api.nvim_set_hl to override the default.

#### Example
```lua
vim.api.nvim_set_hl(0, "Svop1", { fg = "#aaaaaa" })
vim.api.nvim_set_hl(0, "Svop2", { fg = "#bbbbbb" })
vim.api.nvim_set_hl(0, "Svop3", { fg = "#cccccc" })
vim.api.nvim_set_hl(0, "Svop4", { fg = "#dddddd" })
vim.api.nvim_set_hl(0, "SvopSep", { fg = "#eeeeee" })
```

---

#### Default highlights
`[...]` = pseudocode

`...hl` = `Svop[1-4]`

| Names           | Applies for               | Highlights                                         |
|-----------------|---------------------------|----------------------------------------------------|
| `Svop1`         | Route file exists         | ```{ fg = "#b98282" }```                           |
| `Svop2`         | Route file exists         | ```{ fg = "#6696cc" }```                           |
| `Svop3`         | Route file exists         | ```{ fg = "#66ac46" }```                           |
| `Svop4`         | Route file exists         | ```{ fg = "#8381a2" }```                           |
| `Svop1None`     | Route file does not exist | ```{...hl, fg = [half the brightness of hl.fg]}``` |
| `Svop2None`     | Route file does not exist | ```{...hl, fg = [half the brightness of hl.fg]}``` |
| `Svop3None`     | Route file does not exist | ```{...hl, fg = [half the brightness of hl.fg]}``` |
| `Svop4None`     | Route file does not exist | ```{...hl, fg = [half the brightness of hl.fg]}``` |
| `Svop1Current`  | Currently displayed file  | ```{...hl, sp = hl.fg, underline = true }```     |
| `Svop2Current`  | Currently displayed file  | ```{...hl, sp = hl.fg, underline = true }```     |
| `Svop3Current`  | Currently displayed file  | ```{...hl, sp = hl.fg, underline = true }```     |
| `Svop4Current`  | Currently displayed file  | ```{...hl, sp = hl.fg, underline = true }```     |
| `Svop1Creation` | File is being created     | ```{...hl, bg = [half the brightness of hl.fg]}``` |
| `Svop2Creation` | File is being created     | ```{...hl, bg = [half the brightness of hl.fg]}``` |
| `Svop3Creation` | File is being created     | ```{...hl, bg = [half the brightness of hl.fg]}``` |
| `Svop4Creation` | File is being created     | ```{...hl, bg = [half the brightness of hl.fg]}``` |
| `SvopSep`       | Space between groups      | ```{ fg = "#666666" }```                           |

---

## Templates
`"route file" = {row, col}`

Templates can be enabled with `statusline.templates.enabled = true`.

Disable specific templates by excluding them from `statusline.templates.templates` in your config.


### Cursor position

Set the cursor position after file entry by specifying it for each template in `statusline.templates.templates`.


### Default template files

Cursor position is represented by a bar `|`.

```html
// templates/+page.svelte
<script>
  |
</script>
```

```html
// templates/+layout.svelte
<script>
  |
</script>

<slot/>
```

```javascript
// templates/+page.ts

export function load(|) {
  return {};
}
```

```javascript
// templates/+layout.ts

export function load(|) {
  return {};
}
```

```javascript
// templates/+page.server.ts

export async function load(|) {
  return {};
}
```

```javascript
// templates/+layout.server.ts

export async function load(|) {
  return {};
}
```

```javascript
// templates/+server.ts

export function |GET() {
  return new Response();
}
```

```javascript
// templates/+error.ts
```


### Create custom templates

1. Create a template directory anywhere accessible to vim. For example in `~/.config/nvim/svop/templates`.
1. Populate the directory with template files. See [Default templates](###Defaulttemplates) for examples.
1. Set `statusline.templates.dir = [[path to template directory]]`

## Keymaps

Keymaps can be overridden in `keymaps` with a list of `[filename] = mapping` mappings. See [Config](#Config) for examples.

### Buffer local keymaps (recommended)
Set them in your config. This way they are local to the buffer and will not interfere with mappings in other non-route files you have open.
```lua
require("svelte-hop").setup({
  keymaps = {
    ["+page.svelte"] = "<leader>1",
  }
})
```

### Global keymaps
Set them globally like a savage.
```lua
vim.keymap.set("n", "<leader>1", function() require("svelte-hop").hop("+page.svelte") end)
```


### Default keymaps
| Mappings    | Files               |
|-------------|---------------------|
| `<leader>1` | +page.svelte      |
| `<leader>2` | +page.ts          |
| `<leader>3` | +page.server.ts   |
| `<leader>4` | +server.ts        |
| `<leader>5` | +error.ts         |
| `<leader>6` | +layout.svelte    |
| `<leader>7` | +layout.ts        |
| `<leader>8` | +layout.server.ts |

## Contribute
Feel free to add an issue or submit a PR if you have any suggestions or if you experience any bugs.
