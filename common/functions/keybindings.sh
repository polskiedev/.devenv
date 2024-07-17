#!/bin/bash
# Specifies the key sequence Ctrl-x Ctrl-s.
# \C-u: Clears the current command line before running the script.
# bind '"\C-x\C-s":"\C-u~/myscript.sh\n"'

case $- in
    *i*) ;;
    *) return ;;
esac

bind_command_alt_r() {
    psh main
}

bind_command_ctrl_n() {
	psh note:modify
}

bind_command_ctrl_t() {
	psh note:tomorrow
}

bind_command_ctrl_y() {
	git_add_options_override_command_git
}

# Check if Alt+r is already bound and bind it if not
if ! bind -p | grep -q '"\er"'; then
    bind -x '"\er": bind_command_alt_r'
fi

if ! bind -p | grep -q '"\C-n"'; then
    bind -x '"\C-n": bind_command_ctrl_n'
fi

if ! bind -p | grep -q '"\C-t"'; then
    bind -x '"\C-t": bind_command_ctrl_t'
fi

if ! bind -p | grep -q '"\C-y"'; then
    bind -x '"\C-y":"bind_command_ctrl_y"'
fi