#! /bin/bash
echo -e "mini pack for leMUST" 
mdev=iMAC2
dstr=$(date +'%Y%m%d')_$mdev
afile=a01_$dstr.tgz
figlet $mdev
read -p "Press [Enter] key to start backup..."
cd ~/
rm -rf .emacs.d/auto-save-list
tar zcvf $afile bin/ .qerc .bash_profile dirMarks.sh .bashrc enviro .inputrc .screenrc .vimrc .jedrc .vim/ .emacs.d/ .gimp-2.8/scripts/ Library/Application Support/GIMP/2.8/scripts
figlet "scp to lesrc"

PC=`uname -a|awk -F' ' '{print $2}'`
if [[ $PC == "lePC" ]]; then
    DEST="192.168.0.2"
    echo "Local $DEST"
else
    DEST="lesrc.hopto.org"
#    DEST="192.168.0.2"
fi

read -p "Would you like to upload (Y/n)? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY == "" ]];then
    REPLY="Y"
fi
if [[ $REPLY =~ ^[Yy]$ ]]; then
    scp $afile $DEST:/tmp
else 
    exit
fi
