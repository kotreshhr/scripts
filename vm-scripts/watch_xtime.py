import xattr
import struct
import sys
from datetime import datetime

DEFAULT_STATUS = "-"


def human_time(ts):
    try:
        return datetime.fromtimestamp(float(ts)).strftime("%Y-%m-%d %H:%M:%S")
    except ValueError:
        return DEFAULT_STATUS


def find_stime(brick_path):
    values = []
    xattrs_list = xattr.list(brick_path)
    for x in xattrs_list:
        if x.endswith(".xtime"):
            val = struct.unpack("!II", xattr.get(brick_path, x))
            uuids_data = x.split(".")
            master_uuid = uuids_data[2]
            values.append([master_uuid, human_time(val[0])])

    if values:
        print ("MASTER UUID                              "
               "LAST MODIFIED")

        print ("-----------------------------------------"
               "----------------------")

    for v in values:
        print "{0}     {1}".format(v[0], v[1])


if __name__ == "__main__":
    find_stime(sys.argv[1])
