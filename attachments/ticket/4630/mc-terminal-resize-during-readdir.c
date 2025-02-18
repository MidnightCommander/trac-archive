// Verify that mc resizes its panel(s) properly when the terminal is resized.
// See https://bugs.debian.org/1060651#.

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
#include <ctype.h>
#include <errno.h>
#include <fcntl.h>
#include <pthread.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/wait.h>
#include <unistd.h>


struct measurer_arg {
	int pty_master;
	unsigned saw_width;
};

static void
die_perror(const char *str)
{
	perror(str);
	exit(EXIT_FAILURE);
}

static void
die_usage(const char *name)
{
	fprintf(stderr, "Usage: %s\n", name);
	exit(2);
}

static unsigned
utf8_measure_badly(const uint8_t *p)
{
	// this is just good enough to parse mc's output, at the time of
	// writing; we don't want any embedded control sequences, double-width
	// or combining characters, or any other weird surprises
	int ret = 0;
	for (; *p; p++) {
		if (*p >= 240) --ret;
		if (*p >= 224) --ret;
		if (*p >= 192) --ret;
		++ret;
	}
	return (ret < 0) ? 0 : (unsigned)ret;
}

static unsigned
measure_panel_width(const uint8_t *buf)
{
	// find the last instance of U+2514 BOX DRAWINGS LIGHT UP AND RIGHT
	// (at the bottom-left corner of the rightmost panel) before mc exited
	const uint8_t *u2514 = "\xe2\x94\x94";
	uint8_t *p;

	p = (uint8_t*)strstr((char*)buf, u2514);
	while (p) {
		uint8_t *q = (uint8_t*)strstr((char*)&p[1], u2514);
		if (!q) break;
		p = q;
	}
	if (!p) {
		return 0;
	}

	// rewind to the last control character
	while ((p > buf) && (*p >= 32)) {
		--p;
	}

	// if at an escape sequence, move to its end
	if (*p == '\x1b') {
		while (*p && !isalpha((int)*p) ) {
			++p;
		}
	}
	++p;

	// p should now be pointing at the beginning of the panel-bottom-drawing
	// sequence.  We assume mc draws the bottom of all visible panels as one
	// uninterrupted sequence.

	// cut at the end of the line, or an escape sequence
	{
		char *dummy;
		strtok_r((char*)p, "\r\n\x1b", &dummy);
	}
	return utf8_measure_badly(p);
}

static void*
measurer(void *arg_)
{
	struct measurer_arg *arg = arg_;
	int err = 0;
	ssize_t rv;
	size_t bufsize = 1024 * 1024, i = 0;

	uint8_t *buf = malloc(bufsize);
	if (!buf) {
		die_perror("malloc");
	}

	while (i < bufsize - 1) {
		rv = read(arg->pty_master, &buf[i], bufsize - 1 - i);
		if (rv < 0) {
			// On Linux, we get EIO when mc exits
			if (EIO == errno) break;
			die_perror("measurer:read");
		} else if (!rv) {
			break;
		}
		i += (size_t)rv;
	}
	buf[i] = '\0';
	arg->saw_width = measure_panel_width(buf);

	free(buf);
	return NULL;
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

int
main(int argc, char **argv)
{
	int opt, pty_master, pty_slave, pipefd[2];
	bool skip_preload = false, failed = false;
	pid_t child_pid;
	const char *slave_path;
	pthread_t measurer_tid;
	struct measurer_arg measurer_arg = {.saw_width=0};
	struct winsize winsz = { .ws_row = 15, .ws_col = 30 };

	while ((opt = getopt(argc, argv, "P")) != -1) {
		switch (opt) {
		case 'P':
			// This option will make the test fail, but
			// is useful to verify the "measurer" thread.
			skip_preload = true;
			break;
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
	printf("initial ws_col: %hu\n", winsz.ws_col);
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

		if (!skip_preload) {
			if (0 != setenv("LD_PRELOAD", "./readdir-wait.so", 1)) {
				die_perror("setenv");
			}
		}
		if (0 != setenv("TERM", "xterm", 1)) {
			die_perror("setenv");
		}
		if (0 != setenv("LC_ALL", "C.UTF-8", 1)) {
			die_perror("setenv");
		}

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
		close_fd(pipefd[0]);
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

	// Collect mc's output
	measurer_arg.pty_master = pty_master;
	errno = pthread_create(&measurer_tid, NULL, measurer, &measurer_arg);
	if (errno) {
		die_perror("pthread_create");
	}

	// Wait till mc runs our hooked readdir(), which should happen before
	// it processes any input; but in case pre-loading the library fails,
	// have mc's shell also print to our pipe
	write_str_or_die(pty_master, "printf X >&3\n");
	{
		char ch;
		ssize_t rv;

		rv = read(pipefd[0], &ch, 1);
		if (rv < 0) {
			die_perror("read(pipe)");
		}

		if ((1 == rv) && ('\0' == ch)) {
			// our library writes '\0'
			printf("preloaded library stopped in readdir()\n");
		} else {
			printf("FAIL: $LD_PRELOAD failed or was skipped\n");
			failed = true;
		}
	}

	// Change the terminal width (which should trigger SIGWINCH)
	winsz.ws_col *= 3;
	printf("setting ws_col: %hu\n", winsz.ws_col);
	if (ioctl(pty_master, TIOCSWINSZ, &winsz) < 0) {
		die_perror("ioctl(TIOCSWINSZ)");
	}

	// Wait till mc closes its pipe or runs this printf;
	// it should also redraw its panels after running this
	write_str_or_die(pty_master, "printf Y >&3\n");
	{
		char ch;
		ssize_t rv;

		rv = read(pipefd[0], &ch, 1);
		if (rv < 0) {
			die_perror("read(pipe)");
		} else if (0 == rv) {
			printf("preloaded library woke up (presumably from SIGWINCH)\n");
		}
	}
	close_fd(pipefd[0]);

	// Ask mc to exit, and wait for it
	write_str_or_die(pty_master, "exit\n");
	{
		errno = pthread_join(measurer_tid, NULL);
		if (errno) {
			die_perror("pthread_join");
		}
		printf("panel width measured as %u columns\n",
				measurer_arg.saw_width);
	}

	// Did it ever notice the SIGWINCH?
	if (measurer_arg.saw_width != winsz.ws_col) {
		failed = true;
	}
	printf(failed ? "FAIL\n" : "PASS\n");
	return failed ? EXIT_FAILURE : EXIT_SUCCESS;
}
