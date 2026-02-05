#!/usr/bin/env bash
# zkpick configuration

# Launcher: "rofi" or "wofi" (auto-detect if empty)
ZKO_LAUNCHER="rofi"

# Editor mode: "terminal" or "gui"
# ZKO_EDITOR_MODE="gui"
ZKO_EDITOR_MODE="terminal"

# Terminal emulator (for terminal mode)
ZKO_TERMINAL="${TERMINAL:-kitty}"

# GUI editor command
ZKO_GUI_EDITOR="neovide"

# Terminal editor command
# ZKO_TERMINAL_EDITOR="${EDITOR:-nvim}"
ZKO_TERMINAL_EDITOR="lazyvim"

# Default notebook (leave empty for auto-discovery)
ZKO_DEFAULT_NOTEBOOK="/home/user/Documents/zk"

# List of notebooks (one per line, or use array)
# These appear in the notebook switcher menu
ZKO_NOTEBOOKS=(
  "/home/user/Documents/zk"
  # "/path/to/another/notebook"
  # "/path/to/work/notes"
)

# Daily journal directory (relative to notebook root)
ZKO_DAILY_DIR="journal"

# Weekly journal directory (relative to notebook root)
ZKO_WEEKLY_DIR="weekly"

# Theme (rofi/wofi theme name or path, leave empty for default)
ZKO_THEME=""

# Number of recent notes to show
ZKO_RECENT_LIMIT=20

# Show filename after title (true/false)
ZKO_SHOW_FILENAME=true

# Use colors in menu (true/false)
ZKO_USE_COLORS=true

# Preview enabled (rofi only, requires bat or cat)
ZKO_PREVIEW="true"
