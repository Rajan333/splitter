#!/bin/bash
##__AUTHOR: RAJAN MIDDHA__##

read -p "Enter Input Folder:" INPUT_FOLDER
read -p "Enter Output Folder:" OUTPUT_FOLDER
read -p "Enter Output Filename:" OUTPUT_FILE_NAME

CURRENT_PATH=$(pwd)

merge_video_segments(){
	echo "Creating file list..."
	echo " " > $CURRENT_PATH/merge_list.txt

	for segment in `ls ${INPUT_FOLDER}`
	do
		echo "file '${INPUT_FOLDER}/${segment}'" >> ${CURRENT_PATH}/merge_list.txt
	done

	echo "Merging Segments..."
	ffmpeg -f concat -safe 0 -i ${CURRENT_PATH}/merge_list.txt -c copy ${OUTPUT_FOLDER}/${OUTPUT_FILE_NAME}
}

merge_video_segments
