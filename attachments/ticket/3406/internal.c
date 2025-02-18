/* Virtual File System: SFTP file system.
   The internal functions

   Copyright (C) 2011-2016
   Free Software Foundation, Inc.

   Written by:
   Ilia Maslakov <il.smind@gmail.com>, 2011
   Slava Zanko <slavazanko@gmail.com>, 2011, 2012

   This file is part of the Midnight Commander.

   The Midnight Commander is free software: you can redistribute it
   and/or modify it under the terms of the GNU General Public License as
   published by the Free Software Foundation, either version 3 of the License,
   or (at your option) any later version.

   The Midnight Commander is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <config.h>
#include <errno.h>

#include "lib/global.h"
#include "lib/util.h"

#include "src/filemanager/ioblksize.h"          /* IO_BUFSIZE */

#include "internal.h"



/*** global variables ****************************************************************************/

GString *sftpfs_filename_buffer = NULL;

/*** file scope macro definitions ****************************************************************/
#define mc_return_val_if_error_and_free(mcerror, mcvalue, to_free) \
    do {                                                           \
        if (mcerror != NULL && *mcerror != NULL)                   \
        {                                                          \
            if (to_free != NULL)                                   \
                g_free(to_free);                                   \
            return mcvalue;                                        \
        }                                                          \
    } while (0)

#define _is_sftp_proto_error(super_data, res, libssh_errno)             \
    ((res == LIBSSH2_ERROR_SFTP_PROTOCOL) &&                            \
     (libssh2_sftp_last_error((super_data)->sftp_session) == libssh_errno))

/*** file scope type declarations ****************************************************************/

/*** file scope variables ************************************************************************/

/*** file scope functions ************************************************************************/

static int
_waitsocket_or_error(sftpfs_super_data_t *super_data, int res,
                     GError ** mcerror, void *to_free)
{
    if (res != LIBSSH2_ERROR_EAGAIN)
    {
        sftpfs_ssherror_to_gliberror (super_data, res, mcerror);
        if (to_free != NULL)
            g_free(to_free);
        return -1;
    }

    sftpfs_waitsocket (super_data, mcerror);
    mc_return_val_if_error_and_free (mcerror, -1, to_free);

    return 0;
}

/* --------------------------------------------------------------------------------------------- */
static int
_sftpfs_op_init(sftpfs_super_data_t ** super_data,
                const vfs_path_element_t ** path_element,
                const vfs_path_t * vpath, GError ** mcerror)
{
    struct vfs_s_super *super;

    mc_return_val_if_error (mcerror, -1);

    *path_element = vfs_path_get_by_index (vpath, -1);

    if (vfs_s_get_path (vpath, &super, 0) == NULL)
        return -1;

    if (super == NULL)
        return -1;

    *super_data = (sftpfs_super_data_t *) super->data;
    if ((*super_data)->sftp_session == NULL)
        return -1;

    return 0;
}

/* --------------------------------------------------------------------------------------------- */

static int
_sftpfs_stat (sftpfs_super_data_t ** super_data,
              const vfs_path_element_t ** path_element,
              const vfs_path_t * vpath, GError ** mcerror, const int stat_type,
              LIBSSH2_SFTP_ATTRIBUTES *attrs)
{
    int res;

    if (_sftpfs_op_init(super_data, path_element, vpath, mcerror) != 0)
        return -1;

    do
    {
        const char *fixfname;

        fixfname = sftpfs_fix_filename ((*path_element)->path);

        res = libssh2_sftp_stat_ex ((*super_data)->sftp_session, fixfname,
                                    sftpfs_filename_buffer->len,
                                    stat_type, attrs);

        if (res >= 0)
            break;

        if (_is_sftp_proto_error(*super_data, res,
                                LIBSSH2_FX_PERMISSION_DENIED))
            return EACCES;

        if (_is_sftp_proto_error(*super_data, res, LIBSSH2_FX_NO_SUCH_FILE))
            return ENOENT;

        if (_waitsocket_or_error(*super_data, res, mcerror, NULL) != 0)
            return -1;
    }
    while (res == LIBSSH2_ERROR_EAGAIN);

    return res;
}

