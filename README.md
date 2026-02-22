# double-click.yazi

Double-click to open files and enter directories in [Yazi](https://yazi-rs.github.io/) — just like a graphical file manager.

- **Double-click a folder** to enter it
- **Double-click a file** to open it
- **Double-click the header path** to go up one directory
- **Single click** selects/reveals the file
- **Right-click** shows the interactive "open with" menu

## Requirements

- Yazi >= 25.2 (requires `ya.time()` and `Entity:click` support)

## Installation

```bash
ya pkg add orkitec/double-click
```

## Setup

Add this to your `~/.config/yazi/init.lua`:

```lua
require("double-click"):setup()
```

### Options

You can configure the double-click threshold (in seconds):

```lua
require("double-click"):setup {
  threshold = 0.3, -- default: 0.3 seconds
}
```

Lower values require faster clicking. The macOS system default is around 0.3s.

## How it works

The plugin overrides `Entity:click` and `Header:click` with state machines that track mouse events:

1. **First click down** — selects the file
2. **First click up** — records the timestamp
3. **Second click down** — if within the threshold, arms the trigger
4. **Second click up** — fires `enter` (directories) or `open` (files)

Uses `ya.time()` for wall-clock timing. A common pitfall with Lua-based click detection is using `os.clock()`, which measures CPU time and returns near-zero between UI events — making every click look instant. `ya.time()` returns actual elapsed time with millisecond precision.

## License

MIT
