/*
	path and files.
	$Id: mulk pf.h 1413 2025-04-26 Sat 18:55:59 kt $
*/

#include "xbarray.h"

#define PF_ERROR 0
#define PF_NONE 1
#define PF_FILE 2
#define PF_DIR 4
#define PF_OTHER 8
#define PF_READABLE 16
#define PF_WRITABLE 32

#define PF_READABLEFILE (PF_FILE|PF_READABLE)

struct pf_stat {
#if U64_P
	uint32_t mtime;
	uint32_t size;
#else
	uint64_t mtime;
	uint64_t size;
#endif
};

#if PF_OPEN_P
extern FILE *pf_open(char *fn,char *mode);
#endif

extern int pf_lock(FILE *fp,int lock_p);
extern int pf_stat(char *fn,struct pf_stat *statbuf);
extern void pf_exepath(char *argv0,struct xbarray *path);
#if U64_P
extern int pf_utime(char *fn,uint32_t mtime);
#else
extern int pf_utime(char *fn,uint64_t mtime);
#endif
extern char *pf_getcwd(void); /*return malloc chunk*/
extern int pf_readdir(char *path,struct xbarray *xba);
extern int pf_mkdir(char *pn);
extern int pf_remove(char *fn);
extern int pf_chdir(char *pn);
