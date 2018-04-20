#!/bin/bash
##__AUTHOR: RAJAN MIDDHA__##

## How to run
## bash video_splitter.sh
## bash script.sh --splitBy time --segment 10 --input /Users/rajan/ns/sample --file sample.mp4 --out output_files

split_with_time(){
		echo "Splitting Video with respect to time..."

		echo "value:: $SEGMENT_VALUE"
		SEGMENT_DURATION="$SEGMENT_VALUE"

		DURATION=$(ffprobe -i ${INPUT_FILE_LOCATION}/${INPUT_FILE} 2>&1 | grep Duration | awk '{print $2}' | tr -d ',')
		echo ${DURATION}
		DURATION_TIMESTAMP=$(echo ${DURATION} | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
		echo ${DURATION_TIMESTAMP}

		ffmpeg -i ${INPUT_FILE_LOCATION}/${INPUT_FILE} -c copy -map 0 -segment_time ${SEGMENT_DURATION} -reset_timestamps 1 -f segment ${OUTPUT_FILE_LOCATION}/${OUTPUT_FILE_NAME}%03d.${OUTPUT_FILE_EXTENSION}
}

split_with_size(){
		echo "Splitting Video with respect to size"

		# size in MB
		VIDEO_SEGMENT_SIZE="$SEGMENT_VALUE"

		VIDEO_DURATION=`ffprobe ${INPUT_FILE_LOCATION}/${INPUT_FILE} -show_format -v quiet  | grep "duration" | cut -d "=" -f2`
		echo "video duration : $VIDEO_DURATION"

		START_TIME=0
		LAST_DURATION=0
		CHUNK_NUMBER=0

		# divide video in chunks based on segment size
		while true;
		do
			CHUNK_NUMBER=$((CHUNK_NUMBER+1))
			echo "Preparing chunk # ${CHUNK_NUMBER}"
			ffmpeg -loglevel panic  -ss ${START_TIME}  -i ${INPUT_FILE_LOCATION}/${INPUT_FILE}  -vcodec copy -acodec copy  -fs ${VIDEO_SEGMENT_SIZE}Mi ${OUTPUT_FILE_LOCATION}/${OUTPUT_FILE_NAME}${CHUNK_NUMBER}.${OUTPUT_FILE_EXTENSION}
			LAST_VIDEO_DURATION=`ffprobe ${OUTPUT_FILE_LOCATION}/${OUTPUT_FILE_NAME}${CHUNK_NUMBER}.${OUTPUT_FILE_EXTENSION}  -show_format -v quiet  | grep "duration" | cut -d "=" -f2`
			LAST_CHUNK_SIZE=`du -k ${OUTPUT_FILE_LOCATION}/${OUTPUT_FILE_NAME}${CHUNK_NUMBER}.${OUTPUT_FILE_EXTENSION}  | cut -f1`
			OFFSET_DURATION=`echo $START_TIME + $LAST_VIDEO_DURATION | bc`
			echo "offset duration : $OFFSET_DURATION"
			if [ $(echo "$OFFSET_DURATION  >= $VIDEO_DURATION" | bc) -ne 0 ] ; then
				echo "redundant chunk .... "
				rm -rf ${OUTPUT_FILE_LOCATION}/${OUTPUT_FILE_NAME}${CHUNK_NUMBER}.${OUTPUT_FILE_EXTENSION}
				break
			else
				START_TIME=`echo $START_TIME + $LAST_VIDEO_DURATION | bc`
			fi		
		done

		echo "Video succesfully chunked"


}

switch_case(){
	
	mkdir -p "$OUTPUT_FILE_LOCATION"
	OUTPUT_FILE_NAME="${INPUT_FILE%.*}"
	OUTPUT_FILE_EXTENSION="${INPUT_FILE##*.}"

	echo " "
	echo "1) Split Video Chunks according to Time"
	echo "2) Split Video Chunks according to Size"
	echo " "

	read -p "Enter Input: " input
	echo " "

	case "$input" in
		1) split_with_time ;;

		2) split_with_size ;;

		*) echo "Invalid Input. Exiting now"
		   exit 43 ;;
	esac
}


ARGUMENTS="$#"
echo "lenght:>>>> ${#ARGUMENTS}"
if [ "$ARGUMENTS" == "0" ]; then
	INPUT_FILE_LOCATION="/Users/rajan/ns/sample"
	OUTPUT_FILE_LOCATION="$(pwd)/output_files"
	INPUT_FILE="sample.mp4"
	OUTPUT_FILE="out.mkv"
	SEGMENT_VALUE="10"

	switch_case
	
elif [ "$ARGUMENTS" == "10" ]; then
	while [ "$ARGUMENTS" -gt 0 ]
	do
		ARGUMENTS=$(($ARGUMENTS - 2))
		key="$1"
		echo $key
		case $key in
		    --splitBy) 
				SPLIT_TYPE=$2
		    	shift 2
		    	;;

		    --segment) 
				SEGMENT_VALUE=$2 
				shift 2
				;;

		    -i | --input) 
				INPUT_FILE_LOCATION=$2 
				shift 2
				;;

		    -o | --output) 
				OUTPUT_FILE_LOCATION=$2 
				shift 2
				;;

		    --file) 
				INPUT_FILE=$2 
				shift 2
				;;

		    *)  echo "$1"
				shift 
				;;
		esac
	done

		echo SPLIT_TYPE = "${SPLIT_TYPE}"
		echo SEGMENT_VALUE = "${SEGMENT_VALUE}"
		echo INPUT_FILE_LOCATION = "${INPUT_FILE_LOCATION}"
		echo OUTPUT_FILE_LOCATION = "${OUTPUT_FILE_LOCATION}"
		echo INPUT_FILE = "${INPUT_FILE}"

		mkdir -p "$OUTPUT_FILE_LOCATION"
		OUTPUT_FILE_NAME="${INPUT_FILE%.*}"
		OUTPUT_FILE_EXTENSION="${INPUT_FILE##*.}"

		if [ "$SPLIT_TYPE" == "time" ]; then
			split_with_time

		elif [ "$SPLIT_TYPE" == "size" ]; then
			split_with_size
		
		else 
			echo "Wrong Parameter Passed."
			exit 50
		fi
	
	

else
	echo "Wrong Input. Exiting now."
	exit 77
fi











































