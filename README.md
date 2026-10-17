These are supplementary packages for [devkitPro pacman](https://devkitpro.org/wiki/devkitPro_pacman), for use with [libogc2](https://libogc2.org/)/devkitPPC.

Packages depend on [libogc2-devkitpro](https://github.com/extremscorner/pacman-packages) packages (e.g. `libogc2`, `libogc2-libdvm`), so that repository must be configured first.
devkitPro cannot, and will not, provide support for these packages.

## Packages

| Package | Description |
| --- | --- |
| `libogc2-libdvm-ideexi-git` | IDE-EXI / M.2 Loader disc interface for libdvm |

## Building packages

Each directory contains a `PKGBUILD`. Build and install one with:

```
cd libogc2-libdvm-ideexi-git
dkp-makepkg -si
```

(`makepkg -si` on Arch Linux with devkitPro packages configured in `/etc/pacman.conf`.)
