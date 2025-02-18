// This is free and unencumbered software released into the public domain.
#define _GNU_SOURCE    // make dlfcn.h define RTLD_NEXT
#include <dirent.h>
#include <dlfcn.h>
#include <errno.h>
#include <signal.h>
#include <stdio.h>     // perror()
#include <stdlib.h>    // abort()
#include <unistd.h>    // read()


static void
die_perror(const char *str)
{
	perror(str);
	exit(1);
}

static void
mc_test_wait(void)
{
	sigset_t orig_mask, sigwinch;
	static int done = 0;
	const int test_fd = 3;

	if (done) return;
	done = 1;

	sigemptyset(&sigwinch);
	sigaddset(&sigwinch, SIGWINCH);
	errno = pthread_sigmask(SIG_BLOCK, &sigwinch, &orig_mask);
	if (errno) {
		die_perror("pthread_sigmask");
	}

	// test the parent process we're ready for our SIGWINCH
	do {} while (write(test_fd, "", 1) < 0 && errno == EINTR);

	// wait for SIGWINCH
	sigsuspend(&orig_mask);
	do {} while (close(test_fd) < 0 && errno == EINTR);

	errno = pthread_sigmask(SIG_SETMASK, &orig_mask, NULL);
	if (errno) {
		die_perror("pthread_sigmask");
	}
}

struct dirent *
readdir(DIR *dirp)
{
	struct dirent *ret = NULL;
	struct dirent *(*real_fn)(DIR*);

	mc_test_wait();

	real_fn = dlsym(RTLD_NEXT, __func__);
	if (!real_fn) {
		errno = ELIBACC;
		goto out;
	}
	ret = real_fn(dirp);
out:
	return ret;
}
