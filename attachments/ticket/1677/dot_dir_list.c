#include <stdio.h>
#include <stdlib.h>
#include <glob.h>

#include <glib.h>
#include <glib/gprintf.h>

#define PATH_SEP "/"

/**
 *  Return glob_t with names of files found by glob. Use globfree()
 * to free struct.
 *
 *  Example:
 *
 *  glob_t *globbuf;
 *
 *  globbuf = dot_dir_list (NULL, "/etc/mc/extfs", "extfs", "ini");
 *  globbuf = dot_dir_list (globbuf, "~/.mc/extfs", "extfs", "ini");
 *
 *  for (i = 0; i < globbuf->gl_pathc; i++) {
 *      g_printf ("%s\n", globbuf->gl_pathv[i]);
 *  }
 *
 *  globfree (globbuf);
 */
glob_t *
dot_dir_list (glob_t * const previous_globbuf, const gchar * const dir_path,
	      const gchar * const file_name, const gchar * const file_ext)
{

  glob_t *const globbuf =
    (previous_globbuf) ? previous_globbuf : (glob_t *
					     const)
    g_try_malloc0 (sizeof (glob_t));
  /* "DIR/FILE.EXT" */
  const gchar *const file_path =
    g_strdup_printf ("%s" PATH_SEP "%s.%s", dir_path, file_name, file_ext);
  /* "DIR/FILE.d/ *.EXT" */
  const gchar *const dot_dir_glob =
    g_strdup_printf ("%s" PATH_SEP "%s.d" PATH_SEP "*.%s", dir_path,
		     file_name, file_ext);

  if (!globbuf || !file_path || !dot_dir_glob)
    {
      if (globbuf)
	globfree (globbuf);
      if (file_path)
	g_free ((gpointer) file_path);
      if (dot_dir_glob)
	g_free ((gpointer) dot_dir_glob);
      return NULL;
    }

  /* Look for file "dir/file.ext" */
  glob (file_path, GLOB_TILDE_CHECK | GLOB_APPEND, NULL, globbuf);

  /* Look for files in .d dir "dir/file.d/ *.ext" */
  glob (dot_dir_glob, GLOB_TILDE_CHECK | GLOB_APPEND, NULL, globbuf);

  g_free ((gpointer) file_path);
  g_free ((gpointer) dot_dir_glob);

  return globbuf;
}

int
main (const int argc, const char *const *const argv)
{
  glob_t *globbuf;
  int i;

  if (argc < 4)
    {
      globbuf = dot_dir_list (NULL, "/etc/mc/extfs", "extfs", "ini");
      globbuf = dot_dir_list (globbuf, "~/.mc/extfs", "extfs", "ini");
    }
  else
    {
      globbuf = dot_dir_list (NULL, argv[1], argv[2], argv[3]);
      if (argc >= 7)
	{
	  globbuf = dot_dir_list (globbuf, argv[4], argv[5], argv[6]);
	}
    }

  if (globbuf)
    {
      if (globbuf->gl_pathc == 0)
	{
	  g_printf ("%s\n", "No matches!");
	}
      else
	{

	  for (i = 0; i < globbuf->gl_pathc; i++)
	    {
	      g_printf ("%s\n", globbuf->gl_pathv[i]);
	    }

	}

      globfree (globbuf);
    }
  else
    {
      g_printf ("%s\n", "An error happen!");
    }

  return 0;
}
