#!/bin/sh

#  01a.organize_sample.sh
#
#
#  Created by Nancy Merino on 4/4/18.
#

# Enable bash built-in extglob to ease file matching.
shopt -s extglob
# To deal with the case where nothing matches.
shopt -s nullglob

# A pattern to match files with specific file extensions.
match="${sample}*"

# By default use the current working directory.
rawfiles_folder="${1:-${WORKDIR}/rawfiles}"

# For each file matched
for file in "${rawfiles_folder}"/${match}
do
  # make a directory with the same name without file extension
  targetdir="${rawfiles_folder}/${sample}"
  mkdir -p "${targetdir}"
  mv "${file}" "${targetdir}"
done
