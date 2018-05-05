#!/bin/bash
##__AUTHOR: RAJAN MIDDHA__##

INPUT_FOLDER="/Users/rajan/ns/splitter/scripts/output_files"
OUTPUT_FOLDER="/Users/rajan/ns/splitter/scripts/output_files"
OUTPUT_FILE_NAME="output.mp4"
CURRENT_PATH=$(pwd)

merge_video_segments(){
	echo "Creating file list..."
	touch $CURRENT_PATH/merge_list.txt
	
	for segment in `ls ${INPUT_FOLDER}`
	do
		echo "file '${INPUT_FOLDER}/${segment}'" >> ${CURRENT_PATH}/merge_list.txt
	done

	echo "Merging Segments..."
	ffmpeg -f concat -safe 0 -i ${CURRENT_PATH}/merge_list.txt -c copy ${OUTPUT_FOLDER}/${OUTPUT_FILE_NAME}
}

merge_video_segments
