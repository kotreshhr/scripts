#!/bin/env python
import ctypes
import sys
 
glusterfs = ctypes.cdll.LoadLibrary("/usr/local/lib/libglusterfs.so.0")
 
def gf_dm_hashfn(filename):
    return ctypes.c_uint32(glusterfs.gf_dm_hashfn(
        filename,
        len(filename)))
 
if __name__ == "__main__":
    print hex(gf_dm_hashfn(sys.argv[1]).value)
