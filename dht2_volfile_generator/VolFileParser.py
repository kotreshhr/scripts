import sys
from collections import OrderedDict
import copy

def print_volfile (volfile):
    for k, v in volfile.items():
        print "volume", k
        for i, j in v.items():
            if isinstance(j, dict):
                for m, n in j.items():
                    print "    option %s %s" % (m, n)
            else:
                if isinstance(j, list):
                    print "    %s %s" % (i, " ".join(j))
                else:
                    print "    %s %s" % (i, j)
        print "end-volume\n"

def write_volfile (volfile, fname):
    with open(fname, "w") as f:
        for k, v in volfile.items():
            f.write("volume %s\n" % (k))
            for i, j in v.items():
                if isinstance(j, dict):
                    for m, n in j.items():
                        f.write("    option %s %s\n" % (m, n))
                else:
                    if isinstance(j, list):
                        f.write("    %s %s\n" % (i, " ".join(j)))
                    else:
                        f.write("    %s %s\n" % (i, j))
            f.write("end-volume\n\n")

def del_xl(volfile, xl):
    try:
        del(volfile[xl])
    except KeyError:
        pass

def del_unsupported_server_xlators (volfile, volname):
    del_xl(volfile, volname + "-trash")
    del_xl(volfile, volname + "-changetimerecorder")
    del_xl(volfile, volname + "-changelog")
    del_xl(volfile, volname + "-bitrot-stub")
    del_xl(volfile, volname + "-access-control")
    del_xl(volfile, volname + "-locks")
    del_xl(volfile, volname + "-worm")
    del_xl(volfile, volname + "-read-only")
    del_xl(volfile, volname + "-leases")
    del_xl(volfile, volname + "-upcall")
    del_xl(volfile, volname + "-marker")
    del_xl(volfile, volname + "-barrier")
    del_xl(volfile, volname + "-index")
    del_xl(volfile, volname + "-quota")
    del_xl(volfile, volname + "-decompounder")

def del_unsupported_tcp_client_xlators (volfile, volname):
    del_xl(volfile, volname + "-write-behind")
    del_xl(volfile, volname + "-read-ahead")
    del_xl(volfile, volname + "-readdir-ahead")
    del_xl(volfile, volname + "-io-cache")
    del_xl(volfile, volname + "-quick-read")
    del_xl(volfile, volname + "-open-behind")
    del_xl(volfile, volname + "-md-cache")

def prepare_dht2_client_xlators (volfile, volname, mds_count, ds_count, brick_list, n):

    #Prepare default sub and opt dictionaries for protocol/client xlator
    opt_dict = OrderedDict()
    sub_dict = OrderedDict()
    sub_dict["type"] = "protocol/client"
    opt_dict["send-gids"] = "true"
    opt_dict["transport.address-family"] = "inet"
    opt_dict["transport-type"] = "tcp"

    #Convert posix into client-0
    #volfile[volname + "-client-0"] = volfile[volname + "-posix"]
    #del(volfile[volname + "-posix"])

    i = 0
    while i < mds_count + ds_count:
        if i == n:
            i += 1
            continue
        opt_dict["remote-subvolume"] = brick_list[i].split(":")[-1]
        opt_dict["remote-host"] = brick_list[i].split(":")[0]
        opt_dict["ping-timeout"] = 42
        sub_dict["option"] = opt_dict
        volfile[volname + "-client-" + str(i)] = copy.deepcopy(sub_dict)
        i += 1

    del(sub_dict)
    del(opt_dict)

