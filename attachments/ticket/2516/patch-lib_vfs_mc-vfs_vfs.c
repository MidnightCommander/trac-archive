$NetBSD$

--- lib/vfs/mc-vfs/vfs.c.orig	2010-11-08 11:46:13 +0000
+++ lib/vfs/mc-vfs/vfs.c
@@ -74,6 +74,10 @@
 #  define NAME_MAX FILENAME_MAX
 #endif
 
+#ifndef MAXNAMLEN
+#define MAXNAMLEN PATH_MAX
+#endif
+
 /** They keep track of the current directory */
 static struct vfs_class *current_vfs;
 static char *current_dir;
