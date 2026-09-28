fish_add_path -g ~/.local/bin

if status is-interactive
    set -gx CARAPACE_MATCH 1

    alias eza 'eza --icons auto --git'
    alias la 'eza -a'
    alias ll 'eza -l'
    alias lla 'eza -la'
    alias ls eza
    alias lt 'eza --tree'

    fzf --fish | source

    source $__fish_config_dir/init.fish

    zoxide init fish | source

    if test "$TERM" != dumb
        starship init fish | source
    end

    carapace _carapace fish | source
    atuin init fish --disable-up-arrow --disable-ai | source
    direnv hook fish | source
end
