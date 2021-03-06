#!/bin/bash
# server=build.palaso.org
# build_type=bt54
# root_dir=..
# Auto-generated by https://github.com/chrisvire/BuildUpdate.
# Do not edit this file by hand!

cd "$(dirname "$0")"

# *** Functions ***
force=0
clean=0

while getopts fc opt; do
case $opt in
f) force=1 ;;
c) clean=1 ;;
esac
done

shift $((OPTIND - 1))

copy_auto() {
if [ "$clean" == "1" ]
then
echo cleaning $2
rm -f ""$2""
else
where_curl=$(type -P curl)
where_wget=$(type -P wget)
if [ "$where_curl" != "" ]
then
copy_curl "$1" "$2"
elif [ "$where_wget" != "" ]
then
copy_wget "$1" "$2"
else
echo "Missing curl or wget"
exit 1
fi
fi
}

copy_curl() {
echo "curl: $2 <= $1"
if [ -e "$2" ] && [ "$force" != "1" ]
then
curl -# -L -z "$2" -o "$2" "$1"
else
curl -# -L -o "$2" "$1"
fi
}

copy_wget() {
echo "wget: $2 <= $1"
f1=$(basename $1)
f2=$(basename $2)
cd $(dirname $2)
wget -q -L -N "$1"
# wget has no true equivalent of curl's -o option.
# Different versions of wget handle (or not) % escaping differently.
# A URL query is the only reason why $f1 and $f2 should differ.
if [ "$f1" != "$f2" ]; then mv $f2\?* $f2; fi
cd -
}


# *** Results ***
# build: PdfDroplet-Win-Dev-Continuous (bt54)
# project: PdfDroplet
# URL: http://build.palaso.org/viewType.html?buildTypeId=bt54
# VCS: https://github.com/sillsdev/pdfDroplet [master]
# dependencies:
# [0] build: palaso-win32-master-nostrongname Continuous (Libpalaso_PalasoWin32masterNostrongnameContinuous)
#     project: libpalaso
#     URL: http://build.palaso.org/viewType.html?buildTypeId=Libpalaso_PalasoWin32masterNostrongnameContinuous
#     clean: false
#     revision: latest.lastSuccessful
#     paths: {"SIL.Core.dll*"=>"lib", "SIL.Core.pdb"=>"lib", "SIL.Core.Desktop.dll*"=>"lib", "SIL.Core.Desktop.pdb"=>"lib", "SIL.Windows.Forms.dll"=>"lib", "SIL.Windows.Forms.pdb"=>"lib", "L10NSharp.dll"=>"lib", "L10NSharp.pdb"=>"lib", "Ionic.Zip.dll*"=>"lib"}
#     VCS: https://github.com/sillsdev/libpalaso.git [master]

# make sure output directories exist
mkdir -p ../lib

# download artifact dependencies
copy_auto http://build.palaso.org/guestAuth/repository/download/Libpalaso_PalasoWin32masterNostrongnameContinuous/latest.lastSuccessful/SIL.Core.dll ../lib/SIL.Core.dll
copy_auto http://build.palaso.org/guestAuth/repository/download/Libpalaso_PalasoWin32masterNostrongnameContinuous/latest.lastSuccessful/SIL.Core.pdb ../lib/SIL.Core.pdb
copy_auto http://build.palaso.org/guestAuth/repository/download/Libpalaso_PalasoWin32masterNostrongnameContinuous/latest.lastSuccessful/SIL.Core.Desktop.dll ../lib/SIL.Core.Desktop.dll
copy_auto http://build.palaso.org/guestAuth/repository/download/Libpalaso_PalasoWin32masterNostrongnameContinuous/latest.lastSuccessful/SIL.Core.Desktop.pdb ../lib/SIL.Core.Desktop.pdb
copy_auto http://build.palaso.org/guestAuth/repository/download/Libpalaso_PalasoWin32masterNostrongnameContinuous/latest.lastSuccessful/SIL.Windows.Forms.dll ../lib/SIL.Windows.Forms.dll
copy_auto http://build.palaso.org/guestAuth/repository/download/Libpalaso_PalasoWin32masterNostrongnameContinuous/latest.lastSuccessful/SIL.Windows.Forms.pdb ../lib/SIL.Windows.Forms.pdb
copy_auto http://build.palaso.org/guestAuth/repository/download/Libpalaso_PalasoWin32masterNostrongnameContinuous/latest.lastSuccessful/L10NSharp.dll ../lib/L10NSharp.dll
copy_auto http://build.palaso.org/guestAuth/repository/download/Libpalaso_PalasoWin32masterNostrongnameContinuous/latest.lastSuccessful/L10NSharp.pdb ../lib/L10NSharp.pdb
copy_auto http://build.palaso.org/guestAuth/repository/download/Libpalaso_PalasoWin32masterNostrongnameContinuous/latest.lastSuccessful/Ionic.Zip.dll ../lib/Ionic.Zip.dll
# End of script
