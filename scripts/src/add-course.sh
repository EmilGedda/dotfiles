#!/usr/bin/env bash

trap 'echo "Unable to complete setup"; exit' ERR

if [[ "$#" -ne 2 ]]; then
    echo -n "Course ID: "
    read ID
    echo -n "Course nickname: "
    read NICK
else 
    ID="$1"
    NICK="$2"
fi

P=$(pwd)
cd ~/KTH/Courses

ID=$(echo ${ID^^} | xargs)      # Trim off excessive whitespaces 
NICK=$(echo ${NICK,,} | xargs) 

IDF="by-id/$ID"
NICKF="by-nick/$NICK"

mkdir -p by-name/{sv,en} "./$IDF" by-nick
ln -s "../$IDF" "$NICKF" 

curl -s "http://www.kth.se/api/kopps/v1/course/$ID" \
    | sed -n 's;[[:space:]]\+<title xml:lang="\(.*\)" .*>\(.*\)</title>;\1 "\2";p' \
    | xargs -l bash -c '
        ln -s '"../../$IDF"' ./by-name/"$0"/"$1";

        elinks -dump -no-references "http://www.kth.se/student/kurser/kurs/'"$ID"'?l=$0" \
            | sed -ne "/\(.*\)$1\(.*\)/,\$p" \
            | sed -e "s/\[[[:digit:]]\+\]//g" \
            | sed -e "/Kurstillfällen\(.*\)/,/Lärandemål/{//!d}" \
            | sed -e "/Kurstillfällen\(.*\)/d" \
            | sed -e "/Course offerings/,/Learning outcomes/{//!d}" \
            | sed "/Course offerings/d" \
            | sed "/^'"$ID"'$/Q" \
            > "'"$IDF"'/info.$0.txt"'

cd "$P"
echo "Setup complete."
