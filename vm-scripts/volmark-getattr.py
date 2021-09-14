#!/usr/bin/python

import os
import sys
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


os.chdir('/bricks/brick0/b0')
xattr_list = Xattr.llistxattr_buf('.')
for ele in xattr_list:
    print ('hrk: native_volume_infos: %s' % ele)

#fmt_string = "!" + "B" * 19 + "III"
#xattr = "trusted.glusterfs.volume-mark.f37e6bbcd09848f1bed0eb8742aa2146"
#buf = Xattr.lgetxattr('.', xattr, struct.calcsize(fmt_string))
#print ('hrk: buf: %s' % buf)
#vm = struct.unpack(fmt_string, buf)
#print ('hrk: vm: %s' % str(vm))

'''
os.chdir('/mastermnt')
gfid1 = str(uuid.uuid1())
fname = 'file-0'
fname1 = 'file-1'
blob = entry_pack_reg(gfid1, fname, 33152, 0, 0)
print("Creating \'%s\' : \'%s\' ", (fname), (gfid1))
Xattr.lsetxattr('.gfid/00000000-0000-0000-0000-000000000001', 'glusterfs.gfid.newfile', blob)
blob1 = entry_pack_reg(gfid1, fname1, 33152, 0, 0)
print("Creating \'%s\' : \'%s\' ", (fname1), (gfid1))
Xattr.lsetxattr('.gfid/00000000-0000-0000-0000-000000000001', 'glusterfs.gfid.newfile', blob1)
'''

'''
j = 0
while j < 10000:
    i=0
    while i < 1:
        gfid1 = str(uuid.uuid1())
        gfid2 = str(uuid.uuid1())
        gfid3 = str(uuid.uuid1())
        #dname = 'dir-' + str(i)
        dname = 'dir-0'
        dname1 = 'dir-1'
        dname2 = 'dir-2'

        #blob = entry_pack_reg(gfid1, fname, 33152, 0, 0)
        blob1 = entry_pack_mkdir(gfid1, dname, 16893, 0, 0)
        blob2 = entry_pack_mkdir(gfid2, dname1, 16893, 0, 0)
        blob3 = entry_pack_mkdir(gfid3, dname2, 16893, 0, 0)
        print("Creating \'%s\' : \'%s\' ", (dname), (gfid1))
        Xattr.lsetxattr('.gfid/00000000-0000-0000-0000-000000000001', 'glusterfs.gfid.newfile', blob1)
        print("Creating \'%s\' : \'%s\' ", (dname1), (gfid2))
        Xattr.lsetxattr('.gfid/' + gfid1, 'glusterfs.gfid.newfile', blob2)
        print("Creating \'%s\' : \'%s\' ", (dname2), (gfid3))
        Xattr.lsetxattr('.gfid/' + gfid2, 'glusterfs.gfid.newfile', blob3)
        #os.rename ('.gfid/00000000-0000-0000-0000-000000000001/' + fname, '.gfid/5e7ee3b8-1e3c-4b56-be13-06f79fa8167c/rn-' + fname)
        print("Deleting \'%s\' : \'%s\' ", (dname), (gfid1))
        os.rmdir ('.gfid/' + gfid2 + '/dir-2')
        print("Deleting \'%s\' : \'%s\' ", (dname1), (gfid2))
        os.rmdir ('.gfid/' + gfid1 + '/dir-1')
        print("Deleting \'%s\' : \'%s\' ", (dname2), (gfid3))
        os.rmdir ('.gfid/00000000-0000-0000-0000-000000000001/dir-0' )
        i = i + 1
    j = j + 1
    print j
'''
# gfid1 = '53178d14-7df0-11e3-ae3b-f0def1f0c938'

# gfid2 = str(uuid.uuid1())
# dname = 'subdir'
# print('creating \'%s\' with GFID %s under %s' % (dname, gfid2, gfid1))

# blob = entry_pack_mkdir(gfid2, dname, 16893, 0, 0)
# Xattr.lsetxattr('.gfid/' + gfid1, 'glusterfs.gfid.newfile', blob)
