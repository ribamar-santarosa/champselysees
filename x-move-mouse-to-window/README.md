Being an automation freak, sometimes I am lazy to move the mouse
to a certain window (in a
X window environment). Eg, if I want to move the mouse to a
window having "gmail.com", I do:

````
x-move-mouse-to-window.sh "gmail.com"
````
Or even:
````
x-move-mouse-to-window.sh "gmail.com" 400 200
````
And I point the mouse directly to the first message =)

If many windows match, it will go to any one of them. Be wise
giving the string to this script.

This script works better if you use the focus follow mouse cursor
of your window manager (I think only a few, like mine, WindowMaker, support
that), so you don't have
to click, but you can extend the script to make xtool click for you.

It still doesn't work properly with  many work spaces, and overlapping
windows (be wise setting your workspace positioning),  but multiple 
monitors shouldn't be a problem.
