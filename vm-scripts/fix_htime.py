import sys

import xattr



htime_file = sys.argv[1]



data = []



with open(htime_file) as f:

    data = f.read().strip("\x00").split("\x00")



value = "%s:%s" % (data[-1].split(".")[-1], len(data))



prev_value = ""

try:

    prev_value = xattr.get(htime_file, "trusted.glusterfs.htime")

except (IOError, OSError):

    pass



xattr.set(htime_file, "trusted.glusterfs.htime", value)



print "Prev Value   : %s" % prev_value

print "Current Value: %s" % value
