# Split Reset

A [Noctalia](https://github.com/noctalia-dev) bar button for Hyprland's dwindle layout. One click sets every split on that monitor's workspace back to 50/50, which is how windows tile when they first open.

Say you have four windows in a 2×2 grid and drag the middle divider to give one side more room. Click the button and the grid goes back to four equal quarters.

## Why not `splitratio`?

Hyprland has no "equalize" layout message. `layoutmsg splitratio 1 exact` only changes the split directly above the focused window. The middle divider of a 2×2 grid sits above two other splits, so `splitratio` can never reach it.

`split_reset()` works out the split tree from where the windows are. Then it moves each divider to the center with a relative resize on a window next to it. The resizes target windows by address, so focus and the cursor never move.

## Features

- A bar button that resets the workspace on its own bar's monitor, not the focused one.
- `split_reset()` callable from keybinds or `hyprctl eval`:

  | Call | Resets |
  | --- | --- |
  | `split_reset()` | the active workspace |
  | `split_reset({ monitor = "DP-1" })` | that monitor's active workspace |
  | `split_reset({ workspace = "3" })` | workspace 3 |
  | `split_reset({ snap = 0.05 })` | only dividers already within 5% of the center |

- Floating windows are ignored. Workspaces with a fullscreen window, or a layout other than dwindle, are left alone.

**One case it can't fix:** a split whose two halves are both split the same way, like a row of four built as `(A|B)|(C|D)`. No window resize reaches that middle divider, so it is skipped. Every other divider still gets reset.

## Requirements

- Hyprland 0.56 or later with the Lua config (`hyprland.lua`).
- Noctalia with plugin API 32 or later.

Tested on Hyprland 0.56.2 and Noctalia 5.3.0, on a 2×2 grid and a 4-window dwindle spiral.

## Install

1. Copy `hyprland/split_reset.lua` into your Hyprland config, for example to `~/.config/hypr/config/split_reset.lua`, and load it from `hyprland.lua`:

   ```lua
   require("config.split_reset")
   ```

2. Optional keybind, in your binds file:

   ```lua
   hl.bind("SUPER + equal", function() split_reset() end)
   ```

3. Put this folder in a local Noctalia plugin source, for example `~/noctalia-plugins/split-reset`, and add that source in Noctalia's settings:

   ```toml
   [[plugins.source]]
   kind = "path"
   location = "/home/you/noctalia-plugins"
   name = "local"
   ```

4. Enable `soulmanyes/split-reset` and add its bar widget:

   ```toml
   [widget.split_reset]
   type = "soulmanyes/split-reset:bar"
   ```

Run `hyprctl reload` after step 1. If the button shows an error, `split_reset` isn't loaded yet.

## License

CC0 1.0 (public domain), see `LICENSE`.
