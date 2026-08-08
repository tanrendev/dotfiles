{ lib, ... }:
let
  base = "#1e1e2e";
  surface = "#313244";
  text = "#cdd6f4";
  mauve = "#cba6f7";
  yellow = "#f9e2af";
  red = "#f38ba8";
in
{
  programs.zathura = {
    enable = true;

    options = {
      selection-clipboard = "clipboard";
      adjust-open = "width";
      scroll-page-aware = true;
      recolor = true;
      recolor-keephue = true;

      default-bg = base;
      default-fg = text;
      statusbar-bg = surface;
      statusbar-fg = text;
      inputbar-bg = base;
      inputbar-fg = text;
      notification-bg = base;
      notification-fg = text;
      notification-error-bg = base;
      notification-error-fg = red;
      notification-warning-bg = base;
      notification-warning-fg = yellow;
      completion-bg = surface;
      completion-fg = text;
      completion-highlight-bg = mauve;
      completion-highlight-fg = base;
      index-bg = base;
      index-fg = text;
      index-active-bg = mauve;
      index-active-fg = base;
      highlight-color = yellow;
      highlight-active-color = mauve;
      recolor-lightcolor = base;
      recolor-darkcolor = text;
    };
  };

  xdg.mimeApps.defaultApplications =
    lib.genAttrs [
      "application/epub+zip"
      "application/oxps"
      "application/pdf"
      "application/x-fictionbook"
      "application/x-mobipocket-ebook"
    ] (_: "org.pwmt.zathura-pdf-mupdf.desktop")
    // lib.genAttrs [
      "image/vnd.djvu"
      "image/vnd.djvu+multipage"
    ] (_: "org.pwmt.zathura-djvu.desktop")
    // lib.genAttrs [
      "application/eps"
      "application/postscript"
    ] (_: "org.pwmt.zathura-ps.desktop");
}
