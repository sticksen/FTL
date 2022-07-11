#!/bin/bash
# Pi-hole: A black hole for Internet advertisements
# (c) 2022 Pi-hole, LLC (https://pi-hole.net)
# Network-wide ad blocking via your own hardware.
#
# FTL Engine
# Deploy script for FTL
#
# This file is copyright under the latest version of the EUPL.
# Please see LICENSE file for your rights under this license.


# Transfer Builds to Pi-hole server for pihole checkout
# We use sftp for secure transfer and use the branch name as dir on the server.
# The branch name could contain slashes, creating hierarchical dirs. However,
# this is not supported by sftp's `mkdir` (option -p) is not availabe. Therefore,
# we need to loop over each dir level and create them one by one.

IFS=/ read -r -a path <<<"${TARGET_DIR}"

old_path="."

for dir in "${path[@]}"; do
    sftp -b - "${USER}"@"${HOST}" <<< "cd ${old_path}
    -mkdir ${dir}"
    old_path="${old_path}/${dir}"
done

sftp -r -b - "${USER}"@"${HOST}" <<< "cd ${old_path}
put ${SOURCE_DIR}/* ./"
