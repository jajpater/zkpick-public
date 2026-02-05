#!/usr/bin/env bash
# Common functions for zkpick

# Detect launcher (rofi or wofi)
detect_launcher() {
    if [[ -n "$ZKO_LAUNCHER" ]]; then
        echo "$ZKO_LAUNCHER"
        return
    fi

    # Prefer wofi on Wayland
    if [[ -n "$WAYLAND_DISPLAY" ]] && command -v wofi &>/dev/null; then
        echo "wofi"
    elif command -v rofi &>/dev/null; then
        echo "rofi"
    elif command -v wofi &>/dev/null; then
        echo "wofi"
    else
        echo "error: no launcher found (install rofi or wofi)" >&2
        exit 1
    fi
}

# Run launcher with menu
# $1: prompt text
# Reads input from stdin, outputs selected line number (0-based)
run_menu() {
    local prompt="${1:-}"
    local launcher
    launcher=$(detect_launcher)

    local markup_flag=""
    if [[ "${ZKO_USE_COLORS:-false}" == "true" ]]; then
        markup_flag="-markup-rows"
    fi

    case "$launcher" in
        rofi)
            rofi -dmenu -i -p "$prompt" -format i \
                ${markup_flag} \
                ${ZKO_THEME:+-theme "$ZKO_THEME"}
            ;;
        wofi)
            # wofi doesn't have -format i, so we use nl to prepend line numbers
            # and extract the number after selection, then subtract 1 for 0-based
            local result
            if [[ "${ZKO_USE_COLORS:-false}" == "true" ]]; then
                result=$(nl -ba -w1 -s$'\t' | wofi --dmenu -i -p "$prompt" --allow-markup \
                    ${ZKO_THEME:+-s "$ZKO_THEME"} | cut -f1)
            else
                result=$(nl -ba -w1 -s$'\t' | wofi --dmenu -i -p "$prompt" \
                    ${ZKO_THEME:+-s "$ZKO_THEME"} | cut -f1)
            fi
            [[ -n "$result" ]] && echo $((result - 1))
            ;;
    esac
}

# Run launcher with prompt for text input
# $1: prompt text
run_prompt() {
    local prompt="$1"
    local launcher
    launcher=$(detect_launcher)

    case "$launcher" in
        rofi)
            echo "" | rofi -dmenu -p "$prompt" \
                ${ZKO_THEME:+-theme "$ZKO_THEME"}
            ;;
        wofi)
            echo "" | wofi --dmenu -p "$prompt" \
                ${ZKO_THEME:+-s "$ZKO_THEME"}
            ;;
    esac
}

# Open file in editor
# $1: file path
open_in_editor() {
    local file="$1"

    case "$ZKO_EDITOR_MODE" in
        gui)
            case "$ZKO_GUI_EDITOR" in
                neovide)
                    neovide "$file" &
                    ;;
                nvim-qt)
                    nvim-qt "$file" &
                    ;;
                gvim)
                    gvim "$file" &
                    ;;
                *)
                    $ZKO_GUI_EDITOR "$file" &
                    ;;
            esac
            ;;
        terminal)
            case "$ZKO_TERMINAL" in
                kitty)
                    kitty -e "$ZKO_TERMINAL_EDITOR" "$file" &
                    ;;
                alacritty)
                    alacritty -e "$ZKO_TERMINAL_EDITOR" "$file" &
                    ;;
                wezterm)
                    wezterm start -- "$ZKO_TERMINAL_EDITOR" "$file" &
                    ;;
                foot)
                    foot "$ZKO_TERMINAL_EDITOR" "$file" &
                    ;;
                *)
                    $ZKO_TERMINAL -e "$ZKO_TERMINAL_EDITOR" "$file" &
                    ;;
            esac
            ;;
    esac
}

# Get notebook directory
# Uses ZKO_DEFAULT_NOTEBOOK or auto-discovers
get_notebook_dir() {
    if [[ -n "$ZKO_DEFAULT_NOTEBOOK" ]]; then
        echo "$ZKO_DEFAULT_NOTEBOOK"
        return
    fi

    # Try to get from zk
    local nb
    nb=$(zk list --format "{{notebook-root}}" --limit 1 2>/dev/null | head -1)
    if [[ -n "$nb" ]]; then
        echo "$nb"
    else
        echo "$HOME"
    fi
}

# List available notebooks (directories with .zk folder)
list_notebooks() {
    local search_dirs=("$HOME/Notes" "$HOME/Documents" "$HOME/notes" "$HOME")

    for dir in "${search_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            find "$dir" -maxdepth 3 -type d -name ".zk" 2>/dev/null | \
                while read -r zkdir; do
                    dirname "$zkdir"
                done
        fi
    done | sort -u
}

# Notification helper
notify() {
    local msg="$1"
    if command -v notify-send &>/dev/null; then
        notify-send "zkpick" "$msg"
    fi
}
