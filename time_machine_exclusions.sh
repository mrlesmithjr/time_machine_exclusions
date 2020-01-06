#!/usr/bin/env bash
# Inspired by https://github.com/stevegrunwell/asimov

ROOT_DIRS=(
  "${HOME}/Downloads" "${HOME}/Dropbox" "${HOME}/Google Drive"
  "${HOME}/IDrive Downloads" "${HOME}/OneDrive"
  "${HOME}/Library/Containers/com.docker.docker"
)
DIRS=("packer_cache" ".vagrant")
EXTENSIONS=("box" "iso" "vdi" "vmdk")

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
  find_dirs=$(find "${HOME}" \( -type d -o -type l \) -not \( -path "${HOME}"/Library -prune \) -not \( -path "${HOME}"/OneDrive -prune \) -not \( -path "${HOME}"/.Trash -prune \) -name "${i}")
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
  find_file_exts=$(find "${HOME}" -not \( -path "${HOME}"/Library -prune \) -not \( -path "${HOME}"/OneDrive -prune \) -not \( -path "${HOME}"/.Trash -prune \) -name "*.${i}")
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

if [ ! -f "${HOME}"/.time_machine_exclusions.log ]; then
  touch "${HOME}"/.time_machine_exclusions.log
fi

date >>"${HOME}"/.time_machine_exclusions.log
