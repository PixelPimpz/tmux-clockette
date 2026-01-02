# GEMINI.md

## Project Overview

This project is a tmux plugin that displays a clock in the status bar. The clock is a Unicode character that represents the current hour. The plugin consists of a `.tmux` file that sets up the plugin and a shell script that updates the clock. The main technologies used are shell scripting and tmux commands.

## Building and Running

There are no explicit build steps for this project. To use this plugin, you need to source the `tmux-clockette.tmux` file in your `~/.tmux.conf` file.

It is recommended to use the [TMUX Plugin Manager (TPM)](https://github.com/tmux-plugins/tpm) to manage the plugin. To do so, add the following line to your `~/.tmux.conf`:

```
set -g @plugin '<your-github-username>/tmux-clockette'
```

Then, press `prefix + I` to fetch the plugin and source it.

The plugin can be manually started and stopped with the following keybindings:

*   **M-c**: Start the clock.
*   **Ctrl-X**: Stop the clock.

## Development Conventions

The project follows standard shell scripting conventions.

*   The main logic is in `scripts/tmux-clockette.sh`.
*   The script is organized into functions (`main`, `cleanup`, `debug`, `setClock`).
*   The script uses `tmux` commands to interact with the tmux environment.
*   Debugging information can be enabled by setting the `@DEBUG` tmux environment variable to `1`.
