#!/usr/bin/env bash
# Inspired by https://github.com/stevegrunwell/asimov

DIR="$(
  cd "$(dirname "$0")" || return
  pwd -P
)"
PLIST="com.time_machine.exclusions.plist"
PLIST_SYMLINK="${HOME}/Library/LaunchAgents/${PLIST}"
SCRIPT="time_machine_exclusions.sh"
SCRIPT_SYMLINK="/usr/local/bin/${SCRIPT}"

if [ ! -d "${DIR}/logs" ]; then
  mkdir -p "${DIR}/logs"
fi

# Create symlink into /usr/local/bin
if [ ! -L ${SCRIPT_SYMLINK} ]; then
  echo "Creating symlink to ${SCRIPT_SYMLINK}"
  ln -si "${DIR}/${SCRIPT}" ${SCRIPT_SYMLINK}
else
  echo "Symlink to ${SCRIPT_SYMLINK} exists, checking."
  if [[ ! "${SCRIPT_SYMLINK}" -ef "${DIR}/${SCRIPT}" ]]; then
    echo "Fixing ${SCRIPT_SYMLINK} symlink path."
    rm ${SCRIPT_SYMLINK}
    ln -si "${DIR}/${SCRIPT}" ${SCRIPT_SYMLINK}
  fi
fi

# Create .plist symlink
if [ ! -L ${PLIST_SYMLINK} ]; then
  echo "Creating symlink to ${PLIST_SYMLINK}"
  ln -si "${DIR}/${PLIST}" "${PLIST_SYMLINK}"
else
  echo "Symlink to ${PLIST_SYMLINK} exists, checking."
  if [[ ! "${PLIST_SYMLINK}" -ef "${DIR}/${PLIST}" ]]; then
    echo "Fixing ${PLIST_SYMLINK} symlink path."
    rm ${PLIST_SYMLINK}
    ln -si "${DIR}/${PLIST}" ${PLIST_SYMLINK}
  fi
fi

# Unload .plist if already loaded
if launchctl list | grep -q com.time_machine.exclusions; then
  echo "Unloading current instance of ${PLIST}"
  launchctl unload -w "${PLIST_SYMLINK}"
fi

# Load .plist file
launchctl load -w "${PLIST_SYMLINK}" && echo "Time Machine exclusions daemon loaded!"

# Run Time Machine exclusions
echo "Running Time Machine exclusions..."
"${DIR}/${SCRIPT}"
