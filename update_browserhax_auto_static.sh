#!/bin/bash
# Usage: ./update_browserhax_auto.sh <path to repos base directory> <path to pub_html root> <webpageURL>
# example: ./update_browserhax_auto.sh /home/user/repos /home/user/public_html "http://example.com"

# please install the package qrencode for automated qrcode generation
# apt-get install qrencode

# You will have to adjust for hard-coded absolute file-paths used in the scripts.
# See also the setup described here: https://github.com/yellows8/3ds_browserhax_common

if [ "$#" -ne 3 ]; then
	echo "Usage: ./update_browserhax_auto.sh <path to repos base directory> <path to pub_html root> <webpageURL>"
	echo 'Example: ./update_browserhax_auto.sh /home/user/repos /home/user/public_html "http://example.com"'
	exit 1
fi

repobase=$1
webroot=$2
websitebase=$3

newid=$(date +%s | sha256sum | base64 | head -c 32)


if [[ -n $(find $repobase -mindepth 1 -maxdepth 1 -type d ! -name browserhax_site ! -name 3ds_browserhax_common ! -name browserhax_fright ! -name 3ds_webkithax) ]]; then
	echo "WARNING: It's recommended to create an empty directory specifically for the repos."
	read -p "Continue anyway (y/N)? " choice
	case "$choice" in
		y|Y ) ;;
		* ) exit 1;;
	esac
fi

if [[ $repobase != /* ]]; then
	echo "WARNING: You are not using the full path for the repository base. This will probably break the symlinks and not work."
	if [ -z "$repobase" ]; then echo "Example: $(pwd)/$repobase"; else echo "Example: $(pwd)"; fi
	read -p "Continue anyway (y/N)? " choice
	case "$choice" in
		y|Y ) ;;
		* ) exit 1;;
	esac
fi


function get_repo
{
	echo "Processing $1..."
	cd "$repobase"
	if [[ -d $1 ]]; then
		cd "$1" && git reset --hard && git pull --progress
	else
		git clone "https://github.com/yellows8/$1.git" --progress
	fi
}

function create_symlink
{
	if [ ! -L "$webroot/$2" ]; then
		ln -s "$repobase/$1" "$webroot/$2"
	fi
}

function copy_file
{
	if [ ! -e "$webroot/$2" ]; then
		cp -p "$repobase/$1" "$webroot/$2"
	fi
}

function copy_file_force
{
	cp -pf "$repobase/$1" "$webroot/$2"
}

function batch_copy_force
{
	find $repobase/$1 -maxdepth 1 -type f -name "$2" -exec cp -pf "{}" "$webroot/" \;
}

function replace_hardcoded
{
	find $repobase/$1 -type f -exec sed -i "s#$2#$3#g" {} \;
}

hardcodedpath="/home/yellows8/browserhax"

get_repo browserhax_site
get_repo 3ds_browserhax_common
get_repo browserhax_fright
get_repo 3ds_webkithax

replace_hardcoded browserhax_site $hardcodedpath $webroot
replace_hardcoded 3ds_browserhax_common $hardcodedpath $webroot
replace_hardcoded browserhax_fright $hardcodedpath $webroot
replace_hardcoded 3ds_webkithax $hardcodedpath $webroot

copy_file_force browserhax_site/3dsbrowserhax.php 3dsbrowserhax.php
copy_file_force browserhax_site/3dsbrowserhax.php 3dsbrowserhax_auto.php

batch_copy_force 3ds_browserhax_common/ "3dsbrowserhax*\.php"


batch_copy_force browserhax_fright/ "*\.php"
batch_copy_force browserhax_fright/ "*\.mp4"

# Obsolete exploits are not included here.

batch_copy_force 3ds_webkithax/ "*\.php"

if [ ! -z "$websitebase" ]; then
	curl -o $webroot/3dsbrowserhax_auto_qrcode.png -G -s "https://chart.googleapis.com/chart?cht=qr&chs=150x150"  --data-urlencode "chl=$websitebase/3dsbrowserhax_auto.php"
fi


if [ ! -e "$webroot/browserhax_cfg.php" ]; then
	curl -s -o $webroot/browserhax_cfg.php https://raw.githubusercontent.com/Cartman123/update_browserhax/master/browserhax_cfg.php
	sed -i "s/<someid>/$newid/g" $webroot/browserhax_cfg.php
fi

mkdir -p $webroot/payloads
rm -f $webroot/payloads/3ds_arm11code.bin
cd $repobase/3ds_browserhax_common
make OUTPATH=$webroot/payloads/

