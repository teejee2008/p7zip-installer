#!/bin/bash

app_name='p7zip'
app_fullname='p7zip'

Reset='\e[0m'
Red='\e[1;31m'
Green='\e[1;32m'
Yellow='\e[1;33m'

CHECK_COLOR_SUPPORT() {
	colors=`tput colors`
	if [ $colors -gt 1 ]; then
		COLORS_SUPPORTED=0
	else
		COLORS_SUPPORTED=1
	fi
}

MSG_INFO() {
	add_newline=''
	if [ "$2" == 0 ]; then
		add_newline='-n'
	fi

	if [ $COLORS_SUPPORTED -eq 0 ]; then
        echo -e ${add_newline} "${Green}$1${Reset}"
    else
        echo -e ${add_newline} "$1"
    fi
}

MSG_WARNING() {
	add_newline=''
	if [ "$2" == 0 ]; then
		add_newline='-n'
	fi

	if [ $COLORS_SUPPORTED -eq 0 ]; then
        echo -e ${add_newline} "${Yellow} ⚡ $1${Reset}"
    else
        echo -e ${add_newline} " ⚡ $1"
    fi
}

MSG_ERROR() {
	add_newline=''
	if [ "$2" == 0 ]; then
		add_newline='-n'
	fi

    if [ $COLORS_SUPPORTED -eq 0 ]; then
        echo -e ${add_newline} "${Yellow} ⚡ $1${Reset}"
    else
        echo -e ${add_newline} " ⚡ $1"
    fi
}

CD_PUSH() {
	cd_backup=`pwd`
}

CD_POP() {
	if [ ! -z "${cd_backup}" ]; then
		cd "${cd_backup}"
	fi
}

BACKUP_IFS(){
	IFS_backup="${IFS}"
}

SET_IFS_NEWLINE(){
	IFS=$'\n'
}

RESET_IFS() {
	if [ ! -z "${IFS_backup}" ]; then
		IFS="${IFS_backup}"
	fi
}

EXIT(){
	RESET_IFS
	CD_POP
	exit $1
}

WAIT_FOR_INPUT() {
	echo ""
	echo "Press any key to exit..."
	read dummy
}

GET_SCRIPT_PATH(){
	SCRIPTPATH="$(cd "$(dirname "$0")" && pwd)"
	SCRIPTNAME=`basename $0`
}

RUN_AS_ADMIN() {
	if [ ! `id -u` -eq 0 ]; then
		GET_SCRIPT_PATH
		if command -v sudo >/dev/null 2>&1; then
			sudo "${SCRIPTPATH}/${SCRIPTNAME}"
			EXIT $?
		elif command -v su >/dev/null 2>&1; then
			su -c "${SCRIPTPATH}/${SCRIPTNAME}"
			EXIT $?
		else
			echo ""
			MSG_ERROR "** Installer must be run as Admin (using 'sudo' or 'su') **"
			echo ""
			EXIT 1
		fi
	fi
}

CD_PUSH
CHECK_COLOR_SUPPORT
RUN_AS_ADMIN
BACKUP_IFS

SET_IFS_NEWLINE

echo ""
echo "=============================================================================="
MSG_INFO "Installing $app_fullname"
echo "=============================================================================="
echo ""

MSG_INFO "Expanding directories >>"
echo ""
for f in `find ./ -type d -exec echo "{}" \;`; do
    directory=`echo "$f" | sed -r 's/^.{2}//'`
    mkdir -p -m 755 "/$directory"
    echo "/$directory"
done
echo ""

MSG_INFO "Installing files >>"
echo ""
for f in `find ./ -type f \( ! -iname "install.sh" \) -exec echo "{}" \;`; do
    file=`echo "$f" | sed -r 's/^.{2}//'`
    install -m 0755 "./$file" "/$file"
    echo "/$file"
done
echo ""

RESET_IFS
echo "=============================================================================="
MSG_INFO "Install completed"
echo "=============================================================================="
#WAIT_FOR_INPUT
EXIT 0
