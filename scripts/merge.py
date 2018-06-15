import sys
import os
import subprocess

cmd = '/usr/local/bin/ffmpeg'

ffmpeg_p = subprocess.Popen(cmd, stdin = subprocess.PIPE,
							stdout = subprocess.PIPE,
							stderr = subprocess.PIPE)
output = ffmpeg_p.communicate()
#print(output)

_input_path = '/Users/rajan/ns/splitter/scripts/output_files'
#lst = os.listdir(_input_path)

file = open('sample_merge.txt','w+')
for chunk in os.listdir(_input_path):
	line = 'file'+' '+ "'"+_input_path+'/'+chunk+"'"'\n'
	file.write(line)

file.close()
options = ' -f concat -safe 0 -i '
comm = cmd+options+'sample_merge.txt '+'rajan.mp4'
#print comm
#os.system(comm)

