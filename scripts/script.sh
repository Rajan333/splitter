#!/bin/bash
##__AUTHOR: RAJAN MIDDHA__##

INPUT_FILE_LOCATION="$(pwd)"
OUTPUT_FILE_LOCATION="$(pwd)/output_files"
INPUT_FILE="sample.mkv"
OUTPUT_FILE="out.mkv"

OUTPUT_FILE_NAME="${OUTPUT_FILE%.*}"
OUTPUT_FILE_EXTENSION="${OUTPUT_FILE##*.}"

mkdir -p "$OUTPUT_FILE_LOCATION"

split_with_time()
	{
		echo "Splitting Video with respect to time"
		SEGMENT_DURATION=""

		DURATION=$(ffprobe -i ${FILENAME} 2>&1 | grep Duration | awk '{print $2}' | tr -d ',')
		echo ${DURATION}
		DURATION_TIMESTAMP=$(echo ${DURATION} | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
		echo ${DURATION_TIMESTAMP}

		ffmpeg -i ${FILENAME} -c copy -map 0 -segment_time ${SEGMENT_DURATION} -f segment sample%03d.mkv
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
	
