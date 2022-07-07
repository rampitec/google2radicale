#!/bin/bash

F=
PHOTO=

while IFS= read -r line; do
  line="${line%%[[:space:]]}"
  if [ -n "$PHOTO" ] ; then
    if [[ "$line" =~ ^" " ]] ; then
      PHOTO="${PHOTO}${line##[[:space:]]}"
      continue
    fi
    echo -n "PHOTO;ENCODING=b;TYPE=jpeg:" >> $F
    curl -o - -s --show-error "$PHOTO" | base64 -w0 >> $F
    echo "" >> $F
    PHOTO=
  fi
  if [ "$line" = "BEGIN:VCARD" ] ; then
    uid=`uuidgen`
    uid=${uid%%[[:space:]]}
    F=$uid.vcf
    echo "$line" > $F
    continue
  fi
  if [[ "$line" =~ ^"VERSION:" ]] ; then
    echo "$line" >> $F
    echo UID:$uid >> $F
    continue
  fi
  if [ "$line" = "END:VCARD" ] ; then
    echo REV:`date --iso-8601=seconds --utc | sed 's/+00:00$/Z/'` >> $F
    echo X-RADICALE-NAME:$F >> $F
    echo "$line" >> $F
    F=
    continue
  fi
  if [[ "$line" =~ ^"PHOTO:" ]] ; then
    PHOTO="${line#PHOTO:}"
    continue
  fi
  echo "$line" >> $F
done
