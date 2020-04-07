# Description
Automatically update Plex Media Server installed on Synology NAS via the Package Center PLEX Server Syno Package

# How to
Download this script/copy onto Synology NAS and create a Scheduled Task to run it. The script will check to see if the latest version is newer than the installed version and then proceed to update as needed.

Currently, this script is configured to pull PLEXPASS downloads. If you do not have PLEXPASS, you will want to change your code to look like this:
```
#TOKEN=$(grep -Po 'PlexOnlineToken="\K[^"]+' /volume1/Plex/Library/Application\ Support/Plex\ Media\ Server/Preferences.xml)
#PACKAGE_URL=$(echo "https://plex.tv/api/downloads/5.json?channel=plexpass&X-Plex-Token=${TOKEN}")

echo "PLEX Public Channel"
PACKAGE_URL="https://plex.tv/api/downloads/5.json"
```
(just swapping commented sections)

# Telegram Notifications (OPTIONAL)
I have added an api call to notify me via Telegram when this script runs with the result. It doesn't cover all use-cases (such as script failure), but the basics are there. Feel free to fork and enhance or change to use a different notification mechanism.

If you want to use Telegram notifications, you need to create a file `.tgram` in the same directory as the plexupdate.sh script on your NAS (or a different directory, but you'll need to update paths accordingly in the script). The contents of this file should look like:

```
export tgram_bot="111111111:AAAAAAAA_AbAbAbAB0BaBaBa-blargh"
export tgram_chatid="555555"

```

With your own values. If you don't know how to do this, there are many guides available, but the gist is that you need to create a Telegram Bot (keyword to search: [telegram botfather](https://core.telegram.org/bots)) & then use an existing [userinfobot](https://telegram.me/userinfobot) to get YOUR chat id. Your notifications will come in from your newly created bot. (tip: these same values can be given to Radarr/Sonarr/Ombi/others that support native Telegram notification and you can see all your Plex shenanigans in the same chat)

Alternatively, you can use Synology's built-in notification system to send to Telegram and the script will support that too without any changes. 

### Download Script
SSH in to the NAS and download this script, via a command like `sudo wget https://github.com/Nascentes/plexupdate/raw/master/plexupdate.sh`
Or just download it to you local machine and copy it into a preferred location on you Synology.

### Setup Scheduler
Synology Control Panel => Task Scheduler => Add : "User-defined script" task  
Set it to execute as "root" & set the command simliar to the following:  
`/volume1/Scripts/plexupdate.sh`
or a place reachable without SSH:
`/volume1/homes/YOUR_USER_ACCOUNT/Scripts/plexupdate.sh`

I would also suggest directing to a log file so you can review in the event of issues. eg:
`/volume1/Scripts/plexupdate.sh >> /volume1/Scripts/plexupdate.log 2>&1`

### #BASHNOOBFAIL
!!! Windows devs be wary, I spent most of my time debugging script execution issues that all stemmed from Windows Line Endings not having much experience in BASH scripting, and it wasnt until I was able to sort that out that I finally started actually being able to DEBUG and run the code successfully !!!

Original source found here - https://forums.plex.tv/t/script-to-auto-update-plex-on-synology-nas-rev4/479748/36?u=martino

### Why this fork?
Mostly to add telegram functionality. Also because @bryanhunwardsen's formatting changes were preferred over the original. Preference.

Original notes from @bryanhunwardsen
I forked @nitantsoni's repo as it was a little more mature than the original, but it did not work for me OOTB and there was a running amount of bug/fixes, added features, suggestions for code improvement, etc in the PLEX forum that were not captured in the origin or forked repos. As I learned what the script was doing, debugging, and refactoring to match a code and naming convention I was more comfortable with, I ended up with a final result that I thought was worthy to publish as PR's to the upstream repos may have floundered based on activity.

Please refer to the thread and other forks to help with issues you may face that I did not.

### Big Thanks to @martinorob for this, it really solved a nagging issue of running PLEX Server on Synology!
