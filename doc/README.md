# vim-row-freeze

A Vim plugin that allows you to freeze a row and create a split window with scroll binding.

## Installation

1. Copy the `plugin` directory to your Vim plugin directory (usually `~/.vim/pack/plugins/start`).

## Usage

1. Place the cursor on the row you want to freeze.

2. Press `<leader>fr` to toggle the frozen row split.

   - The frozen row will be displayed in a separate split window.

   - The split window will be scroll-bound to the main window, ensuring that the frozen row remains visible while scrolling.

   - To close the frozen row split, press `<leader>fr` again.

## Limitations

- The plugin currently only supports freezing a single row at a time.

- The plugin may not work properly with other plugins that modify window behavior or cursor movement.

## Known Issues

- None at this time.

