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
            "bind",
            "bluez",
            "bluez-utils",
            "btrfs-progs",
            "curl",
            "dmidecode",
            "efibootmgr",
            "ethtool",
            "fish",
            "fwupd",
            "git",
            "gst-plugin-pipewire",
            "intel-ucode",
            "iw",
            "libpulse",
            "linux",
            "linux-firmware",
            "linux-lts",
            "lm_sensors",
            "lsof",
            "man-db",
            "man-pages",
            "mkinitcpio",
            "mtr",
            "nano",
            "networkmanager",
            "nftables",
            "nvme-cli",
            "pacman-contrib",
            "pciutils",
            "pipewire",
            "pipewire-alsa",
            "pipewire-jack",
            "pipewire-pulse",
            "powertop",
            "smartmontools",
            "sof-firmware",
            "strace",
            "sudo",
            "usbutils",
            "wayland-utils",
            "wev",
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
            "/etc/systemd/zram-generator.conf": File(source_file=f"{here}/zram-generator.conf"),
        }
