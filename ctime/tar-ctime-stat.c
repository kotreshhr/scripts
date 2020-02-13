#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>
#include <libgen.h>

/* find ./linux-5.0.6/ -exec /root/a.out {} \; > ~/testcase.out4.noatimeon */

int main(int argc, char *argv[])
{
    int fd = -1;
    int dirfd = -1;
    struct stat st = {0,};
    char buf[4096] = {0,};
    char path[1024] = {0,};
    char *bname = NULL;
    char *dname = NULL;
    unsigned int ctime1 = 0;
    unsigned int ctime2 = 0;
    unsigned int ctime3 = 0;
    unsigned int size1 = 0;
    unsigned int size2 = 0;
    unsigned int size3 = 0;

    unsigned int nctime1 = 0;
    unsigned int nctime2 = 0;
    unsigned int nctime3 = 0;

    printf("File path : %s\n", argv[1]);
    
    
    strcpy(path, argv[1]);
    bname = basename(path);
    dname = dirname(argv[1]);

    printf("Dir path : %s\n", dname);
    printf("Basename : %s\n\n", bname);

    dirfd = open(dname, O_RDONLY|O_NOCTTY|O_NONBLOCK|O_NOFOLLOW|O_CLOEXEC);
    if (dirfd < 0) {
        printf ("open dirfd error: %s\n", strerror(errno));
        exit(1);
    }
    //printf("dirfd opened: %d\n", dirfd);

    if (fstatat(dirfd, bname, &st, AT_SYMLINK_NOFOLLOW) < 0) {
        printf("fstat failed: %s\n", strerror(errno));
        exit(1);
    }

    printf("Before open of file\n");
    printf("ctime: %u: %lu\n", st.st_ctim.tv_sec, st.st_ctim.tv_nsec);
    printf("atime: %u: %lu\n", st.st_atim.tv_sec, st.st_atim.tv_nsec);
    printf("mtime: %u: %lu\n", st.st_mtim.tv_sec, st.st_mtim.tv_nsec);
    printf("size: %u\n\n\n", st.st_size);
    nctime1 = st.st_ctim.tv_nsec;
    ctime1 = st.st_ctim.tv_sec;
    size1 = st.st_size;
    

    fd = openat(dirfd, bname, O_RDONLY|O_NOCTTY|O_NONBLOCK|O_NOFOLLOW|O_CLOEXEC);
    if (fd < 0) {
        printf ("open error: %s\n", strerror(errno));
        exit(1);
    }

    //printf("fd opened: %d\n", fd);

    if (fstat(fd, &st) < 0) {
        printf("fstat failed: %s\n", strerror(errno));
        exit(1);
    }
    
    printf("After open of file\n");
    printf("ctime: %u: %lu\n", st.st_ctim.tv_sec, st.st_ctim.tv_nsec);
    printf("atime: %u: %lu\n", st.st_atim.tv_sec, st.st_atim.tv_nsec);
    printf("mtime: %u: %lu\n", st.st_mtim.tv_sec, st.st_mtim.tv_nsec);
    printf("size: %u\n\n\n", st.st_size);
    nctime2 = st.st_ctim.tv_nsec;
    ctime2 = st.st_ctim.tv_sec;
    size2 = st.st_size;

    read(fd, buf, 4000);
    //printf("1024 bytes: %s\n\n\n", buf); 

    if (fstat(fd, &st) < 0) {
        printf("fstat failed: %s\n", strerror(errno));
        exit(1);
    }

    printf("After read of file\n");
    printf("ctime: %u: %lu\n", st.st_ctim.tv_sec, st.st_ctim.tv_nsec);
    printf("atime: %u: %lu\n", st.st_atim.tv_sec, st.st_atim.tv_nsec);
    printf("mtime: %u: %lu\n", st.st_mtim.tv_sec, st.st_mtim.tv_nsec);
    printf("size: %u\n\n\n", st.st_size);
    nctime3 = st.st_ctim.tv_nsec;
    ctime3 = st.st_ctim.tv_sec;
    size3 = st.st_size;

    if (ctime1 == ctime2 && ctime1 == ctime3) {
        if (nctime1 == nctime2 && nctime1 == nctime3) {
            if (size1 == size2 && size1 == size3) {
                printf("All Good\n\n");
            } else {
                printf("Bad: Size changed\n\n");
            }
        } else {
                printf("Bad: nano ctime changed\n\n");
        }
    } else {
        printf("Bad: sec ctime changed\n\n");
    }

    close(fd);
}
