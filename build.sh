#!/bin/bash
# Build every package into out/.
# Runs as root inside webhdx/devkitppc-libogc2; makepkg itself runs as the unprivileged "builder" user.
# Build-then-install approach adapted from BlocksDS: https://github.com/blocksds/packages
set -e
cd "$(dirname "$0")"

id builder &>/dev/null || useradd -m builder
chown -R builder .
mkdir -p out

run_as_builder() {
	su builder -w PATH,DEVKITPRO,DEVKITPPC -c "$1"
}

for pkgbuild in */PKGBUILD; do
	dir=$(dirname "$pkgbuild")
	echo "Building $dir ..."

	# Install missing dependencies available from pacman repositories; the rest
	# (cmake, git, ninja) are host tools provided by the image
	deps=$(cd "$dir" && run_as_builder "dkp-makepkg --printsrcinfo" | sed -n 's/^\t\(make\)\{0,1\}depends = //p')
	install=()
	for dep in $(dkp-pacman -T $deps); do
		if dkp-pacman -Si "${dep%%[<>=]*}" &>/dev/null; then
			install+=("$dep")
		fi
	done
	if [ ${#install[@]} -ne 0 ]; then
		dkp-pacman -S --noconfirm "${install[@]}"
	fi

	(cd "$dir" && run_as_builder "dkp-makepkg -f -d --noconfirm")

	# Install it so that later packages can depend on it
	dkp-pacman -U --noconfirm "$dir"/*.pkg.tar.zst
	mv "$dir"/*.pkg.tar.zst out/
done
