import decman
from decman import File
from decman.extras.users import User, UserManager
from decman.plugins import aur, pacman, systemd

here = "system/base"
users = UserManager()
users.add_user(User(username="tanren", shell="/usr/bin/fish", groups=None))


class Base(decman.Module):
    def __init__(self):
        super().__init__("base")

    @pacman.packages
    def pacman_packages(self) -> set[str]:
        return {
            "base",
            "base-devel",
            "bluez",
            "bluez-utils",
            "btrfs-progs",
            "curl",
            "efibootmgr",
            "fish",
            "fwupd",
            "git",
            "gst-plugin-pipewire",
            "intel-ucode",
            "libpulse",
            "linux",
            "linux-firmware",
            "linux-lts",
            "man-db",
            "man-pages",
            "mkinitcpio",
            "nano",
            "networkmanager",
            "nftables",
            "pacman-contrib",
            "pciutils",
            "pipewire",
            "pipewire-alsa",
            "pipewire-jack",
            "pipewire-pulse",
            "sof-firmware",
            "sudo",
            "usbutils",
            "wget",
            "wireplumber",
            "wpa_supplicant",
            "zram-generator",
        }

    @aur.packages
    def aur_packages(self) -> set[str]:
        return {"decman"}

    @systemd.units
    def units(self) -> set[str]:
        return {
            "NetworkManager.service",
            "nftables.service",
            "paccache.timer",
            "systemd-timesyncd.service",
        }

    def files(self) -> dict[str, File]:
        return {
            "/etc/nftables.conf": File(source_file=f"{here}/nftables.conf"),
        }
