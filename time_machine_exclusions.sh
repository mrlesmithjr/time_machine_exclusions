#!/usr/bin/env bash
# Inspired by https://github.com/stevegrunwell/asimov

# Define exact location of directories in which to exclude. These are for
# directories which will only be in a single location.
ROOT_DIRS=(
  "${HOME}/Downloads" "${HOME}/Dropbox" "${HOME}/Google Drive"
  "${HOME}/IDrive Downloads" "${HOME}/OneDrive"
  "${HOME}/Library/Containers/com.docker.docker" "${HOME}/.vagrant.d"
  "${HOME}/Virtual Machines.localized"
  "${HOME}/Documents/Virtual Machines.localized"
  "${HOME}/Library/VirtualBox" "${HOME}/VirtualBox VMs"
)

# Define directories in which could be scattered throughout your home directory
# that you would want excluded.
DIRS=("packer_cache" ".vagrant")

# Define file extensions in which could be scattered throughout your home
# directory that you would want excluded.
EXTENSIONS=("box" "iso" "vdi" "vmdk")

# The shell reads the IFS variable, which is which is set to
# <space><tab><newline> by default. Because we may have paths with spaces we
# need to set IFS to only split the input on newlines.
IFS=$'\n'

for i in "${ROOT_DIRS[@]}"; do
  if [ -d "${i}" ]; then
    if tmutil isexcluded "${i}" | grep -q '\[Excluded\]'; then
      echo "- ${i} is already excluded, skipping."
    else
      tmutil addexclusion "${i}"
      sizeondisk=$(du -hs "${i}" | cut -f1)
      echo "- ${i} has been excluded from Time Machine backups (${sizeondisk})."
    fi
  fi
done

for i in "${DIRS[@]}"; do
  find_dirs=$(find "${HOME}" \( -type d -o -type l \) -not \( -path "${HOME}"/Library -prune \) -not \( -path "${HOME}"/.Trash -prune \) -name "${i}")
  for j in $find_dirs; do
    if tmutil isexcluded "${j}" | grep -q '\[Excluded\]'; then
      echo "- ${j} is already excluded, skipping."
    else
      tmutil addexclusion "${j}"
      sizeondisk=$(du -hs "${j}" | cut -f1)
      echo "- ${j} has been excluded from Time Machine backups (${sizeondisk})."
    fi
  done
done

for i in "${EXTENSIONS[@]}"; do
  find_file_exts=$(find "${HOME}" -not \( -path "${HOME}"/Library -prune \) -not \( -path "${HOME}"/.Trash -prune \) -name "*.${i}")
  for j in $find_file_exts; do
    if tmutil isexcluded "${j}" | grep -q '\[Excluded\]'; then
      echo "- ${j} is already excluded, skipping."
    else
      tmutil addexclusion "${j}"
      sizeondisk=$(du -hs "${j}" | cut -f1)
      echo "- ${j} has been excluded from Time Machine backups (${sizeondisk})."
    fi
  done
done
