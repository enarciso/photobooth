#!/bin/bash

SUFFIX=$(date +%m%d%g_%I%M)

#Base paths
DIR=/srv/photobooth
IMG_SOURCE=$DIR/source
IMG_DEST=$DIR/compile
IMG_BANNER=$DIR/banner/Sophia_Banner.png

# Compile image to a 2x2 montage + banner
MONTAGE_TEMP=temp_$SUFFIX.jpg
MONTAGE_COMPILE=compile_$SUFFIX.jpg
MONTAGE_FINAL=final_$SUFFIX.jpg


#Printer
PRINTER=`lpstat -p |grep printer |awk '{print $2}'`

#Print error of no image
NO_IMG_ERR=`echo "No images were found exiting ..."`

if [ -s $IMG_SOURCE/capt0000.jpg ]
  then
    mkdir -p $IMG_SOURCE/$SUFFIX
    mv $IMG_SOURCE/*.jpg $IMG_SOURCE/$SUFFIX/
    mogrify -resize 968x648 $IMG_SOURCE/$SUFFIX/*.jpg
      if [ -s $IMG_SOURCE/$SUFFIX/capt0000.jpg ]
        then
          mkdir -p $IMG_DEST/$SUFFIX
          montage $IMG_SOURCE/$SUFFIX/*.jpg -tile 2x2 -geometry +10+10 $IMG_DEST/$SUFFIX/$MONTAGE_TEMP
          montage $IMG_DEST/$SUFFIX/$MONTAGE_TEMP $IMG_BANNER -tile 1x2 -geometry +5+5 $IMG_DEST/$SUFFIX/$MONTAGE_FINAL
        else
          $NO_IMG_ERR
          exit 1
      fi
        if [ -s $IMG_DEST/$SUFFIX/$MONTAGE_FINAL ]
          then
            lp -d $PRINTER $IMG_DEST/$SUFFIX/$MONTAGE_FINAL -n 2
          else
            $NO_IMG_ERR
        fi 
  else
    $NO_IMG_ERR
    exit 1
fi
