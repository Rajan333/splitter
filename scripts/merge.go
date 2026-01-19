package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
)

func main() {
	// Check if ffmpeg is available
	cmd := "/usr/local/bin/ffmpeg"
	ffmpegCmd := exec.Command(cmd)
	output, err := ffmpegCmd.CombinedOutput()
	if err != nil {
		// ffmpeg returns non-zero exit when run without arguments, but that's expected
		// We just want to verify it exists
	}
	_ = output

	// Input path - hardcoded as in the original Python script
	inputPath := "/Users/rajan/ns/splitter/scripts/output_files"

	// Create merge list file
	file, err := os.Create("sample_merge.txt")
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error creating merge list file: %v\n", err)
		os.Exit(1)
	}
	defer file.Close()

	// Read directory contents
	entries, err := os.ReadDir(inputPath)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error reading directory: %v\n", err)
		os.Exit(1)
	}

	// Write file paths to merge list
	for _, entry := range entries {
		if !entry.IsDir() {
			line := fmt.Sprintf("file '%s'\n", filepath.Join(inputPath, entry.Name()))
			_, err := file.WriteString(line)
			if err != nil {
				fmt.Fprintf(os.Stderr, "Error writing to merge list: %v\n", err)
				os.Exit(1)
			}
		}
	}

	// Prepare ffmpeg merge command
	// Note: The original Python script prepares the command but doesn't execute it (commented out)
	options := " -f concat -safe 0 -i "
	command := cmd + options + "sample_merge.txt " + "rajan.mp4"
	fmt.Println(command)

	// To execute the command, uncomment the following lines:
	// mergeCmd := exec.Command(cmd, "-f", "concat", "-safe", "0", "-i", "sample_merge.txt", "rajan.mp4")
	// if err := mergeCmd.Run(); err != nil {
	//     fmt.Fprintf(os.Stderr, "Error running ffmpeg: %v\n", err)
	//     os.Exit(1)
	// }
}
