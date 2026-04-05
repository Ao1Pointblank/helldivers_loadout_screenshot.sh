#!/bin/bash
#dependencies: scrot, xdotool, xrandr, imagemagick, paplay (optional)

#you will need to determine your own scrot pixel coordinates
#optionally, set a paplay sound effect and output path

#detect window or quit
if [[ "$(xdotool getactivewindow getwindowname)" != "HELLDIVERS™ 2" ]]; then
   echo "active window is not HD2; closing script."
   exit 1
fi

#determine screen resolution
resolution="$(xrandr | grep '*' | awk '{ print $1 }')"


#apply values based on determined resolution using a dictionary
#explanation:

#each dictionary entry is 3 space-separated elements:
#  1: dimensions for the initial, larger screenshot, which includes player card and selected stratagems.
#     this is 4 numbers X,Y,W,H where X,Y is the coordinates of the top left of the player card, and W,H are the width and height of the screenshot.

#  2: dimensions for the smaller screenshot which is overlayed on the prior. this one includes weapons and armor choices.
#     this is 4 numbers X,Y,W,H where X,Y is the coordinates of the top left of the equipment/armor picker, and W,H is the width and height of this rectangle.

#  3: vertical offset from the top of the first screenshot, whereat the second screenshot will be composited.
#     this is a single digit.

declare -A resolutions=(
    ["3440x1440"]="512,252,562,1040 512,956,562,267 590"
    ["1280x800"]="35,125,282,522 35,476,282,136 291"
)

#check if the resolution is in the dictionary
if [[ -z "${resolutions[$resolution]}" ]]; then
   echo "Resolution $resolution unaccounted for. Please manually determine pixel coordinates and add them to the script."
   exit 1
fi

#split dictionary values into an array
IFS=' ' read -r -a scrot_values <<< "${resolutions[$resolution]}"


#use explicit .png extension for clarity
temp_file1=$(mktemp --suffix=.png)
temp_file2=$(mktemp --suffix=.png)

#capture main screenshot
#scrot --autoselect uses X,Y,W,H
#X,Y is the top left of the rectangle to screenshot
#W,H is the width to the right and H is the height down to the bottom of the selection
scrot --autoselect=${scrot_values[0]} -o -F "$temp_file1"

#switch to equipment view
sleep 1; /bin/bash -c "xdotool key r"

#screenshot smaller rectangle of the equipment slots
sleep 1; scrot --autoselect=${scrot_values[1]} -o -F "$temp_file2"

#check if files were created and are valid
if [[ ! -s "$temp_file1" ]] || [[ ! -s "$temp_file2" ]]; then
  echo "Error: Failed to capture screenshots."
  rm -f "$temp_file1" "$temp_file2"
  exit 1
fi

#set output directory and naming convention
output_dir="$HOME/Pictures/Helldivers/HD2 Loadouts"

#create output directory if not existing
mkdir -p "$output_dir"

#date convention to use
timestamp=$(date +%m%d%y_%H%M)
final_output="$output_dir/loadout_$timestamp.png"

#composite using imagemagick
magick "$temp_file1" "$temp_file2" -geometry +0+${scrot_values[2]} -composite "$final_output"

echo "Screenshot saved as $final_output"

#play sound effect
paplay "$HOME/Downloads/HD2 SOUNDS/stratagem_hero/correct.ogg"

#cleanup
rm -f "$temp_file1" "$temp_file2"


###TODO:
#- gather more data from other common resolutions
#- allow easier importing of coordinate data - instead of having to get coordinates AND width/height, only gather coordinate data and make the script do the math to calculate width and height. X coordinate and width will be the same for both screenshots.
