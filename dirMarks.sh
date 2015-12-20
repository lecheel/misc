# Copyright (c) 2014, Lechee http://lecheel.hopto.org
# All rights reserved.
# 
# USAGE: 
# s dirmark [color] - saves the curr dir as dirmarkname color [0..7]
# l dirmark - jumps to the that dirmark
# l tags

# setup file to store dirmarks
if [ ! -n "$LDIRS" ]; then
    LDIRS=~/.ldirs
fi
touch $LDIRS

if [ ! -f ~/.tags ]; then
touch ~/.tags 
fi

if [ ! -f ~/.cscope ]; then
touch ~/.cscope
fi

# list dirmarks with dirnam
function l {
    if [[ $1 == "?" ]]; then
	echo "list dirmarks:"
	echo "  l [nnn]  -- jump nnn local bookmark"
	echo "  l cs     -- for env(CSCOPE_DB)"
	echo "  l tags   -- for env(TAGFILE)"
	echo "  l ed     -- modify bookmark"
    	return
    fi
    if [[ $1 == "tags" ]] || [[ $1 == "0" ]]; then
       if [[ -f tags ]]; then
          export TAGFILE=`pwd`/tags
       else
          echo -e "Use \033[94mctags -R\033[0m create tags first!" 
          export TAGFILE=`pwd`/tags
       fi
       echo -e '\033[91m'TAGFILE='\033[0m'$TAGFILE
       echo $TAGFILE > ~/.tags
       return
    fi
    if [[ $1 == "ed" ]]; then
	echo -e "bookmark via ~/\033[92m.ldirs\033[0m"
	vim ~/.ldirs
	return	
    fi
    if [[ $1 == "cs" ]]; then
       if [[ -f cscope.out ]]; then
#          export CSCOPE_DB=`pwd`/cscope.out
          export CSCOPE_DB=`pwd`/
	  echo "CSCOPE_DB set as $CSCOPE_DB"
       else
          echo -e "Use \033[94mlecs cs -R\033[0m create cscopt DB first!" 
       fi
       echo -e '\033[91m'CSCOPE_DB='\033[0m'$CSCOPE_DB
       echo $CSCOPE_DB > ~/.cscope
 
       return
    fi
    if [[ $1 == "-v" ]] || [[ $1 == "-?" ]]; then
      echo -e ' dirMarks\033[0m (l/s)'
      echo -e "            _ \033[92m_\033[0m      __  __            _     "
      echo -e "         __| \033[92m(_)\033[0m_ __|  \/  | __ _ _ __| | __ "
      echo "        / _\` | | '__| |\/| |/ _\` | '__| |/ / "
      echo "       | (_| | | |  | |  | | (_| | |  |   <  "
      echo "        \__,_|_|_|  |_|  |_|\__,_|_|  |_|\_\ "
      echo "                        PoWER by Lechee 2o14" 
      TAGS=`tail -1 ~/.tags`
      export TAGFILE=$TAGS

      CS=`tail -1 ~/.cscope`
      export CSCOPE_DB=$CS
	
               
      if [[ $TAGFILE == "" ]]; then
         echo -e "     0  tags    \033[93mTAGFILE\033[0m NOT SET!!!  "  
      else
 	 echo -e "     0  tags    \033[93mTAGFILE =\033[0m" $TAGFILE	  
      fi

      if [[ $CSCOPE_DB == "" ]]; then
         echo -e "     0  tags    \033[93mCSCOPE_DB\033[0m NOT SET!!!  "  
      else
 	 echo -e "     0  tags    \033[93mCSCOPE =\033[0m" $CSCOPE_DB	  
      fi
	return
      echo -e '   \033[94m--+-------------------\033[0m'
      cat -n $LDIRS
      echo -e '   \033[94m--+-------------------\033[0m'
      return
    fi    
    
    
    if [[ $1 == "" ]]; then
      TAGS=`tail -1 ~/.tags`
      export TAGFILE=$TAGS
               
      CS=`tail -1 ~/.cscope`
      export CSCOPE_DB=$CS

      if [[ $TAGFILE == "" ]]; then
         echo -e "     0  tags    \033[93mTAGFILE\033[0m NOT SET!!!  "  
      else
 	 echo -e "     0  tags    \033[93mTAGFILE =\033[0m" $TAGFILE	  
      fi

      if [[ $CSCOPE_DB == "" ]]; then
         echo -e "     0  tags    \033[93mCSCOPE_DB\033[0m NOT SET!!!  "  
      else
 	 echo -e "     0  tags    \033[93mCSCOPE =\033[0m" $CSCOPE_DB	  
      fi



    fi

#    source $LDIRS
        
    if [[ $1 == "" ]]; then
      echo -e '   \033[94m--+-------------------\033[0m'
      cat -n $LDIRS
      echo -e '   \033[94m--+-------------------\033[0m'
      echo -n "Select dirMark: "
      unset choice
      read -e choice 
      if [[ $choice -eq "0" ]]; then
         return
      fi
      NUMC=$choice
      NUMP=p
      NUM=$NUMC$NUMP
#      ADIR=`sed -n "$NUM" $LDIRS| awk -F "=" '{printf $2}'|tr -d '"'`
      ADIR=`sed -n "$NUM" $LDIRS| awk -F "=" '{printf $2}'`
      cd $ADIR
      export TAGFILE=`pwd`/tags
  
    else
      NUM=$1p
      RE="^[0-9]+$"
      if ! [[ $1 =~ $RE ]]; then
        echo "Only number is valid"
        
      else
	if [[ $NUM == "0p" ]]; then
	  cat -n $LDIRS
	else  
# for Linux
          ADIR=`sed -n "$NUM" $LDIRS| awk -F "=" '{printf $2}'`
# for OSX
#          ADIR=`sed -n "$NUM" /tmp/bookmark| awk -F "=" '{printf $2}'`
	  cd $ADIR
        fi
      fi
    fi

}

