# Svelte-Hop
Jump between route files in Svelte.

You can change the keybindings to your liking. See configuration below.

Statusline icons can be enabled in the configuration. This provides the `%{%v:lua.SvopStatusline()%}` that you can include in your statusline or winbar.

## Configuration
### With Packer
```lua
use({
  "weskeiser/svelte-hop.nvim",
  config = function()
    require("svelte-hop").setup({
      -- When enabled Svelte-Hop will activate when in a matching directory (see
      -- activation_pattern). Disable if you want to manually enable Svelte-Hop.
      enabled = true,

      -- Svelte-Hop will activate when this pattern is found in the path. Checks are
      -- triggered by BufAdd.
      activation_pattern = "*/src/routes/*",

      -- Enable to create the route file if it does not exist when attempting to navigate.
      create_if_missing = false,

      -- Enable to use the provided function `%{%v:lua.SvopStatusline()%}` that you can
      -- include in your statusline or winbar.
      status_icons = false,

      -- Default keymaps can be overridden by providing your own.
      keymaps = {
        ["+page.svelte"] = "<leader>2",
        ["+page.ts"] = "<leader>3",
        ["+page.server.ts"] = "<leader>4",

        ["+layout.svelte"] = "<leader>7",
        ["+layout.ts"] = "<leader>8",
        ["+layout.server.ts"] = "<leader>9",

        ["+server.ts"] = "<leader>6",
        ["+error.ts"] = "<leader>5",
        },
    })
  end,
})
```

## Commands
#### Navigate to route files in the same folder
###### +page files
* `Svop ps` "+page.svelte"
* `Svop p` "+page.ts"
* `Svop psv` "+page.server.ts"

###### +layout files
* `Svop ls` "+layout.svelte"
* `Svop l` "+layout.ts"
* `Svop lsv` "+layout.server.ts"

###### +server.ts and +error.ts
* `Svop s` "+server.ts"
* `Svop e` "+error.ts"

## Statusline icon highlights
#### Target related groups
* `SvopGroup1` +page files
* `SvopGroup2` +layout files
* `SvopGroup3` +server.ts and error.ts

#### Targets the same groups as above, when the file does not exist.
* `SvopGroup1Missing` +page files
* `SvopGroup2Missing` +layout files
* `SvopGroup3Missing` +server.ts and error.ts

## Contribute
Feel free to add an issue or submit a PR if you have any suggestions or if you experience any bugs.
