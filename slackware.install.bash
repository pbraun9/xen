#!/bin/bash

slackmount=/tmp/slack
dummy=0

for set in a ap d f l n; do
	for pkg in `egrep ':ADD$|:REC$' slackware64/$set/tagfile | cut -f1 -d:`; do
	        #egrep "^slackware64/$set/$pkg-[[:alnum:]\._]+-[[:alnum:]_]+-[[:digit:]]+.txz$"
		pkgfix=`echo $pkg | sed 's/+/\\\+/g'`
	        pkgfile=`find slackware64/ -type f | egrep "^slackware64/$set/$pkgfix-[^-]+-[^-]+-[^-]+.txz$"`
	        [[ -z $pkgfile ]] && echo no txz archive found for $pkg && exit 1
		(( `echo $pkgfile | wc -l` != 1 )) && echo "too much results for $pkg:\n$pkgfile" && exit 1
		echo -n installpkg --root $slackmount $pkgfile...
		(( $dummy == 0 )) && installpkg --root $slackmount $pkgfile >/dev/null && echo done
		(( $dummy == 1 )) && echo \(dummy\)
		unset pkgfix pkgfile
	done; unset pkg
done; unset set

for pkg in ModemManager NetworkManager; do
	echo -n ROOT=$slackmount removepkg $pkg...
	ROOT=$slackmount removepkg $pkg >/dev/null && echo done
done; unset pkg

