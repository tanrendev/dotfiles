if [ "${NOCTALIA_THEME_MODE:-}" = light ]; then
  dconf write /org/gnome/desktop/interface/icon-theme "'Papirus-Light'"
else
  dconf write /org/gnome/desktop/interface/icon-theme "'Papirus-Dark'"
fi
