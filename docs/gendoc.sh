#!/bin/bash

docs="$(dirname $(readlink -f $0))"
root="$(dirname ${docs})"
config="${docs}/config.ld"

cd "${root}"

# clean old files
rm -rf "${docs}/api.html" "${docs}/topics" "${docs}/data"

# create new files
ldoc -c "${config}" -d "${docs}" -o "api" "${root}"

# add some adjustments

sed -i -e 's|src="screenshot\.png"|src="https://raw.githubusercontent.com/AntumMT/mod-walking_light/master/screenshot.png" width="600"|g' "${docs}/topics/readme.md.html"

for html in $(grep -rl --include="*.html" "data/textures/walking_light_underlay.png" "${docs}"); do
	sed -i -e 's|data/textures/walking_light_underlay\.png"|data/icon.png" width="32"|g' "${html}"
done
mv "${docs}/data/walking_light_underlay.png" "${docs}/data/icon.png"
