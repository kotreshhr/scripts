import os
import glob
import sys

pwd = os.getcwd()
cl_path = sys.argv[1]
os.chdir(cl_path)
files = glob.glob("CHANGELOG.[0-9]*")
files.sort()

htime_file=os.path.join(pwd, "HTIME.GEN")
with open(htime_file, "w+") as f:
    for file in files:
        f.write(os.path.join(cl_path, file))
        f.write("\x00")
            
    os.fsync(f)

os.chdir(pwd)
