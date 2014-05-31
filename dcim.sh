#!/bin/bash
################################################################################
# sudo apt-get install libimage-exiftool-perl
#
# source of inspiration: http://blog.irisquest.net/2008/05/ubuntu-organize-photos-in-folders-by_7784.html
#
################################################################################
 
# path to search images
dcim_path=( $(echo "/media/*/DCIM") )

# path to image archive
outdir="/home/usr/raid/media/img"

# The date pattern for the destination dir (see strftime)
DEST_DIR_PATTERN="%Y/%m/%d/%Y_%m_%d_%H_%M_%S"


################################################################################

# check if output dir exists and is ready, else quit

if [[ ! -e $outdir ]]; then
    echo "output directory $outdir does not exist? aborting..."
    exit
fi




# find numbered subfolder(s)
imagefolder=( $(ls $dcim_path) )

# iterate over them...
for index in ${!imagefolder[*]}
do
    complete_path=$dcim_path/${imagefolder[$index]}
    echo "$complete_path"
    images_in_this_folder=( $(ls $complete_path/*.*) )
    
    # for all files in this folder...
    for i in ${!images_in_this_folder[*]}
    do
        fn=${images_in_this_folder[$i]}

        fn_prefix=`echo $fn|cut -d. -f1 `
        fn_suffix=`echo $fn |cut -d. -f2-3 |tr -t [:lower:] [:upper:]`
        #echo mv $name $file_name.$file_ext
                
        echo ">>>"$fn_suffix
        
        if [ "$fn_suffix" == "JPG" ] || [ "$fn_suffix" == "AVI" ]; then
        
            if [ "$fn_suffix" == "AVI" ]; then
                fn_exifextract="$fn_prefix.THM"
            else
                fn_exifextract="$fn"
            fi
            
            #echo "$fn_exifextract"
        
        
            f_date=`exiftool "$fn_exifextract" -CreateDate -d $DEST_DIR_PATTERN | cut -d ':' -f 2 | sed -e 's/^[ \t]*//;s/[ \t]*$//'`;
            f_md5=( $(md5sum $fn) )
            f_suffix=( $(echo $fn|awk -F . '{print $NF}') )
            #echo "file: $f_md5 $f_suffix $f_date $fn "

            output_path_final="$outdir/""$f_date""_$f_md5.$(echo $f_suffix | tr '[A-Z]' '[a-z]')"
            output_path_prelim="$output_path_final"".tmp"
            input_path=$fn
        
            output_path_cutfn=${output_path_final%/*}
        
        
            echo "----------------------------------------"
            echo "input:" $input_path
            echo "output:" $output_path_final
            #echo $output_path_cutfn
        
            # check if target already exists and do not copy again if already exists
            if [[ ! -f "$output_path_final" ]]; then
                mkdir -p $output_path_cutfn
                # copy, but to prelim file name
                cp $input_path $output_path_prelim
                # rename to final name
                mv $output_path_prelim $output_path_final
            else
                echo "file already exists!"    
            fi
        else
            echo "$fn not of right type"
        fi
        
    done
    
done


exit 0  

