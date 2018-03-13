#!/bin/bash

split_with_time()
	{
		echo "Splitting Video with respect to time"
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
	
