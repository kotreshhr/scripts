#!/usr/bin/python

import os
import uuid
import stat
import struct
import random
import libcxattr

def umask():
    return os.umask(0)

def _fmt_mknod(l):
    return "!II%dsI%dsIII" % (37, l+1)

def _fmt_mkdir(l):
    return "!II%dsI%dsII" % (37, l+1)

def entry_pack_reg(gf, bn, mo, uid, gid):
    blen = len(bn)
    return struct.pack(_fmt_mknod(blen),
                       uid, gid, gf, mo, bn,
                       stat.S_IMODE(mo), 0, umask())

def entry_pack_mkdir(gf, bn, mo, uid, gid):
    blen = len(bn)
    return struct.pack(_fmt_mkdir(blen),
                       uid, gid, gf, mo, bn,
                       stat.S_IMODE(mo), umask())

Xattr = libcxattr.Xattr()

os.chdir('/mastermnt')

gfid1 = str(uuid.uuid1())
dname = 'dir-' + str(random.randint(0, 99999))
print('creating \'%s\' with GFID %s' % (dname, gfid1))

blob = entry_pack_mkdir(gfid1, dname, 16893, 0, 0)
Xattr.lsetxattr('.gfid/00000000-0000-0000-0000-000000000001', 'glusterfs.gfid.newfile', blob)

# gfid1 = '53178d14-7df0-11e3-ae3b-f0def1f0c938'

# gfid2 = str(uuid.uuid1())
# dname = 'subdir'
# print('creating \'%s\' with GFID %s under %s' % (dname, gfid2, gfid1))

# blob = entry_pack_mkdir(gfid2, dname, 16893, 0, 0)
# Xattr.lsetxattr('.gfid/' + gfid1, 'glusterfs.gfid.newfile', blob)
