These are supplementary packages for [devkitPro pacman](https://devkitpro.org/wiki/devkitPro_pacman), for use with [libogc2](https://libogc2.org/)/devkitPPC.

Packages depend on [libogc2-devkitpro](https://github.com/extremscorner/pacman-packages) packages (e.g. `libogc2`, `libogc2-libdvm`), so that repository must be configured first.
devkitPro cannot, and will not, provide support for these packages.

## Adding repository

Append to `/opt/devkitpro/pacman/etc/pacman.conf`, after the `[libogc2-devkitpro]` (or `[extremscorner-devkitpro]`) section:

```ini
[webhdx-devkitpro]
SigLevel = Optional TrustAll
Server = https://webhdx.github.io/pacman-packages
```

Packages are not signed, hence `SigLevel = Optional TrustAll`. Then install packages as usual:

```
sudo dkp-pacman -Sy libogc2-libdvm-ideexi-git
```

## Packages

| Package | Description |
| --- | --- |
| `libogc2-libdvm-ideexi-git` | IDE-EXI / M.2 Loader disc interface for libdvm |

## Building packages

Packages are built and published to GitHub Pages by the GitHub Actions workflow on every push to `main` (`./build.sh` builds all packages into `out/`, `./make_repo.sh` creates the repository in `public/`).
It can also be triggered from another repository with a `repository_dispatch` event of type `run_build`.

Each directory contains a `PKGBUILD`. Build and install one locally with:

```
cd libogc2-libdvm-ideexi-git
dkp-makepkg -si
```

(`makepkg -si` on Arch Linux with devkitPro packages configured in `/etc/pacman.conf`.)
