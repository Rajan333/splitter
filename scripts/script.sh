#!/bin/bash

split_with_time()
	{
		echo "Splitting Video with respect to time"
}

split_with_size(){
		echo "Splitting Video with respect to size"
}
read input
case "$input" in
	"1") echo "Split Video Chunks according to Time"
		split_with_time ;;

	"2") echo "Split Video Chunks according to Size"
		split_with_size ;;

	*) 
		echo "Invalid Input. Exiting now"
		exit 43 ;;
esac
	
