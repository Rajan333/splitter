#!/bin/bash
##__AUTHOR: RAJAN MIDDHA__##

CURRENT_PATH=$(pwd)

merge_video_segments(){
	echo "Creating file list..."
	echo " " > $CURRENT_PATH/merge_list.txt

	for segment in `ls ${INPUT_FOLDER}`
	do
		echo "file '${INPUT_FOLDER}/${segment}'" >> ${CURRENT_PATH}/merge_list.txt
	done

	echo "Merging Segments..."
	ffmpeg -f concat -safe 0 -i ${CURRENT_PATH}/merge_list.txt -c copy ${OUTPUT_FOLDER}/${OUTPUT_FILENAME}
}


ARGUMENTS="$#"
if [ "$ARGUMENTS" == "0" ]; then
	INPUT_FOLDER="/Users/rajan/ns/splitter/scripts/output_files"
	OUTPUT_FOLDER="/Users/rajan/ns/splitter/scripts/output_files"
	OUTPUT_FILENAME="out.mp4"
	merge_video_segments

elif [ "$ARGUMENTS" == "6" ]; then
	while [ "$ARGUMENTS" -gt 0 ]
	do
		ARGUMENTS=$(($ARGUMENTS - 2))
		key="$1"
		echo $key
		case $key in
		    -i | --input)
				INPUT_FOLDER=$2
		    	shift 2
		    	;;

		    -o | --output)
				OUTPUT_FOLDER=$2
				shift 2
				;;

		    -f | --file)
				OUTPUT_FILENAME=$2
				shift 2
				;;

		    *)  echo "$1"
				shift
				;;
		esac
	done

	echo INPUT_FOLDER = "${INPUT_FOLDER}"
	echo OUTPUT_FOLDER = "${OUTPUT_FOLDER}"
	echo OUTPUT_FILENAME = "${OUTPUT_FILENAME}"

	mkdir -p ${OUTPUT_FOLDER}
	merge_video_segments

else
	echo "Wrong Input. Exiting now."
	exit 77
fi

