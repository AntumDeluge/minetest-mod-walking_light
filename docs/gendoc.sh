#!/bin/bash

docs="$(dirname $(readlink -f $0))"
root="$(dirname ${docs})"
config="${docs}/config.ld"

cd "${root}"

# clean old files
rm -rf "${docs}/api.html" "${docs}/topics"

# create new files
ldoc -c "${config}" -d "${docs}" -o "api" "${root}"

# add some adjustments
sed -i -e 's/src="screenshot\.png"/src="..\/..\/screenshot.png"/g' "${docs}/topics/readme.md.html"
