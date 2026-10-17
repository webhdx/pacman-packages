#!/bin/bash
# Create the pacman repository in public/ from the packages in out/.
# Adapted from the BlocksDS: https://github.com/blocksds/packages
set -e
cd "$(dirname "$0")"

repo=webhdx-devkitpro

rm -rf public
mkdir public
cp out/*.pkg.tar.zst public/
cd public

# Sign packages and database when GPGKEY is set
sign=()
if [ -n "$GPGKEY" ]; then
	for pkg in *.pkg.tar.zst; do
		gpg --batch --yes --detach-sign --no-armor --local-user "$GPGKEY" "$pkg"
	done
	gpg --batch --yes --armor --export "$GPGKEY" > "$repo.asc"
	sign=(--sign --key "$GPGKEY")
fi

dkp-repo-add "${sign[@]}" "$repo.db.tar.gz" *.pkg.tar.zst

# GitHub Pages does not serve symlinks
for f in db files; do
	rm "$repo.$f"
	cp "$repo.$f.tar.gz" "$repo.$f"
	if [ -n "$GPGKEY" ]; then
		rm "$repo.$f.sig"
		cp "$repo.$f.tar.gz.sig" "$repo.$f.sig"
	fi
done

files=(*)
{
	echo '<!DOCTYPE html>'
	echo "<html><head><title>$repo</title></head><body>"
	for f in "${files[@]}"; do
		echo "<a href=\"$f\">$f</a><br>"
	done
	echo '</body></html>'
} > index.html
