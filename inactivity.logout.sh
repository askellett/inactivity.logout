#!/bin/sh
exec 2>&1

# Get MacOSX idletime. Shamelessly stolen from http://bit.ly/yVhc5H
idleTime=$(/usr/sbin/ioreg -c IOHIDSystem | /usr/bin/awk '/HIDIdleTime/ {print int($NF/1000000000); exit}')

echo Idle Time is $idleTime seconds

if (( idleTime > 21600 )); then

## Get the logged in username
loggedInUser=$(stat -f%Su /dev/console)

## Get the logged in user's UID
loggedInUID=$(id -u "$loggedInUser")

## Run an Applescript logout immediately command as the user
/bin/launchctl asuser "$loggedInUID" sudo -iu "$loggedInUser" "/usr/bin/osascript -e 'ignoring application responses' -e 'tell application \"loginwindow\" to «event aevtrlgo»' -e end"
