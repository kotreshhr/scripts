import sys
import os
import xattr

mnt_path = os.path.abspath(sys.argv[1])
dir_path = sys.argv[2]

result = dir_path.split("/") 
print result
entry = "" 
for dir1 in result:
    entry = entry + "/" + dir1
    path = mnt_path + entry
    gfid = xattr.getxattr(path, "glusterfs.gfid.string")
    print ("%s : %s" % (dir1, gfid))
