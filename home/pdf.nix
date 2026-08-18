{ lib, ... }:
{
  programs.zathura = {
    enable = true;

    options = {
      selection-clipboard = "clipboard";
      adjust-open = "width";
      scroll-page-aware = true;
      recolor = true;
      recolor-keephue = true;
    };

    extraConfig = "include noctaliarc";
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
