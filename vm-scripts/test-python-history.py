class _MetaChangelog(object):

    def __getattr__(self, meth):
        from libgfchangelog import Changes as LChanges
        xmeth = [m for m in dir(LChanges) if m[0] != '_']
        if meth not in xmeth:
            return
        for m in xmeth:
            setattr(self, m, getattr(LChanges, m))
        return getattr(self, meth)

Changes = _MetaChangelog()

def main():
    Changes.cl_register("/d/backends/master1", "/var/lib/misc/gluster/gsyncd/master_127.0.0.1_slave/d-backends-master1", "/var/log/glusterfs/geo-replication/master_127.0.0.1_slave/changes-d-backends-master1.log", 9, 5)

if __name__ == "__main__":
    main()
