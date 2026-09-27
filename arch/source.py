import os
import sys

sys.dont_write_bytecode = True

import decman
from home.browsers.browsers import Browsers
from home.dev import Dev
from home.editors.editors import Editors
from home.gtk.gtk import Gtk
from home.kitty.kitty import Kitty
from home.media.media import Media
from home.noctalia.noctalia import Noctalia
from home.pdf.pdf import Pdf
from home.removable_media.removable_media import RemovableMedia
from home.shell.shell import Shell
from home.umbriel.umbriel import Umbriel
from home.xdg.xdg import Xdg
from system.base.base import Base, users
from system.boot.boot import Boot
from system.cursor.cursor import Cursor
from system.desktop.desktop import Desktop
from system.greeter.greeter import Greeter
from system.hardware.hardware import Hardware
from system.snapshots import Snapshots

decman.execution_order = ["pacman", "aur", "files", "systemd"]

decman.modules += [
    users,
    Base(),
    Boot(),
    Snapshots(),
    Hardware(),
    Desktop(),
    Cursor(),
    Greeter(),
    Browsers(),
    Dev(),
    Editors(),
    Gtk(),
    Kitty(),
    Media(),
    Noctalia(),
    Pdf(),
    RemovableMedia(),
    Shell(),
    Umbriel(),
    Xdg(),
]

if os.path.isdir("private"):
    import private
