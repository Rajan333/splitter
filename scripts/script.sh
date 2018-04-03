#!/bin/bash
##__AUTHOR: RAJAN MIDDHA__##

INPUT_FILE_LOCATION="/Users/rajan/ns/sample"
OUTPUT_FILE_LOCATION="$(pwd)/output_files"
INPUT_FILE="sample.mp4"
OUTPUT_FILE="out.mkv"

OUTPUT_FILE_NAME="${INPUT_FILE%.*}"
OUTPUT_FILE_EXTENSION="${INPUT_FILE##*.}"

mkdir -p "$OUTPUT_FILE_LOCATION"

split_with_time()
	{
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
	
