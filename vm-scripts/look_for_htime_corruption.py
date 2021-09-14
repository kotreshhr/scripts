import sys
import xattr

htime_file = sys.argv[1]
data = []

with open(htime_file) as f:
    data = f.read().strip("\x00").split("\x00")

htime_path_len = len(data[0])
print "htime_path_len:%s" % htime_path_len

for d in data:
    if not len(d) == htime_path_len:
        print "Length not matching"
        print d  
