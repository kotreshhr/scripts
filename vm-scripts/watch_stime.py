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
        if x.endswith(".stime"):
            val = struct.unpack("!II", xattr.get(brick_path, x))
            uuids_data = x.split(".")
            master_uuid = uuids_data[2]
            slave_uuid = uuids_data[3]
            values.append([master_uuid, slave_uuid, human_time(val[0]), val[0]])

    if values:
        print ("MASTER UUID                              "
               "SLAVE UUID                               "
               "LAST SYNCED (Human readable)       "
               "LAST SYNCED (Unix Epoch)")

        print ("-----------------------------------------"
               "-----------------------------------------"
               "-----------------------------------------"
               "------------------------------")

    for v in values:
        print "{0}     {1}     {2}                    {3}".format(v[0], v[1], v[2], v[3])


if __name__ == "__main__":
    find_stime(sys.argv[1])
