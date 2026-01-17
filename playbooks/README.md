# Video Splitter Ansible Playbook

This Ansible playbook is a conversion of the original `splitter.sh` bash script. It uses **ffmpeg** to split videos either by time duration or file size.

## Prerequisites

- Ansible 2.9 or higher
- ffmpeg installed on the target system (or sudo access to install it)
- Python 3.x

## Usage

### Basic Usage (with default values)

```bash
ansible-playbook playbooks/splitter.yml
```

This will use default values:
- `split_type`: time
- `segment_value`: 10 (seconds for time split, MB for size split)
- `input_file_location`: /tmp/videos
- `input_file`: sample.mp4
- `output_file_location`: ./output_files

### Split by Time Duration

```bash
ansible-playbook playbooks/splitter.yml \
  --extra-vars "split_type=time segment_value=30 input_file_location=/path/to/videos input_file=video.mp4 output_file_location=/path/to/output"
```

**Parameters:**
- `split_type=time` - Split by time duration
- `segment_value=30` - Split into 30-second segments
- `input_file_location` - Directory containing the input video
- `input_file` - Name of the video file to split
- `output_file_location` - Directory where split files will be saved

### Split by File Size

```bash
ansible-playbook playbooks/splitter.yml \
  --extra-vars "split_type=size segment_value=50 input_file_location=/path/to/videos input_file=video.mp4 output_file_location=/path/to/output"
```

**Parameters:**
- `split_type=size` - Split by file size
- `segment_value=50` - Split into 50MB chunks
- `input_file_location` - Directory containing the input video
- `input_file` - Name of the video file to split
- `output_file_location` - Directory where split files will be saved

## Variables

All variables can be overridden using `--extra-vars`:

| Variable | Default | Description |
|----------|---------|-------------|
| `split_type` | `time` | Split method: `time` or `size` |
| `segment_value` | `10` | Segment duration (seconds) or size (MB) |
| `input_file_location` | `/tmp/videos` | Directory containing input video |
| `input_file` | `sample.mp4` | Input video filename |
| `output_file_location` | `./output_files` | Output directory for split files |

## Examples

### Example 1: Split a 1-hour video into 5-minute segments

```bash
ansible-playbook playbooks/splitter.yml \
  --extra-vars "split_type=time segment_value=300 input_file_location=/home/user/videos input_file=movie.mp4"
```

### Example 2: Split a large video into 100MB chunks

```bash
ansible-playbook playbooks/splitter.yml \
  --extra-vars "split_type=size segment_value=100 input_file_location=/home/user/videos input_file=large_video.mkv"
```

### Example 3: Using a variables file

Create a file `vars.yml`:
```yaml
split_type: time
segment_value: 60
input_file_location: /home/user/videos
input_file: presentation.mp4
output_file_location: /home/user/output
```

Run the playbook:
```bash
ansible-playbook playbooks/splitter.yml --extra-vars "@vars.yml"
```

## Features

- **Validation**: Checks if input file exists before processing
- **Automatic directory creation**: Creates output directory if it doesn't exist
- **Progress tracking**: Displays splitting progress and created files
- **Error handling**: Validates parameters and provides clear error messages
- **Flexible configuration**: All parameters can be customized via command line

## Differences from Original Script

1. **No interactive mode**: Original script had an interactive menu - this playbook requires parameters
2. **Package installation**: Playbook can attempt to install ffmpeg if not present
3. **Better error handling**: Uses Ansible's built-in validation and error handling
4. **Declarative syntax**: More maintainable and readable than bash script
5. **Idempotent operations**: Can be run multiple times safely

## Notes

- The playbook runs on `localhost` by default
- For size-based splitting, a temporary bash script is created and executed due to the complex loop logic
- Output files are named with the pattern: `{original_name}{number}.{extension}`
- For time-based splitting: `video001.mp4`, `video002.mp4`, etc.
- For size-based splitting: `video1.mp4`, `video2.mp4`, etc.

## Troubleshooting

**Error: "ffmpeg not found"**
- Install ffmpeg: `sudo apt-get install ffmpeg` (Debian/Ubuntu) or `sudo yum install ffmpeg` (RHEL/CentOS)
- Or allow the playbook to install it by running with sudo: `ansible-playbook playbooks/splitter.yml --become --ask-become-pass`

**Error: "Input file does not exist"**
- Check that the path and filename are correct
- Ensure you have read permissions for the file

**Error: "Invalid split_type"**
- Ensure `split_type` is either `time` or `size`

## References

- [ffmpeg documentation](https://ffmpeg.org/ffmpeg.html)
- [Ansible documentation](https://docs.ansible.com/)
- Original script: `scripts/splitter.sh`
