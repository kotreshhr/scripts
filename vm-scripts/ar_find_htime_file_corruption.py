import sys


if len(sys.argv) < 2:
    print("USAGE: python %s <htime-file-path>" % sys.argv[0])
    sys.exit(1)

problems = 0
with open(sys.argv[1]) as f:
    data = f.read()
    parts = data.split("\x00")

    # Get the prefix of each Changelog path without /CHANGELOG.<TS>
    path_prefix = parts[0].rsplit("/", 1)[0]

    for p in parts:
        pp = p.rsplit(".", 1)
        if not pp:
            continue

        # Valid Timestamp test
        valid_ts = True
        try:
            int(pp[1])
            if len(pp[1]) != 10:
                valid_ts = False
        except (ValueError, IndexError):
            valid_ts = False

        valid_path_prefix = False
        ppp = pp[0].rsplit("/", 1)
        if ppp[0] == path_prefix and ppp[1].lower() == "changelog":
            valid_path_prefix = True

        if not (valid_path_prefix and valid_ts):
            print(p)
            problems += 1

if problems > 0:
    print("Number of entries corrupted: %s" % problems)
else:
    print("HTIME file \"%s\" is Good." % sys.argv[1])

