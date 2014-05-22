PREFIX=$2;
NEWSIZE=$1;
for i in ${*:3};
do
    NEWNAME=$PREFIX$i;
    echo "resizing $i to $NEWSIZE with prefix $PREFIX to $NEWNAME";
    if [[ "$i" = $PREFIX* ]];
        then
            echo "this is already a resized one (prefix already present), skipping..."
        else
            if [ -f "$NEWNAME" ]
                then
	            echo "$NEWNAME already exists, skipping..."
                else
                    convert -resize $NEWSIZE $i $NEWNAME;
            fi
    fi
done
