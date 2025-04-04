#!/bin/sh
D=`date +%Y%m%d-%H%M`
TAG=`git describe --dirty --tags --match 'v[0-9]*' --always | sed -e 's/^v//; s/-dirty/-'"$D/"`
if [[ "$TAG" =~ ^[0-9a-f]+-[0-9]{8}-[0-9]{4}$ ]]; then
  echo "$TAG" # use as is when based on commit i.e. v959x563-20250321-1122 (v<commit>-<date>-<time>)
else
  SUFF=`echo $TAG | sed -e 's/[^-]*//'`
  if [ "X$SUFF" = "X" ] ; then
    # if no -hash or -dirty, just take the tag
    echo "$TAG"
  else
    # otherwise, bump the last number of semver
    # in semver 0.0.7 > 0.0.7-something (think 0.0.7-rc4)
    PREF=`echo $TAG | sed -e 's/-.*//; s/\(.*\)\.[0-9]*/\1/'`
    LAST=`echo $TAG | sed -e 's/-.*//; s/.*\.//'`
    echo "$PREF.$(($LAST+1))$SUFF"
  fi
fi
