#!/bin/bash
##__AUTHOR: RAJAN MIDDHA__##

INPUT_FILE_LOCATION="/Users/rajan/ns/sample"
OUTPUT_FILE_LOCATION="$(pwd)/output_files"
INPUT_FILE="sample.mp4"
OUTPUT_FILE="out.mkv"

OUTPUT_FILE_NAME="${INPUT_FILE%.*}"
OUTPUT_FILE_EXTENSION="${INPUT_FILE##*.}"

mkdir -p "$OUTPUT_FILE_LOCATION"

split_with_time(){
		echo "Splitting Video with respect to time..."
		
		SEGMENT_DURATION="10"

		DURATION=$(ffprobe -i ${INPUT_FILE_LOCATION}/${INPUT_FILE} 2>&1 | grep Duration | awk '{print $2}' | tr -d ',')
		echo ${DURATION}
		DURATION_TIMESTAMP=$(echo ${DURATION} | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
		echo ${DURATION_TIMESTAMP}

		ffmpeg -i ${INPUT_FILE_LOCATION}/${INPUT_FILE} -c copy -map 0 -segment_time ${SEGMENT_DURATION} -reset_timestamps 1 -f segment ${OUTPUT_FILE_LOCATION}/${OUTPUT_FILE_NAME}%03d.${OUTPUT_FILE_EXTENSION}
}

split_with_size(){
		echo "Splitting Video with respect to size"

		# size in MB
		VIDEO_SEGMENT_SIZE="10"

		OUTPUT_DIR="/home/ubuntu/ammo-exp/test-chunks"
		INPUT_VIDEO="/home/ubuntu/ammo-exp/vid.mp4"

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
	
