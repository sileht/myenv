#!/bin/bash

REMOTEPATH=/home/sileht/.mutt/attachments/
HTTPPATH='http://dl.sileht.net/mail/'

FILENAME=$(echo $1 | grep -E -o '[^\/]+$')

cp -f $1 $REMOTEPATH$FILENAME
chmod 644 "$REMOTEPATH$FILENAME"


clear
echo -e "\nCurrent attachements files:\n"
for file in $REMOTEPATH/* ;do
    echo $HTTPPATH$(basename $file)
done
echo -e "\nOpen $HTTPPATH$FILENAME to view the attachment.\n"
echo -n "(D)elete* or (K)eep or (V)iew: "
read -n 1 anwser
case $anwser in
    K|k)
        ;;
    V|v)
        mime=$(file -b --mime-type "$REMOTEPATH$FILENAME")
        case $mime in
            image/*)
                fim -t $REMOTEPATH$FILENAME
                ;;
            *)
                echo "mimetype not supported"
                ;;
        esac
        clear
        ;;
    *)

        clear
        echo "Removing file..."
        rm -f "$REMOTEPATH$FILENAME"
        ;;
esac
clear