/* --------------------------------------------------------------------------------------------- */

static void
_sftpfs_attr_to_buf(struct stat *buf, LIBSSH2_SFTP_ATTRIBUTES *attrs)
{
    if ((attrs->flags & LIBSSH2_SFTP_ATTR_UIDGID) != 0)
    {
        buf->st_uid = attrs->uid;
        buf->st_gid = attrs->gid;
    }

    if ((attrs->flags & LIBSSH2_SFTP_ATTR_ACMODTIME) != 0)
    {
        buf->st_atime = attrs->atime;
        buf->st_mtime = attrs->mtime;
        buf->st_ctime = attrs->mtime;
    }

    if ((attrs->flags & LIBSSH2_SFTP_ATTR_SIZE) != 0)
        buf->st_size = attrs->filesize;

    if ((attrs->flags & LIBSSH2_SFTP_ATTR_PERMISSIONS) != 0)
        buf->st_mode = attrs->permissions;

    /* patch or segfault here */
    buf->st_blksize = IO_BUFSIZE;
    buf->st_blocks = 1 + ((buf->st_size - 1) / buf->st_blksize);
}

/* --------------------------------------------------------------------------------------------- */
/*** public functions ****************************************************************************/
/* --------------------------------------------------------------------------------------------- */
/**
 * Convert libssh error to GError object.
 *
 * @param super_data   extra data for SFTP connection
 * @param libssh_errno errno from libssh
 * @param mcerror      pointer to the error object
 */

void
sftpfs_ssherror_to_gliberror (sftpfs_super_data_t * super_data, int libssh_errno, GError ** mcerror)
{
    char *err = NULL;
    int err_len;

    mc_return_if_error (mcerror);

    libssh2_session_last_error (super_data->session, &err, &err_len, 1);
    if (libssh_errno == LIBSSH2_ERROR_SFTP_PROTOCOL &&
        super_data->sftp_session != NULL)
    {
        mc_propagate_error (mcerror, libssh_errno, "%s %lu", err,
                            libssh2_sftp_last_error(super_data->sftp_session));
    } else {
        mc_propagate_error (mcerror, libssh_errno, "%s", err);
    }
    g_free (err);
}

/* --------------------------------------------------------------------------------------------- */
/**
 * Fix filename for SFTP operations: add leading slash to file name.
 *
 * @param file_name file name
 * @return newly allocated string contains the file name with leading slash
 */

const char *
sftpfs_fix_filename (const char *file_name)
{
    g_string_printf (sftpfs_filename_buffer, "%c%s", PATH_SEP, file_name);
    return sftpfs_filename_buffer->str;
}

/* --------------------------------------------------------------------------------------------- */
/**
 * Awaiting for any activity on socket.
 *
 * @param super_data extra data for SFTP connection
 * @param mcerror    pointer to the error object
 * @return 0 if success, negative value otherwise
 */

int
sftpfs_waitsocket (sftpfs_super_data_t * super_data, GError ** mcerror)
{
    struct timeval timeout = { 10, 0 };
    fd_set fd;
    fd_set *writefd = NULL;
    fd_set *readfd = NULL;
    int dir;

    mc_return_val_if_error (mcerror, -1);

    FD_ZERO (&fd);
    FD_SET (super_data->socket_handle, &fd);

    /* now make sure we wait in the correct direction */
    dir = libssh2_session_block_directions (super_data->session);

    if ((dir & LIBSSH2_SESSION_BLOCK_INBOUND) != 0)
        readfd = &fd;

    if ((dir & LIBSSH2_SESSION_BLOCK_OUTBOUND) != 0)
        writefd = &fd;

    return select (super_data->socket_handle + 1, readfd, writefd, NULL, &timeout);
}

/* --------------------------------------------------------------------------------------------- */
/**
 * Getting information about a symbolic link.
 *
 * @param vpath   path to file, directory or symbolic link
 * @param buf     buffer for store stat-info
 * @param mcerror pointer to error object
 * @return 0 if success, negative value otherwise
 */

