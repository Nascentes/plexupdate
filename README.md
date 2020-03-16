# Description
Automatically update Plex Media Server installed on Synology NAS via the Package Center PLEX Server Syno Package

# How to
Download this script/copy onto Synology NAS and create a Scheduled Task to run it. The script will check to see if the latest version is newer than the installed version and then proceed to update as needed.

This script is configured to use the Public repo, additioanl code for the private PLEXPASS repo is included commented out. I have not tested it, but has been verified is other forms from the upstream repo's this was forked from.
You will need to install the PLEX INC. cert into Package Center for PLEXPASS premium repo access.

### Download Script
SSH in to the NAS and download this script, via a command like `sudo wget https://github.com/nitantsoni/plexupdate/raw/master/plexupdate.sh`
Or just download it to you local machine and copy it into a preferred location on you Synology.

### Setup Scheduler
Synology Control Panel => Task Scheduler => Add : "User-defined script" task  
Set it to execute as "root" & set the command simliar to the following:  
`bash /volume1/Scripts/plexupdate.sh`
or a place reachable without SSH:
`bash /volume1/homes/YOUR_USER_ACCOUNT/Scripts/plexupdate.sh`

### #BASHNOOBFAIL
!!! Windows devs be wary, I spent most of my time debugging script execution issues that all stemmed from Windows Line Endings not having much experience in BASH scripting, and it wasnt until I was able to sort that out that I finally started actually being able to DEBUG and run the code successfully !!!

Original source found here - https://forums.plex.tv/t/script-to-auto-update-plex-on-synology-nas-rev4/479748/36?u=martino

### Why this fork?
I forked @nitantsoni's repo as it was a little more mature than the original, but it did not work for me OOTB and there was a running amount of bug/fixes, added features, suggestions for code improvement, etc in the PLEX forum that were not captured in the origin or forked repos. As I learned what the script was doing, debugging, and refactoring to match a code and naming convention I was more comfortable with, I ended up with a final result that I thought was worthy to publish as PR's to the upstream repos may have floundered based on activity.

Please refer to the thread and other forks to help with issues you may face that I did not.

### Big Thanks to @martinorob for this, it really solved a nagging issue of running PLEX Server on Synology!
