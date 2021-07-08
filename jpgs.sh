#!/bin/bash

# Colors
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_MAGENTA=$ESC_SEQ"35;01m"
COL_CYAN=$ESC_SEQ"36;01m"


current_time=$(date "+%Y.%m.%d-%H.%M.%S")
logfile='import.log';

#loop over subfolders
for d in */ ; do
    cd $d;
    $cwd;
    for i in *.JPG;      do
    echo -e $COL_YELLOW "######################################################################## " $COL_RESET
    found=$((found+1))
    echo -e $COL_GREEN "Detected movie $i " $COL_RESET
        #remove file extension  (.mpg):
        v2=${i::-4}
  	echo "dat is $v2";
	mv $v2.JPG $v2.jpg
    cd ..;
#	fi
	done
done
