#!/bin/bash

#------------- Enable Globs  -------------#

shopt -s globstar

#----------  Defined variables  ----------#

tv_dir=/home/downloads/tv
movies_dir=/home/downloads/movies
log=/var/log/cleaner.log
time=`date "+%Y-%m-%d %H:%M:%S"`

#-------------  Conversion   -------------#

for i in **/*.mkv;
    do
      sudo ffmpeg -i "$i" -c copy -c:a aac -movflags +faststart "${i%.*}.mp4";
      echo $i "completed conversion" >> $log
      rm -rf $i
      echo "removal successful" >> $log
done

for i in **/*.avi;
    do
      ffmpeg -i "$i" -c:a aac -b:a 128k -c:v libx264 -crf 21 "${i%.*}.mp4"
      echo $i "completed conversion" >> $log
      rm -rf $i
      echo "removal successful" >> $log
done

#-------------  The Mover  -------------#

for x in **/*.mp4;
  do
    runtime=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$x")
      if [[  $runtime > 3000  ]];
        then
          mv $x $movies_dir
          echo $time "MOVIES <---- " $x >> $log
        else
          mv $x $tv_dir
          echo $time "TV <------ " $x >> $log
      fi
done

echo "script executed at "$time >> $log
sleep 1.5
exit 0
