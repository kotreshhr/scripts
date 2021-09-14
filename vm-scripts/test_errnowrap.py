import os
import sys
import time
from errno import ENOENT, ESTALE

def errno_wrap(call, arg=[], errnos=[], retry_errnos=[]):
    """ wrapper around calls resilient to errnos.
    """
    nr_tries = 0
    while True:
        try:
            return call(*arg)
        except OSError:
            ex = sys.exc_info()[1]
            if ex.errno in errnos:
                return ex.errno
            if not ex.errno in retry_errnos:
                raise
            nr_tries += 1
            if nr_tries == 5:
                # probably a screwed state, cannot do much...
                #logging.warn('reached maximum retries (%s)...%s' %
                #             (repr(arg), ex))
                raise
            time.sleep(0.250)  # retry the call

cmd_ret = errno_wrap(os.lstat, ["/mastermnt/file1"], [ENOENT], [ESTALE])
print cmd_ret.st_mode
cmd_ret = errno_wrap(os.lstat, ["/mastermnt/nonexist"], [ENOENT], [ESTALE])
print cmd_ret
