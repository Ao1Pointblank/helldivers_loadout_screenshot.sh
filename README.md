# ⚠️ Setting up this script will require some basic math skill (subtraction) and GIMP!
``dependencies: scrot, xdotool, xrandr, imagemagick, paplay (optional)``  
  
You will need to gather your own pixel coordinates to tell the script where to crop the images.  
I suggest using GIMP, which tells you precise coordinates when you hover over an image, and also has a measure tool which is useful for getting width and height of the areas to crop.  
  
If you have screenshots of your game, make an issue report and upload both you stratagem picker view and your equipment view, and I will attempt to add support for your screen res.  
Eventually I will update this script to just require coordinates, and not make people do the math to calculate width and heights.  
If you use a 3440x1440 display, you are in luck. That is what I use and is already configured.  
  
The script will attempt to detect your screen res with xrandr, and use the appropriate settings.  
The script also will not run outside of Helldivers; it uses an xdotool command to get the active windowname.  

      
<img width="1531" height="1129" alt="demo" src="https://github.com/user-attachments/assets/7cdc2c48-9e94-49bc-bd51-48ee51bef643" />


example result:  
<img width="562" height="1040" alt="loadout_040526_1454" src="https://github.com/user-attachments/assets/3de449fa-b834-435f-b40e-68784ba47cf4" />

  
# TODO:
- change from ``X1,Y1,W,H1`` + ``X2,Y2,W,H2`` + ``Z (vertical offset)``  
  to: ``X1a,Y1a`` + ``X1b,Y1b`` + ``X2a,Y2a`` + ``X2b,Y2b`` + ``Z``
- add more resolution support
- popup YAD window to sort loudouts by faction and rename them?
