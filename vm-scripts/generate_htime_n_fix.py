import os
import glob
import sys
import xattr
import shutil

htime_file_org = sys.argv[1]
if not "HTIME" in htime_file_org:
    print "Not a valid htime file"
    sys.exit(1)

data = []
pwd = os.getcwd()
cl_path = sys.argv[2]
buf_rollover_time = 20 #rollover time + buffer time
act_rollover_time = 15
os.chdir(cl_path)
files = glob.glob("CHANGELOG.[0-9]*")
files.sort()

htime_file=os.path.join(pwd, "HTIME.GEN")
with open(htime_file, "w+") as f:
    prev_changelog = None
    for file in files:
        cur_changelog = file
        if prev_changelog is None:
            prev_changelog = file
            f.write(os.path.join(cl_path, file))
            f.write("\x00")
            continue

        cur_tstamp = int(cur_changelog.split(".")[-1])
        pre_tstamp = int(prev_changelog.split(".")[-1])
        if ((cur_tstamp - pre_tstamp) <= buf_rollover_time):
            f.write(os.path.join(cl_path, file))
            f.write("\x00")
        else:
            while ((cur_tstamp - pre_tstamp) > buf_rollover_time):
                ext = pre_tstamp + act_rollover_time
                name = "changelog." + str(ext)
                f.write(os.path.join(cl_path, name))
                f.write("\x00")
                pre_tstamp = ext

            f.write(os.path.join(cl_path, file))
            f.write("\x00")

        prev_changelog = cur_changelog
    os.fsync(f.fileno())

with open(htime_file) as f:
    data = f.read().strip("\x00").split("\x00")

value = "%s:%s" % (data[-1].split(".")[-1], len(data))
xattr.set(htime_file, "trusted.glusterfs.htime", value)

with open(htime_file) as f:
    os.fsync(f.fileno())

print "Current Value: %s" % value

os.chdir(pwd)

new_htime_file_org = htime_file_org + ".org"
print "Renaming original %s to %s" % (htime_file_org, new_htime_file_org)
shutil.move(htime_file_org, new_htime_file_org)

print "Fixing HTIME, renaming %s to %s" % (htime_file, htime_file_org)
shutil.move(htime_file, htime_file_org)
