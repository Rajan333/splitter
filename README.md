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

## How to run
### If No Paramater is passed
```sh
    $ bash splitter.sh
```

### If Parameters are passed
#### Split by time
```sh
    $ bash splitter.sh --splitBy time --segment <time_duration> --input <input_file_path> --file <file_name> -o <output_file_path>
```
####  Split by size 
```sh
    $ bash splitter.sh --splitBy size --segment <time_duration> --input <input_file_path> --file <file_name> -o <output_file_path>
```


# Video Merger
----
The script uses **ffmpeg** library to merge muliple video chunks having same extension.

Script accepts the following parameters :
*    -i | --input: <input file location (dir)>
*    -o |--output: <Output file location (dir)>
*    -f | --file: <file_name>

## How to run
### If No Paramater is passed
```sh
    $ bash merger.sh
```


### If Parameters are passed
```sh
    $ bash merger.sh  --input <input_folder_path> --output <output_folder_path> --file <output_file_name>
```



##### To know more about ffmpeg, Refer to the following pages.
* [ffmpeg doc-1](https://ffmpeg.org/ffmpeg.html)
* [ffmpeg doc-2](https://www.ffmpeg.org/documentation.html)