def prepare_dht2_xlator (volfile, volname, mds_count, ds_count, brick_list, server, n):

    opt_dict = OrderedDict()
    sub_dict = OrderedDict()
    mds_bricks = ""
    ds_bricks = ""
    i = 0
    while i < ds_count:
        if i == ds_count -1:
            ds_bricks += volname + "-client-" + str(i)
        else:
            ds_bricks += volname + "-client-" + str(i) + ":"
        i += 1

    i = ds_count 
    while i < mds_count + ds_count:
        if i == mds_count + ds_count - 1:
            mds_bricks += volname + "-client-" + str(i)
        else:
            mds_bricks += volname + "-client-" + str(i) + ":"
        i += 1

    subvols = [volname + "-client-" + str(n)]
    i = 0
    while i < mds_count + ds_count:
        if i == n:
            i += 1
            continue
        subvols.append(volname + "-client-" + str(i))
        i += 1

    if server:
        sub_dict["type"] = "experimental/dht2s"
    else:
        sub_dict["type"] = "experimental/dht2c"
    opt_dict["lock-migration"] = "off"
    opt_dict["dht2-data-subvolumes"] =  ds_bricks
    opt_dict["dht2-metadata-subvolumes"] =  mds_bricks
    if server:
        opt_dict["dht2-server-local-subvol"] = volname + "-client-" + str(n)
    sub_dict["option"] = opt_dict.copy()
    sub_dict["subvolumes"] = subvols
    volfile[volname + "-dht"] = sub_dict.copy()

    del(sub_dict)
    del(opt_dict)

def parse_input_volfile(orig_volfile):
    volfile = OrderedDict() 
    with open(orig_volfile, "r") as f:
        for line in f:
            try:
                isinstance(opt_dict, dict)
            except UnboundLocalError:
                opt_dict = OrderedDict()

            try:
                isinstance(sub_dict, dict)
            except UnboundLocalError:
                sub_dict = OrderedDict()

            temp = line.split()
            if not temp:
                continue
            if line.startswith("volume "):
                xl_name = temp[1]
            elif temp[0] == "type":
                sub_dict[temp[0]] = temp[1]
                sub_dict["options"] = OrderedDict()
            elif temp[0] == "option":
                opt_dict[temp[1]] = temp[2]
            elif temp[0] == "subvolumes":
                sub_dict[temp[0]] = temp[1:]
            elif line.startswith("end-volume"):
                sub_dict["options"] = opt_dict.copy()
                volfile[xl_name] = sub_dict.copy()
                del(opt_dict)
                del(sub_dict)
            else:
                print "Oops!!! Bug, Parser needs an update..."
                sys.exit(1)
    return volfile


def generate_dht2_server_volfile(volname, brick_list, mds_count, ds_count, orig_volfile, new_dht2_volfile, n):

    volfile = parse_input_volfile(orig_volfile)

    dht2_volfile = OrderedDict()

    #Prepare dht2 client-0 xlator
    dht2_volfile[volname + "-client-" + str(n)] = copy.deepcopy(volfile[volname + "-posix"])

    #Preapre dht2 client (1...n) xlators
    prepare_dht2_client_xlators(dht2_volfile, volname, mds_count, ds_count, brick_list, n)

    #Prepare dht2s xlator
    prepare_dht2_xlator(dht2_volfile, volname, mds_count, ds_count, brick_list, True, n)
    
    #Merge original volfile and dht2 volfile with necessary changes
    #Del all unsupported xlators
    del_unsupported_server_xlators (volfile, volname)

    #Del master-posix xlator
    del(volfile[volname + "-posix"])

    #Fix subvolumes because of deletion of unsupported xlators
    master_subvolume =  volfile[volname + "-server"]["options"]["auth-path"]
    volfile[volname + "-server"]["subvolumes"] = master_subvolume
    volfile[master_subvolume]["subvolumes"] = volname + "-io-threads"
    volfile[volname + "-io-threads"]["subvolumes"] = volname + "-dht"
    dht2_volfile.update(volfile)

    #Write dht2 volfile
    write_volfile(dht2_volfile, new_dht2_volfile)

def generate_dht2_tcp_volfile(volname, brick_list, mds_count, ds_count, orig_volfile, new_dht2_volfile):
    volfile = parse_input_volfile(orig_volfile)
    del_unsupported_tcp_client_xlators (volfile, volname)

    dht2_volfile = OrderedDict()
    dht2_volfile.update(volfile)
    #Modify client side dht xlator
    prepare_dht2_xlator(dht2_volfile, volname, mds_count, ds_count, brick_list, False, 0)

    #Fix io-stats subvolume
    dht2_volfile[volname]["subvolumes"] = volname + "-dht"

    write_volfile(dht2_volfile, new_dht2_volfile)
