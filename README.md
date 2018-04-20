# Video Splitter
----
The script uses **ffmpeg** library to split a video. Two ways of splitting are supported:
> Split by time\
> Split by size

Script accepts the following parameters :
*  --splitBy: <time/size>
*  --segment: <value of splitBy parameter> (sec/mb)
*    -i | --input: <input file location (dir)>
*    -f | --file: <file_name>
*    -o |--output: <Output file location (dir)>

#### Split by time
```sh
    $ bash splitter.sh --splitBy time --segment <time_duration> --i <input_file_path> --file <file_name> -o <output_file_path>
```
####  Split by size 
```sh
    $ bash splitter.sh --splitBy size --segment <time_duration> --i <input_file_path> --file <file_name> -o <output_file_path>
```