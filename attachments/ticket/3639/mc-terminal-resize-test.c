// Verify that mc's subshell sees the correct terminal size
// after it's changed.  See https://bugs.debian.org/825974#.

/*
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <https://unlicense.org/>
*/

#define _POSIX_C_SOURCE 200809L
#define _XOPEN_SOURCE 700
#include <errno.h>
#include <fcntl.h>
#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/wait.h>
#include <unistd.h>

static void
die_perror(const char *str)
{
	perror(str);
	exit(1);
}

static void
die_usage(const char *name)
{
	fprintf(stderr, "Usage: %s\n", name);
	exit(2);
}

static void*
drainer(void *arg)
{
	char buf[1024];
	int *p_fd = arg;
	ssize_t rv;

	do {
		rv = read(*p_fd, &buf[0], sizeof buf);
	} while (rv > 0);

	return (rv == 0) ? NULL : (void*)(intptr_t)errno;
}

static void
close_fd(int fd)
{
	do {} while (close(fd) < 0 && errno == EINTR);
}

static void
write_str_or_die(int fd, const char *str)
{
	size_t offset = 0, len = strlen(str);
	while (offset < len) {
		ssize_t rv = write(fd, &str[offset], len);
		if (rv < 0) {
			if (errno == EINTR) continue;
			die_perror("write");
		}
		offset += (size_t)rv;
	}
}

static size_t
read_to_eof_or_die(int fd, char *buf, size_t bufsz)
{
	size_t offset = 0;
	while (offset < bufsz) {
		ssize_t rv = read(fd, &buf[offset], bufsz-offset);
		if (rv < 0) {
			if (errno == EINTR) continue;
			die_perror("read");
		} else if (rv == 0) {
			break;
		}
		offset += (size_t)rv;
	}
	return offset;
}

int
main(int argc, char **argv)
{
	int opt;
	int pty_master, pty_slave;
	int pipefd[2];
	int child_pid;
	const char *slave_path;
	char buf[256];
	pthread_t drainer_tid;
	struct winsize winsz = { .ws_row = 25, .ws_col = 55 };

	while ((opt = getopt(argc, argv, "")) != -1) {
		switch (opt) {
		default:
		case '?':
			die_usage(argv[0]);
		}
	}
	if (optind > argc) {
		die_usage(argv[0]);
	}

	// Set up a pseudoterminal
	pty_master = posix_openpt(O_RDWR | O_NOCTTY | O_CLOEXEC);
	if (pty_master < 0) {
		die_perror("posix_openpt");
	}
	if (grantpt(pty_master) < 0) {
		die_perror("grantpt");
	}
	if (unlockpt(pty_master) < 0) {
		die_perror("unlockpt");
	}
	slave_path = ptsname(pty_master);
	if (!slave_path) {
		die_perror("ptsname");
	}

	// Set the initial size
	if (ioctl(pty_master, TIOCSWINSZ, &winsz) < 0) {
		die_perror("ioctl(TIOCSWINSZ)");
	}

	pty_slave = open(slave_path, O_RDWR | O_NOCTTY);
	if (pty_slave < 0) {
		die_perror("open(slave)");
	}

	// Create a pipe to communicate with mc
	if (pipe(&pipefd[0]) < 0) {
		die_perror("pipe");
	}

	// Fork a process to run mc
	child_pid = fork();
	if (child_pid < 0) {
		die_perror("fork");
	} else if (!child_pid) {
		char *exec_args[] = {"mc", (char*)NULL};

		if (setsid() < 0) {
			die_perror("setsid");
		}
		if (ioctl(pty_slave, TIOCSCTTY, NULL) < 0) {
			die_perror("ioctl(TIOCSCTTY)");
		}
		if (dup2(pty_slave, 0) < 0
				|| dup2(pty_slave, 1) < 0
				|| dup2(pty_slave, 2) < 0
				|| dup2(pipefd[1], 3) < 0) {
			die_perror("dup2");
		}
		if (pty_slave > 3) {
			close_fd(pty_slave);
		}

		(void)execvp(exec_args[0], exec_args);
		die_perror("execvp");
	}

	close_fd(pty_slave);
	pty_slave = -1;
	close_fd(pipefd[1]);
	pipefd[1] = -1;

	// Have a thread read from the pty so mc won't block
	errno = pthread_create(&drainer_tid, NULL, drainer, &pty_master);
	if (errno) {
		die_perror("pthread_create");
	}

	// Send some keystrokes and wait until they've been processed
	write_str_or_die(pty_master, "\xf" /*CTRL+O*/);
	write_str_or_die(pty_master, "echo '' >&3\n");
	if (read(pipefd[0], &buf[0], 1) < 0) {
		die_perror("read(pipe)");
	}

	// Change the terminal width
	winsz.ws_col += 11;
	if (ioctl(pty_master, TIOCSWINSZ, &winsz) < 0) {
		die_perror("ioctl(TIOCSWINSZ)");
	}

	// Have mc write the detected terminal size to our pipe, then exit
	write_str_or_die(pty_master, "stty size >&3; exit\n");

	// Verify that we got the new width
	{
		ssize_t bytes;
		int row, col;

		bytes = read_to_eof_or_die(pipefd[0], &buf[0], sizeof buf - 1);

		errno = 0;
		buf[bytes] = '\0';
		if (sscanf(&buf[0], "%d %d\n", &row, &col) != 2) {
			die_perror("sscanf");
		}

		printf("got size %dx%d, wanted %dx%d\n",
				col, row, winsz.ws_col, winsz.ws_row);
		if (col == winsz.ws_col) {
			printf("PASS\n");
			return 0;
		} else {
			printf("FAIL\n");
			return 1;
		}
	}
}