int
sftpfs_lstat (const vfs_path_t * vpath, struct stat *buf, GError ** mcerror)
{
    const vfs_path_element_t *path_element;
    sftpfs_super_data_t *super_data;
    LIBSSH2_SFTP_ATTRIBUTES attrs;
    int res;

    res = _sftpfs_stat (&super_data, &path_element, vpath, mcerror,
                        LIBSSH2_SFTP_LSTAT, &attrs);

    if (res == -1 || res == EACCES || res == ENOENT)
        return res;

    _sftpfs_attr_to_buf(buf, &attrs);

    return 0;
}

/* --------------------------------------------------------------------------------------------- */
/**
 * Getting information about a file or directory.
 *
 * @param vpath   path to file or directory
 * @param buf     buffer for store stat-info
 * @param mcerror pointer to error object
 * @return 0 if success, negative value otherwise
 */

int
sftpfs_stat (const vfs_path_t * vpath, struct stat *buf, GError ** mcerror)
{
    const vfs_path_element_t *path_element;
    sftpfs_super_data_t *super_data;
    LIBSSH2_SFTP_ATTRIBUTES attrs;
    int res;

    res = _sftpfs_stat (&super_data, &path_element, vpath, mcerror,
                        LIBSSH2_SFTP_STAT, &attrs);

    if (res == -1 || res == EACCES || res == ENOENT)
        return res;

    buf->st_nlink = 1;

    _sftpfs_attr_to_buf(buf, &attrs);

    return 0;
}

/* --------------------------------------------------------------------------------------------- */
/**
 * Read value of a symbolic link.
 *
 * @param vpath   path to file or directory
 * @param buf     buffer for store stat-info
 * @param size    buffer size
 * @param mcerror pointer to error object
 * @return 0 if success, negative value otherwise
 */

int
sftpfs_readlink (const vfs_path_t * vpath, char *buf, size_t size, GError ** mcerror)
{
    const vfs_path_element_t *path_element;
    sftpfs_super_data_t *super_data;
    int res;

    if (_sftpfs_op_init(&super_data, &path_element, vpath, mcerror) != 0)
        return -1;

    do
    {
        const char *fixfname;

        fixfname = sftpfs_fix_filename (path_element->path);

        res = libssh2_sftp_readlink (super_data->sftp_session, fixfname,
                                     buf, size);
        if (res >= 0)
            break;

        if (_waitsocket_or_error(super_data, res,mcerror, NULL) != 0)
            return -1;
    }
    while (res == LIBSSH2_ERROR_EAGAIN);

    return res;
}

/* --------------------------------------------------------------------------------------------- */
/**
 * Create symlink to file or directory
 *
 * @param vpath1  path to file or directory
 * @param vpath2  path to symlink
 * @param mcerror pointer to error object
 * @return 0 if success, negative value otherwise
 */

int
sftpfs_symlink (const vfs_path_t * vpath1, const vfs_path_t * vpath2, GError ** mcerror)
{
    const vfs_path_element_t *path_element1;
    const vfs_path_element_t *path_element2;
    sftpfs_super_data_t *super_data;
    char *tmp_path;
    int res;

    if (_sftpfs_op_init(&super_data, &path_element2, vpath2, mcerror) != 0)
        return -1;

    tmp_path = g_strdup_printf ("%c%s", PATH_SEP, path_element2->path);
    path_element1 = vfs_path_get_by_index (vpath1, -1);

    do
    {
        const char *fixfname;

        fixfname = sftpfs_fix_filename (path_element1->path);

        res = libssh2_sftp_symlink_ex (super_data->sftp_session, fixfname,
                                       sftpfs_filename_buffer->len, tmp_path,
                                       strlen (tmp_path), LIBSSH2_SFTP_SYMLINK);
        if (res >= 0)
            break;

        if (_waitsocket_or_error(super_data, res,mcerror, tmp_path) != 0)
            return -1;
    }
    while (res == LIBSSH2_ERROR_EAGAIN);
    g_free (tmp_path);

    return 0;
}

