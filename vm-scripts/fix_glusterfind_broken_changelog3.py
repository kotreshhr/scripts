import os
import sys
import xattr
import shutil
try:
    import urllib.parse as urllib
except ImportError:
    import urllib

brick_path = sys.argv[1]
session_name = sys.argv[2]
vol_name = sys.argv[3]

htime_dir = os.path.join(brick_path, ".glusterfs", "changelogs", "htime")
htime_bname = xattr.get(htime_dir, "trusted.glusterfs.current_htime")

htime_fpath = os.path.join(htime_dir, htime_bname)

with open(htime_fpath) as f:
    data = f.read().strip("\x00").split("\x00")

first_tstamp = data[0].split(".")[-1]

print "Updating glusterfind status file with time stamp %s" % first_tstamp
gfind_session_dir = "/var/lib/glusterd/glusterfind/"
gfind_status_file = os.path.join(gfind_session_dir, session_name, vol_name, "status")
gfind_status_file_org = os.path.join(gfind_session_dir, session_name, vol_name, "status.org")

if os.path.exists(gfind_status_file):
    os.rename(gfind_status_file, gfind_status_file_org)

    with open(gfind_status_file, 'w') as f:
        f.truncate(0)
        f.flush()
        f.write(first_tstamp)
        f.flush()

    print "Successfully updated glusterfind status file with time stamp %s" % first_tstamp

brick_status_path = os.path.join(gfind_session_dir, session_name, vol_name, "%s.status" % urllib.quote_plus(brick_path).rstrip("%2F"))
print "Updating brick status file: %s with time stamp %s" % (brick_status_path, first_tstamp)

with open(brick_status_path, 'w') as f:
    f.truncate(0)
    f.flush()
    f.write(first_tstamp)
    f.flush()

print "Successfully updated brick status file with time stamp %s" % first_tstamp

print "Backing up older unwanted HTIME files in .backup"
backupdir = os.path.join(htime_dir, ".backup")
if not os.path.exists(backupdir):
    os.makedirs(backupdir)
    
items = os.listdir(htime_dir)
for name in items:
    if not name == htime_bname:
        if not name == ".backup":
            h_name = os.path.join(htime_dir, name)
            print "Move %s to %s" % (h_name, backupdir) 
            shutil.move(h_name, backupdir)
