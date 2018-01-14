#!/bin/bash
set -e

# to be executed in folder /data/guests/

function usage {
	cat <<-EOF
	usage: $0 template.tar.gz
	EOF
	exit 1
}

[[ -z $1 ]] && usage
archive=$1
template=${archive%%\.*}

[[ -d $template/ ]] && echo $template/ already exists! && exit 1
[[ -f $template ]] && echo $template already exists BUT AS A FILE! && exit 1

du -h $archive
echo -n tar xSf $archive...
time tar xSf $archive && echo done
du -h $template/

cat <<EOF

you should now run,

	renameguest.bash $template NEW-NAME

EOF
