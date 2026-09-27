if [ "${NOCTALIA_THEME_MODE:-}" = light ]; then
  icon_theme=Papirus-Light
  kitty_theme=light-theme.auto.conf
else
  icon_theme=Papirus-Dark
  kitty_theme=dark-theme.auto.conf
fi

dconf write /org/gnome/desktop/interface/icon-theme "'$icon_theme'"

kitty_dir="${XDG_CONFIG_HOME:-$HOME/.config}/kitty"
ln -sfn "$kitty_dir/$kitty_theme" "$kitty_dir/current-theme.conf"
pkill -USR1 -x kitty || true
