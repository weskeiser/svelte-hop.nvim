# Svelte-Hop
Jump between route files in Svelte. You can change the keybindings to your liking.

## Configuration
```lua
use({
  "weskeiser/svelte-hop.nvim",
  config = function()
    require("svelte-hop").setup({
      enabled = true, -- If set to enabled, Svelte-Hop will activate when in a matching directory. If disabled, you will have to manually enable Svelte-Hop. See activation_pattern.
      activation_pattern = "*/src/routes/*", -- Svelte-Hop will activate when this pattern is found in the path if enabled is set to true. Checks are triggered by BufAdd.
      create_if_missing = false, -- Enable to create the route file if it does not exist when attempting to navigate.
      keymaps = {
        ["+page.svelte"] = "<leader>2",
        ["+page.ts"] = "<leader>3",
        ["+page.server.ts"] = "<leader>4",

        ["+layout.server.ts"] = "<leader>7",
        ["+layout.ts"] = "<leader>8",
        ["+layout.svelte"] = "<leader>9",

        ["+server.ts"] = "<leader>6",
        ["+error.ts"] = "<leader>5",
        },
    })
  end,
})
```

## Commands
### Navigate to route files in the same folder
* `Svop ps` "+page.svelte"
* `Svop p` "+page.ts"
* `Svop psv` "+page.server.ts"
* `Svop ls` "+layout.svelte"
* `Svop l` "+layout.ts"
* `Svop lsv` "+layout.server.ts"
* `Svop s` "+server.ts"
* `Svop e` "+error.ts"

## Contributing
Feel free to add an issue or submit a PR if you have any suggestions or if you experience any bugs.
