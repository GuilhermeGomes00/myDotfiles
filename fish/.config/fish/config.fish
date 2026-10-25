if set -q NVIM
    fastfetch --config ~/.config/fastfetch/nvim.jsonc
else
    fastfetch
end

set -gx TODO_DIR "$HOME/Documentos/Todo"
set -gx TODO_FILE "$TODO_DIR/todo.txt"
set -gx DONE_FILE "$TODO_DIR/done.txt"
