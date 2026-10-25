function fish_prompt
    set_color b32e37
    echo -n $USER

    set_color 274a15
    echo -n "@"

    set_color a61662
    echo -n (prompt_hostname)

    set_color C8C093
    echo -n " "

    set_color 98BB6C
    echo -n (prompt_pwd)

    set_color d40202
    echo -n " ❯ "

    set_color normal
end
