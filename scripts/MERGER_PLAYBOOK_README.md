# Video Merger Ansible Playbook

This Ansible playbook is a conversion of the `merger.sh` bash script. It merges video segments from an input folder into a single output video file using ffmpeg.

## Prerequisites

1. **Ansible**: Install Ansible on your system
   ```bash
   # On macOS
   brew install ansible

   # On Ubuntu/Debian
   sudo apt update
   sudo apt install ansible

   # Using pip
   pip install ansible
   ```

2. **ffmpeg**: The playbook requires ffmpeg to be installed
   ```bash
   # On macOS
   brew install ffmpeg

   # On Ubuntu/Debian
   sudo apt install ffmpeg
   ```

## Usage

### Basic Usage (with default values)

Run the playbook with default values:
```bash
ansible-playbook scripts/merger.yml
```

Default values:
- Input folder: `/Users/rajan/ns/splitter/scripts/output_files`
- Output folder: `/Users/rajan/ns/splitter/scripts/output_files`
- Output filename: `out.mp4`

### Custom Parameters

Override default values using `--extra-vars`:

```bash
ansible-playbook scripts/merger.yml \
  --extra-vars "input_folder=/path/to/input \
                output_folder=/path/to/output \
                output_filename=merged_video.mp4"
```

### Examples

1. **Merge segments from a specific folder**:
   ```bash
   ansible-playbook scripts/merger.yml \
     --extra-vars "input_folder=/home/user/videos/segments"
   ```

2. **Specify custom output location and filename**:
   ```bash
   ansible-playbook scripts/merger.yml \
     --extra-vars "input_folder=/home/user/videos/segments \
                   output_folder=/home/user/videos/merged \
                   output_filename=final_video.mp4"
   ```

3. **Using a variables file**:
   Create a file `vars.yml`:
   ```yaml
   input_folder: "/home/user/videos/segments"
   output_folder: "/home/user/videos/output"
   output_filename: "merged_output.mp4"
   ```

   Then run:
   ```bash
   ansible-playbook scripts/merger.yml --extra-vars "@vars.yml"
   ```

## What the Playbook Does

1. Creates the output directory if it doesn't exist
2. Checks if the input folder exists and contains files
3. Finds all video segments in the input folder
4. Sorts segments by modification time (oldest first)
5. Creates a temporary merge list file for ffmpeg
6. Merges all segments using ffmpeg with the concat demuxer
7. Cleans up the temporary merge list file

## Parameters

| Parameter | Description | Default Value |
|-----------|-------------|---------------|
| `input_folder` | Directory containing video segments to merge | `/Users/rajan/ns/splitter/scripts/output_files` |
| `output_folder` | Directory where merged video will be saved | `/Users/rajan/ns/splitter/scripts/output_files` |
| `output_filename` | Name of the output merged video file | `out.mp4` |
| `merge_list_file` | Temporary file for ffmpeg concat list | `merge_list.txt` |

## Comparison with Original Bash Script

### Bash Script (`merger.sh`)
```bash
./merger.sh -i /path/to/input -o /path/to/output -f output.mp4
```

### Ansible Playbook (equivalent)
```bash
ansible-playbook scripts/merger.yml \
  --extra-vars "input_folder=/path/to/input \
                output_folder=/path/to/output \
                output_filename=output.mp4"
```

## Advantages of Ansible Playbook

1. **Idempotent**: Can be run multiple times safely
2. **Better error handling**: Checks for directory existence and file availability
3. **Verbose output**: Shows detailed information about each step
4. **Cross-platform**: Works on any system with Ansible installed
5. **Easier to extend**: Can be integrated into larger automation workflows
6. **Better documentation**: Self-documenting with task names
7. **Reusable**: Can be included in other playbooks or roles

## Troubleshooting

### Error: "Input folder does not exist"
- Verify the input folder path is correct
- Ensure you have read permissions for the folder

### Error: "No video segments found"
- Check that the input folder contains video files
- Verify file permissions

### Error: "ffmpeg command failed"
- Ensure ffmpeg is installed and in your PATH
- Check that video segments are in a compatible format
- Verify you have write permissions for the output folder

## Author

Rajan Middha
