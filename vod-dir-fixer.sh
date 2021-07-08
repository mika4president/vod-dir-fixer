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
touch $logfile
echo -e $COL_BLUE  "$current_time Movie Import start... " $COL_RESET
echo "$current_time Movie Import start... " >> $logfile


REQUIRED_PKG="libxml2-utils"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo -e $COL_BLUE Checking for $REQUIRED_PKG: $PKG_OK  $COL_RESET
if [ "" = "$PKG_OK" ]; then
    echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
    sudo apt-get --yes install $REQUIRED_PKG
fi

found=0
imported=0
$cwd;
for i in *.m*;      do
    echo -e $COL_YELLOW "######################################################################## " $COL_RESET
    found=$((found+1))
    echo -e $COL_GREEN "Detected movie $i " $COL_RESET
    echo "Detected movie $i ">> $logfile
    
    #remove file extension  (.mpg):
    v2=${i::-4}
    DIR="$v2"
    if [ -d "$DIR" ]; then
        ### Take action if $DIR exists ###
        echo -e $COL_RED "ERROR: SKIPPING  ${DIR} BECAUSE THIS FOLDER EXISTS" $COL_RESET
        echo  "ERROR: SKIPPING  ${DIR} BECAUSE THIS FOLDER EXISTS" >> $logfile
    else
        ### If $DIR does NOT exists ###
        imported=$((imported+1))
        mkdir $DIR;
        chmod -R 777 $DIR;
        echo -e $COL_GREEN "Creating folder..." $COL_RESET
        
        #Import movie poster
        POSTERFILE=$v2".JPG"
        if test -f "$POSTERFILE"; then
            mv $POSTERFILE $DIR/;
            echo -e $COL_GREEN "Importing movie poster." $COL_RESET
        else
            echo -e $COL_RED "Movie poster [$POSTERFILE] is missing for $v2"  $COL_RESET
            echo  "Movie poster [$POSTERFILE] is missing for $v2" >> $logfile
            
        fi
        
        #Import Metadata
        XMLFILE=$v2".XML"
        if test -f "$XMLFILE"; then
            echo -e $COL_GREEN "Importing metadata." $COL_RESET
            TITLE=$(xmllint --xpath 'string(/Film/Title)' $XMLFILE)
            GENRE=$(xmllint --xpath 'string(/Film/Genres/Genre)' $XMLFILE)
            LANGUAGE=$(xmllint --xpath 'string(/Film/Language)' $XMLFILE)
            YEAR=$(xmllint --xpath 'string(/Film/Year)' $XMLFILE)
            echo -e $COL_GREEN "TITLE IS $TITLE!" $COL_RESET
            echo -e $COL_GREEN "GENRE IS $GENRE!" $COL_RESET
            #echo -e $COL_GREEN "DURATION IS $DURATION!" $COL_RESET
            mv $XMLFILE $DIR/;
        else
            echo -e $COL_RED "Metadata [$XMLFILE] is missing for $v2"  $COL_RESET
            echo  "Metadata [$XMLFILE] is missing for $v2"  >> $logfile
        fi
        
        #relocate moviefile
        mv $v2".mpg" $DIR/;
    fi
done


echo -e $COL_BLUE "SCRIPT COMPLETED, $found MOVIES DETECTED" $COL_RESET
echo "SCRIPT COMPLETED, $found MOVIES DETECTED" >> $logfile