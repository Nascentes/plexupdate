#!/bin/bash
set -e
echo "===== START: $(date) ====="
. .tgram || true

# Script to Auto Update Plex on Synology NAS
# Must be run as root.
# @author Martino https://forums.plex.tv/u/Martino
# @source @martinorob https://github.com/martinorob/plexupdate
# @author @nitantsoni https://github.com/nitantsoni
# @source @nitantsoni https://github.com/nitantsoni/plexupdate
# @author @bryanhunwardsen https://github.com/bryanhunwardsen
# @source @bryanhunwardsen https://github.com/bryanhunwardsen/plexupdate
# @source @nascentes https://github.com/Nascentes/plexupdate
# @see https://forums.plex.tv/t/script-to-auto-update-plex-on-synology-nas-rev4/479748

mkdir -p /tmp/plex/
cd /tmp/plex/ || echo "Failed to create /tmp/plex/" exit

TOKEN=$(grep -Po 'PlexOnlineToken="\K[^"]+' /volume1/Plex/Library/Application\ Support/Plex\ Media\ Server/Preferences.xml)
PACKAGE_URL=$(echo "https://plex.tv/api/downloads/5.json?channel=plexpass&X-Plex-Token=${TOKEN}")

#echo "PLEX Public Channel"
#PACKAGE_URL="https://plex.tv/api/downloads/5.json"

INSTALLED_VERSION=$(synopkg version "Plex Media Server" | cut -d"-" -f1);
echo "Installed version: $INSTALLED_VERSION"

JSON=$(curl -s $PACKAGE_URL)
CURRENT_VERSION=$(echo $JSON | jq -r .nas.Synology.version | cut -d"-" -f1);
echo "Current version: $CURRENT_VERSION"

CPU=$(uname -m)
RELEASE_URL=$(echo $JSON | jq -r '.nas.Synology.releases[] | select(.build=="linux-'"$CPU"'") | .url')

if [[ $CURRENT_VERSION > $INSTALLED_VERSION ]] ; then
  /usr/syno/bin/synonotify PKGHasUpgrade '{"[%HOSTNAME%]": $(hostname), "[%OSNAME%]": "Synology", "[%PKG_HAS_UPDATE%]": "Plex", "[%COMPANY_NAME%]": "Synology"}'
  echo "PLEX update is downloading..."
  /bin/wget $RELEASE_URL -P /tmp/plex/
  echo "PLEX update is installing..."
  /usr/syno/bin/synopkg install /tmp/plex/*.spk
  echo "PLEX Server restarting."
  /usr/syno/bin/synopkg start "Plex Media Server"
  if [[ ! -z "${tgram_bot}" ]]; then
    curl -s -X POST https://api.telegram.org/bot${tgram_bot}/sendMessage -d chat_id=${tgram_chatid} -d text="Plex upgraded to version: ${newversion}"
  fi
else
  echo "PLEX is currently up to date."
  if [[ ! -z "${tgram_bot}" ]]; then
    curl -s -X POST https://api.telegram.org/bot${tgram_bot}/sendMessage -d chat_id=${tgram_chatid} -d text="Checked for Plex package upgrade. We are on the latest release already."
  fi
fi
rm -rf /tmp/plex
exit 0