function _l {
   grep '=' $LDIRS | cut -c6- | sort | sed 's/\x1b//g' | cut -f1 -d "["
}


function s {
#    echo `pwd`
    _bookmark_name_valid "$@"
    if [[ $2 == "" ]]; then
      if [ -z "$exit_message" ]; then
          CURDIR=$(echo $PWD)
#          result=$(printf '\033[92m %-30s\033[0m = %s\n' $1 $CURDIR);
#          echo -e $result >> $LDIRS
        echo -e "\033[92m$1\033[0m\t\t= $CURDIR" >> $LDIRS
      fi    
    else
      XX=$[90 + $2]
      CURDIR=$(echo $PWD)
      cmd="\033[$XX""m$1\033[0m\t\t= $CURDIR"
      echo -e $cmd >> $LDIRS
    fi
}

# validate bookmark name
function _bookmark_name_valid {
    exit_message=""
    if [ -z $1 ]; then
        exit_message="bookmark name required"
        echo $exit_message
    elif [ "$1" != "$(echo $1 | sed 's/[^A-Za-z0-9_]//g')" ]; then
        exit_message="bookmark name is not valid"
        echo $exit_message
    fi
}

# completion command
function _comp {
    local curw
    COMPREPLY=()
    curw=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=($(compgen -W '`_lecp`' -- $curw))
    return 0
}


function _lecp {
   cat ~/.lecpls
   ls -p | grep -v /
}

function _letool {
   cat ~/.letool
}

function lecp {
PC=`uname -a|awk -F' ' '{print $2}'`
if [[ $PC == "lePC" ]] || [[ $PC == "lecheeldeMac-Pro.local" ]]; then
    DEST="192.168.0.2"
    echo "Local $DEST"
else
    DEST="lesrc.hopto.org"
#    DEST="192.168.0.2"
fi
PORT=22
echo $DEST $PORT


if [[ $1 == "ls" ]]; then
   figlet "last 10 uploads"
   ssh -p $PORT $DEST ls -ltr /tmp | tail -10 | tee ~/.lecp
#   sed '1,3d' ~/.lecp | awk -F" " '{print $(NF)}' >~/.lecpls
   cat ~/.lecp | awk -F" " '{print $(NF)}' >~/.lecpls   
   return
fi   

if [[ $1 == "la" ]]; then
   figlet "last 30 uploads"
   ssh -p $PORT $DEST ls -ltr /tmp | tail -30 | tee ~/.lecp
   cat ~/.lecp | awk -F" " '{print $(NF)}' >~/.lecpls   
   return
fi   

if [[ $1 == "rm" ]]; then
    echo -e "(\033[92mRemove\033[0m $2)"
    read -e -p "Do you want to delete $2 -> $DEST... ?(y/N)" -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY == "" ]];then
	REPLY="N"
    fi
    if [[ $REPLY =~ ^[Yy]$ ]]; then
	ssh -p $PORT $DEST "rm /tmp/$2"
	echo "Removed!!!"
	return
    fi 
    return   
fi   

if [[ $# -eq 1 ]]; then
   if [[ -f $1 ]]; then
       echo -e "(\033[92mupload\033[0m)"
       read -e -p "Do you want to copy $1 -> $DEST... ?(Y/n)" -n 1 -r
       echo    # (optional) move to a new line
       if [[ $REPLY == "" ]]; then
          REPLY="Y"
       fi
       if [[ $REPLY =~ ^[Yy]$ ]]; then
	   echo -e "scp -p $PORT \033[91m$1\033[0m --> lesrc...:/tmp"
	   scp -P $PORT $1 $DEST:/tmp; 
       else
	   return
       fi
       #     scp $1 $DEST:/tmp
   else
     echo -e "\033[91m$1\033[0m not exist"
     read -e -p "Do you want to Download? (Y/n)" -n 1 -r
     echo    # (optional) move to a new line
     if [[ $REPLY == "" ]]; then
	 REPLY="Y"
     fi
     if [[ $REPLY =~ ^[Yy]$ ]]; then
	 scp -P $PORT $DEST:/tmp/$@ . 
     else
	 return
     fi
   fi
   return
fi

if [[ $1 == "" ]]; then
    echo -e "lecp from $DEST (\033[93m$VER\033[0m)"
else
   echo -e "(\033[96mDownload\033[0m)" 
   scp -P $PORT $DEST:/tmp/$@ 
fi   

}

shopt -s progcomp
complete -F _comp lecp
