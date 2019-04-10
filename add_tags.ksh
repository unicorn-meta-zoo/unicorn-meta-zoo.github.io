#!/usr/bin/env ksh
set -e # halt script on error
set -x

post=$1

yaml=`basename -s md $post`yaml
awk '/^\--- *$/ { ++delim; next } { if(delim == 1) print }' $post > $yaml

for i in episode title artist comment year recording_date episode_url; do
    yq r $yaml $i | read $i
done

if [ ! -e E$episode.jpg ]; then
    if [ ! -e E$episode.png ]; then
        # https://bitbucket.org/balpha/go-unicornify
        ~/go/bin/go-unicornify -h E$episode -s 3000 -shading -grass
    fi

    convert -quality 75 E$episode.png E$episode.jpg
fi

for i in url; do
    yq r channel.yml :$i | read $i
done

echo $url | sed -e 's/:/\\\\:/' | read url

description=`pandoc $post -t markdown`
html_desc=`pandoc $post`

file=`basename -s md $post`mp3

eyeD3 --remove-all $file

eyeD3 --track $episode \
      --add-image "$url/E$episode.jpg:FRONT_COVER"  \
      --title "$title" \
      --artist "$artist" \
      -Y $year \
      --recording-date "$recording_date"\
      --comment "$comment" \
      --text-frame="TDES:$html_desc" \
      --url-frame "WOAF:$episode_url" \
      --album "Unicorn Meta Zoo" \
      --genre 186 \
      $file

## I'm not sure this is actually useful.
#      --text-frame="TIT3:$description" \


eyeD3 -P itunes-podcast $file --add

dropcaster --channel-template templates/channel.rss.erb \
    | xmllint --format - > index.rss