/* --------------------------------------------------------------------------------------------- */
/**
 * Changes the permissions of the file.
 *
 * @param vpath   path to file or directory
 * @param mode    mode (see man 2 open)
 * @param mcerror pointer to error object
 * @return 0 if success, negative value otherwise
 */

int
sftpfs_chmod (const vfs_path_t * vpath, mode_t mode, GError ** mcerror)
{
    const vfs_path_element_t *path_element;
    sftpfs_super_data_t *super_data;
    LIBSSH2_SFTP_ATTRIBUTES attrs;
    int res;

    res = _sftpfs_stat(&super_data, &path_element, vpath, mcerror,
                       LIBSSH2_SFTP_LSTAT, &attrs);

    if (res == -1 || res == EACCES || res == ENOENT)
        return res;

    attrs.permissions = mode;

    do
    {
        const char *fixfname;

        fixfname = sftpfs_fix_filename (path_element->path);

        res = libssh2_sftp_stat_ex (super_data->sftp_session, fixfname,
                                    sftpfs_filename_buffer->len,
                                    LIBSSH2_SFTP_SETSTAT, &attrs);
        if (res >= 0)
            break;

        if (_is_sftp_proto_error(super_data, res, LIBSSH2_FX_FAILURE))
        {
            res = 0;  /* need something like ftpfs_ignore_chattr_errors */
            break;
        }

        if (_is_sftp_proto_error(super_data, res, LIBSSH2_FX_NO_SUCH_FILE))
            return ENOENT;

        if (_waitsocket_or_error(super_data, res,mcerror, NULL) != 0)
            return -1;
    }
    while (res == LIBSSH2_ERROR_EAGAIN);

    return res;
}

/* --------------------------------------------------------------------------------------------- */
/**
 * Delete a name from the file system.
 *
 * @param vpath   path to file or directory
 * @param mcerror pointer to error object
 * @return 0 if success, negative value otherwise
 */

int
sftpfs_unlink (const vfs_path_t * vpath, GError ** mcerror)
{
    const vfs_path_element_t *path_element;
    sftpfs_super_data_t *super_data;
    int res;

    if (_sftpfs_op_init(&super_data, &path_element, vpath, mcerror) != 0)
        return -1;

    do
    {
        const char *fixfname;

        fixfname = sftpfs_fix_filename (path_element->path);

        res = libssh2_sftp_unlink_ex (super_data->sftp_session, fixfname,
                                      sftpfs_filename_buffer->len);
        if (res >= 0)
            break;

        if (_waitsocket_or_error(super_data, res,mcerror, NULL) != 0)
            return -1;
    }
    while (res == LIBSSH2_ERROR_EAGAIN);

    return res;
}

/* --------------------------------------------------------------------------------------------- */
/**
 * Rename a file, moving it between directories if required.
 *
 * @param vpath1   path to source file or directory
 * @param vpath2   path to destination file or directory
 * @param mcerror  pointer to error object
 * @return 0 if success, negative value otherwise
 */

int
sftpfs_rename (const vfs_path_t * vpath1, const vfs_path_t * vpath2, GError ** mcerror)
{
    const vfs_path_element_t *path_element1;
    const vfs_path_element_t *path_element2;
    sftpfs_super_data_t *super_data;
    char *tmp_path;
    int res;

    if (_sftpfs_op_init(&super_data, &path_element2, vpath2, mcerror) != 0)
        return -1;

    tmp_path = g_strdup_printf ("%c%s", PATH_SEP, path_element2->path);
    path_element1 = vfs_path_get_by_index (vpath1, -1);

    do
    {
        const char *fixfname;

        fixfname = sftpfs_fix_filename (path_element1->path);

        res = libssh2_sftp_rename_ex (super_data->sftp_session, fixfname,
                                      sftpfs_filename_buffer->len, tmp_path,
                                      strlen (tmp_path), LIBSSH2_SFTP_SYMLINK);

        if (res >= 0)
            break;

        if (_waitsocket_or_error(super_data, res,mcerror, tmp_path) != 0)
            return -1;
    }
    while (res == LIBSSH2_ERROR_EAGAIN);
    g_free (tmp_path);

    return 0;
}

/* --------------------------------------------------------------------------------------------- */
