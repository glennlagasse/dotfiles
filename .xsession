
USRMODMAP="/home/$USER/.Xmodmap"
USRXRESOURCES="/home/$USER/.Xresources"

if [ -f "$USRMODMAP" ]; then
    xmodmap "$USRMODMAP"
fi

if [ -f "$XUSRRESOURCES" ]; then
    xrdb -merge $XUSRRESOURCES
fi

exec i3
