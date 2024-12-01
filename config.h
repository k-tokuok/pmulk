/*
	configure.
	$Id: mulk config.h 1318 2024-12-01 Sun 14:28:50 kt $
*/

/* archtecture and compiler */

/** FPOS_TYPE */
#define FPOS_LONG 0 /* use long -- fseek/ftell */
#define FPOS_OFFT 1 /* use off_t -- fseeko/ftello */
#define FPOS_I64 2 /* use __int64 -- _fseeki64/_ftelli64 */

/** unix like system */
#define OS_UNIX 0

/*** linux */
#ifdef __linux
#define OS_CODE OS_UNIX
#define FPOS_TYPE FPOS_OFFT
#ifdef ANDROID
#define XCONSOLE_P TRUE
#endif
#endif

/*** cygwin */
#ifdef __CYGWIN__
#define OS_CODE OS_UNIX
#define FPOS_TYPE FPOS_OFFT
#endif

/*** macosx */
#ifdef __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__
#define OS_CODE OS_UNIX
#endif

/*** minix */
#ifdef __minix
#define OS_CODE OS_UNIX
#endif

/*** freebsd */
#ifdef __FreeBSD__
#define OS_CODE OS_UNIX
#endif

/*** netbsd */
#ifdef __NetBSD__
#define OS_CODE OS_UNIX
#endif

/*** illumos (openindiana) */
#ifdef __illumos__
#define OS_CODE OS_UNIX
#endif

/** windows */
#define OS_WINDOWS 1

#ifdef __MINGW32__
#define OS_CODE OS_WINDOWS
#define FPOS_TYPE FPOS_I64
#endif

#ifdef _MSC_VER
#define OS_CODE OS_WINDOWS
#define _CRT_SECURE_NO_WARNINGS
#pragma warning(disable:4267)
#define UNDERSCORE_PUTENV_P TRUE
#define FPOS_TYPE FPOS_I64
#endif

#ifdef __BORLANDC__
#define OS_CODE OS_WINDOWS
#if __BORLANDC__/0x10==0x55
#define BORLANDC_55
#define INCLUDE_INTTYPES_P FALSE
#pragma warn -8057
#pragma warn -8064
#endif
#endif

#ifdef __DMC__
#define OS_CODE OS_WINDOWS
#endif

#ifdef __POCC__
#define OS_CODE OS_WINDOWS
#endif

/** msdos/freedos with dosextender */
#define OS_DOS 2
#ifdef __DJGPP__
#define OS_CODE OS_DOS
#define INCLUDE_INTTYPES_P FALSE
#define INTR_CHECK_P TRUE
#define DOS_BIOSKBD_P TRUE
#define VSPRINTF_P TRUE
#endif

#ifdef __WATCOMC__
#define OS_CODE OS_DOS
#define INTR_CHECK_P TRUE
#endif

/** gcc oriented */
#ifdef __GNUC__
#define GCC_NORETURN __attribute__((noreturn))
#endif

#ifndef GCC_NORETURN
#define GCC_NORETURN
#endif

/* flags */
#define UNIX_P (OS_CODE==OS_UNIX)
#define WINDOWS_P (OS_CODE==OS_WINDOWS)
#define DOS_P (OS_CODE==OS_DOS)

#define PF_OPEN_P (!UNIX_P)

#ifndef XCONSOLE_P
#define XCONSOLE_P FALSE
#endif

#ifndef INCLUDE_INTTYPES_P
#define INCLUDE_INTTYPES_P TRUE
#endif

#ifndef U64_P
/* for compiler missing 64 bit integer */
#define U64_P FALSE
#endif

#ifndef INTR_CHECK_P
#define INTR_CHECK_P FALSE
#endif

#ifndef XFT_P
#define XFT_P FALSE
#endif

#ifndef UNDERSCORE_PUTENV_P
#define UNDERSCORE_PUTENV_P FALSE
#endif

#ifndef VSPRINTF_P
/* for missing vsnprintf */
#define VSPRINTF_P FALSE
#endif

#ifndef INTER_ISFINITE_P
#define INTER_ISFINITE_P FALSE
#endif

#ifndef FPOS_TYPE
#define FPOS_TYPE FPOS_LONG
#endif
#if FPOS_TYPE==FPOS_OFFT
#define _FILE_OFFSET_BITS 64
#endif

/* options for mulk */

#define K 1024
#define DEFAULT_STACK_SIZE 2 /* * K CELL */

#define IP_POLLING_INTERVAL 16384 /* for gc/interrupt check */

#define GC_OLD_AMOUNT 256
#define GC_NEW_AMOUNT 256

#ifdef NDEBUG
#define TUNE_P TRUE
#else
#define TUNE_P FALSE
#endif

#define MACRO_OM_P_P TUNE_P
#define MACRO_SINT_P_P TUNE_P
#define MACRO_SINT_VAL_P TUNE_P
#define MACRO_SINT_P TUNE_P
#define MACRO_OM_SIZE_P TUNE_P

/* #define GC_LOG */
