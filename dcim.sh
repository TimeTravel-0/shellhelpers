#!/bin/bash
# sudo apt-get install libimage-exiftool-perl

#path to search images
dcim_path=( $(echo "/media/*/DCIM") )

# The date pattern for the destination dir (see strftime)
DEST_DIR_PATTERN="%Y/%m/%d/%Y_%m_%d_%H_%M_%S"

# find numbered subfolder(s)
imagefolder=( $(ls $dcim_path) )

outdir="/tmp/camimport"



for index in ${!imagefolder[*]}
do
    complete_path=$dcim_path/${imagefolder[$index]}
    echo "$complete_path"
    images_in_this_folder=( $(ls $complete_path/*.*) )
    
    
    for i in ${!images_in_this_folder[*]}
    do
        fn=${images_in_this_folder[$i]}
        f_date=`exiftool "$fn" -CreateDate -d $DEST_DIR_PATTERN | cut -d ':' -f 2 | sed -e 's/^[ \t]*//;s/[ \t]*$//'`;
        f_md5=( $(md5sum $fn) )
        f_suffix=( $(echo $fn|awk -F . '{print $NF}') )
        #echo "file: $f_md5 $f_suffix $f_date $fn "

        output_path="$outdir/""$f_date""_$f_md5.$(echo $f_suffix | tr '[A-Z]' '[a-z]')"
        input_path=$fn
        
        output_path_cutfn=${output_path%/*}
        
        
        echo "----------------------------------------"
        echo "input:" $input_path
        echo "output:" $output_path
        #echo $output_path_cutfn
        
        
        mkdir -p $output_path_cutfn        
        cp $input_path $output_path
        
    done
    
done


exit 0  

