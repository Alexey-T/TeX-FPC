/*========================================================================*\

Copyright (c) 1990-2004  Paul Vojta

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to
deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
PAUL VOJTA BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

NOTE:
	xdvi is based on prior work, as noted in the modification history
	in xdvi.c.

\*========================================================================*/
 /* helbig changed this file to make it work on Mac OS X */
 /* it defined XOPEN_SOURCE,  which causes NSIG to be not defined,
    which breaks signal.h included by event.c */

/*
 *	Written by Eric C. Cooper, CMU
 */

#ifndef	XDVI_H
#define	XDVI_H

/********************************
 *	The C environment	*
 *******************************/

#ifdef __hpux
/* On HP-UX 10.10 B and 20.10, compiling with _XOPEN_SOURCE + ..._EXTENDED
 * leads to poll() not realizing that a file descriptor is writable in psgs.c.
 */
#define	_HPUX_SOURCE	1
#else
#undef _XOPEN_SOURCE		/* needed because of imake */
#define	_XOPEN_SOURCE_EXTENDED	1
#define	__EXTENSIONS__	1	/* needed to get struct timeval on SunOS 5.5 */
#define	_SVID_SOURCE	1	/* needed to get S_IFLNK in glibc */
#define	_BSD_SOURCE	1	/* needed to get F_SETOWN in glibc-2.1.3 */
#endif

#include "config.h"

/* Some O/S dependent kludges. */
#ifdef _AIX
#define _ALL_SOURCE 1
#endif

/* If xmkmf is broken and there's a symlink from /usr/include/X11 to the right
 * place, then there will be no -I... argument on the cc command line for the
 * X include files.  Since gcc version 3 and higher sets __STDC__ to 0 when
 * including system header files on some platforms, we may end up with
 * NeedFunctionPrototypes set to 0 when it should be 1.  So, let's force the
 * issue.
 */

#if __STDC__ && !defined(FUNCPROTO)
# define FUNCPROTO (-1)
#endif

#if STDC_HEADERS
# include <stddef.h>
# include <stdlib.h>
	/* the following works around the wchar_t problem */
# include <X11/X.h>
# if HAVE_X11_XOSDEFS_H
#  include <X11/Xosdefs.h>
# endif
# ifdef X_NOT_STDC_ENV
#  undef X_NOT_STDC_ENV
#  undef X_WCHAR
#  include <X11/Xlib.h>
#  define X_NOT_STDC_ENV
# endif
#endif

#include <X11/Xlib.h>	/* include Xfuncs.h, if available */
#include <X11/Xutil.h>	/* needed for XDestroyImage */
#include <X11/Xos.h>

#if	XlibSpecificationRelease >= 5
#include <X11/Xfuncs.h>
#endif

#undef	TOOLKIT

#if XAW || MOTIF

#define	TOOLKIT	1
#include <X11/Intrinsic.h>
#if (defined(VMS) && (XtSpecificationRelease <= 4)) || defined(lint)
# include <X11/IntrinsicP.h>
#endif
#if MOTIF
# include <Xm/Xm.h>
# ifndef MOTIF_TIMERS	/* see comment in events.c */
#  define MOTIF_TIMERS (XmVERSION >= 2)
# endif
#endif

#else /* not TOOLKIT */

#define	XtNumber(arr)	(sizeof(arr)/sizeof(arr[0]))
#define	XtWindow(win)	(win)
typedef	unsigned long	Pixel;
typedef	char		Boolean;
typedef	unsigned int	Dimension;
#undef	BUTTONS
#undef	EXTRA_APP_DEFAULTS

#endif /* not TOOLKIT */

#if EXTRA_APP_DEFAULTS && !SELFAUTO
#define	SELFAUTO 1
#endif

#if SELFAUTO && !defined(DEFAULT_CONFIG_PATH)
#define	DEFAULT_CONFIG_PATH	\
		".:$SELFAUTOLOC:$SELFAUTODIR:$SELFAUTOPARENT:$SELFAUTODIR/share/texmf/web2c:$SELFAUTOPARENT/share/texmf/web2c:$SELFAUTODIR/texmf/web2c:$SELFAUTOPARENT/texmf/web2c:$TETEXDIR:$TEXMF/web2c"
#endif

#undef CFGFILE				/* no cheating */

#if defined(DEFAULT_CONFIG_PATH)
#define	CFGFILE	1
#endif

typedef	char		Bool3;		/* Yes/No/Maybe */

#define	True	1
#define	False	0
#define	Maybe	2

#ifdef	VMS
#include <string.h>
#define	index	strchr
#define	rindex	strrchr
#define	bzero(a, b)	(void) memset ((void *) (a), 0, (size_t) (b))
#define bcopy(a, b, c)  (void) memmove ((void *) (b), (void *) (a), (size_t) (c))
#endif

#include <stdio.h>
#include <setjmp.h>

#if HAVE_UNISTD_H
#include <unistd.h>
#endif

#if HAVE_DIRENT_H
# include <dirent.h>
# define NAMLEN(dirent) strlen((dirent)->d_name)
#else
# define dirent direct
# define NAMLEN(dirent) (dirent)->d_namlen
# if HAVE_SYS_NDIR_H
#  include <sys/ndir.h>
# endif
# if HAVE_SYS_DIR_H
#  include <sys/dir.h>
# endif
# if HAVE_NDIR_H
#  include <ndir.h>
# endif
#endif

#ifndef	NeedFunctionPrototypes
#if	__STDC__
#define	NeedFunctionPrototypes	1
#else	/* STDC */
#define	NeedFunctionPrototypes	0
#endif	/* STDC */
#endif	/* NeedFunctionPrototypes */

#if	NeedFunctionPrototypes
#define	ARGS(x)	x
#else
#define	ARGS(x)	()
#endif

#ifndef KPATHSEA

/* These macros munge function declarations to make them work in both
   cases.  The P?H macros are used for declarations, the P?C for
   definitions.  See <ansidecl.h> from the GNU C library.  P1H(void)
   also works for definitions of routines which take no args.  */

#if NeedFunctionPrototypes	/* Don't use __STDC__ here (gcc + SunOS 4) */

#define	P1H(p1) (p1)
#define	P2H(p1, p2) (p1, p2)

#define	P1C(t1,n1)(t1 n1)
#define	P2C(t1,n1, t2,n2)(t1 n1, t2 n2)
#define	P3C(t1,n1, t2,n2, t3,n3)(t1 n1, t2 n2, t3 n3)
#define	P4C(t1,n1, t2,n2, t3,n3, t4,n4)(t1 n1, t2 n2, t3 n3, t4 n4)

#else /* not NeedFunctionPrototypes */

#define	P1H(p1) ()
#define	P2H(p1, p2) ()

#define	P1C(t1,n1) (n1) t1 n1;
#define	P2C(t1,n1, t2,n2) (n1,n2) t1 n1; t2 n2;
#define	P3C(t1,n1, t2,n2, t3,n3) (n1,n2,n3) t1 n1; t2 n2; t3 n3;
#define	P4C(t1,n1, t2,n2, t3,n3, t4,n4) (n1,n2,n3,n4) \
		t1 n1; t2 n2; t3 n3; t4 n4;

#endif /* not NeedFunctionPrototypes */

#endif /* not KPATHSEA */

#ifndef	NeedWidePrototypes
#define	NeedWidePrototypes	NeedFunctionPrototypes
#endif

#ifndef	NeedVarargsPrototypes
#define	NeedVarargsPrototypes	NeedFunctionPrototypes
#endif

#if NeedVarargsPrototypes
#define	VARGS(x)	x
#else
#define	VARGS(x)	()
#endif

#ifndef	_XFUNCPROTOBEGIN
#define	_XFUNCPROTOBEGIN
#define	_XFUNCPROTOEND
#endif

#ifndef	_Xconst
#if	__STDC__
#define	_Xconst	const
#else	/* STDC */
#define	_Xconst
#endif	/* STDC */
#endif	/* _Xconst */

#ifndef	VOLATILE
#if	__STDC__ || (defined(__stdc__) && defined(__convex__))
#define	VOLATILE	volatile
#else
#define	VOLATILE	/* nothing */
#endif
#endif

#ifndef	NORETURN
# if __GNUC__ > 2 || (__GNUC__ == 2 && __GNUC_MINOR__ >= 5)
#  define NORETURN	__attribute__((__noreturn__))
# else
#  define NORETURN	/* nothing */
# endif
#endif

#ifndef UNUSED
# if __GNUC__ > 2 || (__GNUC__ == 2 && __GNUC_MINOR__ >= 95)
#  define UNUSED	__attribute__((__unused__))
# else
#  define UNUSED	/* nothing */
# endif
#endif

#ifndef	OPEN_MODE
#ifndef	VMS
#define	OPEN_MODE	"r"
#else	/* VMS */
#define	OPEN_MODE	"r", "ctx=stm"
#endif	/* VMS */
#endif	/* OPEN_MODE */

#ifndef	VMS
#define	OPEN_MODE_ARGS	_Xconst char *
#else
#define	OPEN_MODE_ARGS	_Xconst char *, _Xconst char *
#endif

#define	Printf	(void) printf
#define	Puts	(void) puts
#define	Fprintf	(void) fprintf
#define	Sprintf	(void) sprintf
#define	Fseek	(void) fseek
#define	Fread	(void) fread
#define	Fputs	(void) fputs
#define	Putc	(void) putc
#define	Putchar	(void) putchar
#define	Fclose	(void) fclose
#define	Fflush	(void) fflush
#define	Strcat	(void) strcat
#define	Strcpy	(void) strcpy

/********************************
 *	 Types and data		*
 *******************************/

#ifndef	EXTERN
#define	EXTERN	extern
#define	INIT(x)
#endif

#define	MAXDIM		32767

typedef	unsigned char	ubyte;

#if	NeedWidePrototypes
typedef	unsigned int	wide_ubyte;
typedef	int		wide_bool;
#define	WIDENINT	(int)
#else
typedef	ubyte		wide_ubyte;
typedef	Boolean		wide_bool;
#define	WIDENINT
#endif

#if defined(MAKETEXPK) && !defined(MKTEXPK)
#define	MKTEXPK 1
#endif

/*
 *	pixel_conv is currently used only for converting absolute positions
 *	to pixel values; although normally it should be
 *		((int) ((x) / shrink_factor + (1 << 15) >> 16)),
 *	the rounding is achieved instead by moving the constant 1 << 15 to
 *	PAGE_OFFSET in dvi-draw.c.
 */
#define	pixel_conv(x)		((int) ((x) / shrink_factor >> 16))
#define	pixel_round(x)		((int) ROUNDUP(x, shrink_factor << 16))
#define	spell_conv0(n, f)	((long) (n * f))
#define	spell_conv(n)		spell_conv0(n, dimconv)

#define	BMUNIT			unsigned BMTYPE
#define	BMBITS			(8 * BMBYTES)

#define	ADD(a, b)	((BMUNIT *) (((char *) a) + b))
#define	SUB(a, b)	((BMUNIT *) (((char *) a) - b))

extern	BMUNIT	bit_masks[BMBITS + 1];

struct frame {
	struct framedata {
		long dvi_h, dvi_v, w, x, y, z;
		int pxl_v;
	} data;
	struct frame *next, *prev;
};

#ifndef	TEXXET
typedef	long	(*set_char_proc) ARGS((wide_ubyte));
#else
typedef	void	(*set_char_proc) ARGS((wide_ubyte, wide_ubyte));
#endif

typedef	void	(*home_proc) ARGS((wide_bool));

struct drawinf {	/* this information is saved when using virtual fonts */
	struct framedata data;
	struct font	*fontp;
	set_char_proc	set_char_p;
	int		tn_table_len;
	struct font	**tn_table;
	struct tn	*tn_head;
	ubyte		*pos, *end;
	struct font	*virtual;
#ifdef	TEXXET
	int		dir;
#endif
};

EXTERN	struct drawinf	currinf;

/* entries below with the characters 'dvi' in them are actually stored in
   scaled pixel units */

#define DVI_H   currinf.data.dvi_h
#define PXL_H   pixel_conv(currinf.data.dvi_h)
#define DVI_V   currinf.data.dvi_v
#define PXL_V   currinf.data.pxl_v
#define WW      currinf.data.w
#define XX      currinf.data.x
#define YY      currinf.data.y
#define ZZ      currinf.data.z
#define ROUNDUP(x,y) (((x)+(y)-1)/(y))

EXTERN	int	current_page;
EXTERN	int	total_pages;
EXTERN	int	pageno_correct	INIT(1);
EXTERN	long	magnification;
EXTERN	double	dimconv;
EXTERN	double	tpic_conv;
EXTERN	int	n_files_left	INIT(32767);	/* for LRU closing of fonts */
EXTERN	unsigned int	page_w, page_h;

#if	defined(GS_PATH) && !defined(PS_GS)
#define	PS_GS	1
#endif

#if	defined(PS_DPS) || defined(PS_NEWS) || defined(PS_GS)
#define	PS	1
#else
#define	PS	0
#endif

EXTERN	int	scanned_page;		/* last page prescanned */

#if PS
EXTERN	int	scanned_page_ps;	/* last page scanned for PS specials */
EXTERN	int	scanned_page_ps_bak;	/* save the above if PS is turned off */
#endif

#if COLOR
EXTERN	int	scanned_page_color;	/* last page scanned for color spcls */
#endif

EXTERN	int	scanned_page_reset;	/* number to reset the above to */

/*
 * The following is set when we're prescanning before opening up the windows,
 * and we hit a PostScript header file.  We can't start up gs until we get
 * a window to associate the process to, so we have to prescan twice.
 */
#if PS_GS
EXTERN	Boolean	gs_postpone_prescan	INIT(False);
#endif

/*
 * Per-page data in DVI file, indexed by page number - 1.
 * Offset is initialized in prepare_pages().
 * Page size is initialized while prescanning.
 */
struct per_page {
	long	offset;
	unsigned int	pw, ph;	/* page size */
	unsigned int	ww, wh;	/* window size */
};

EXTERN	struct per_page		*page_info;

/*
 * Set if the -paper option overrides papersize specials.
 */
EXTERN	Boolean			ignore_papersize_specials	INIT(False);

/*
 * Mechanism for reducing repeated warning about specials, lost characters, etc.
 */
EXTERN	Boolean	warn_spec_now;

/*
 * If we're in the middle of a PSFIG special.
 */
EXTERN	Boolean	psfig_begun	INIT(False);

/*
 * Page on which to draw box from forward source special searching.
 */
EXTERN	int	source_fwd_box_page	INIT(-1);	/* -1 means no box */

/*
 * Information on deferred source operation.  See do_pages() for meaning.
 */
EXTERN	_Xconst char	*source_forward_string	INIT(NULL);
EXTERN	int		source_reverse_x, source_reverse_y;
EXTERN	int		source_show_all;


/*
 * Bitmap structure for raster ops.
 */
struct bitmap {
	unsigned short	w, h;		/* width and height in pixels */
	short		bytes_wide;	/* scan-line width in bytes */
	char		*bits;		/* pointer to the bits */
};

/*
 * Per-character information.
 * There is one of these for each character in a font (raster fonts only).
 * All fields are filled in at font definition time,
 * except for the bitmap, which is "faulted in"
 * when the character is first referenced.
 */
struct glyph {
	long addr;		/* address of bitmap in font file */
	long dvi_adv;		/* DVI units to move reference point */
	short x, y;		/* x and y offset in pixels */
	struct bitmap bitmap;	/* bitmap for character */
	short x2, y2;		/* x and y offset in pixels (shrunken bitmap) */
#if GREY
# if COLOR
	struct fgrec *fg;	/* fgrec for which these pixmaps are valid */
# endif
	XImage *image2;
	char *pixmap2;
	char *pixmap2_t;
#endif /* GREY */
	struct bitmap bitmap2;	/* shrunken bitmap for character */
};

/*
 * Per-character information for virtual fonts
 */
struct macro {
	ubyte	*pos;		/* address of first byte of macro */
	ubyte	*end;		/* address of last+1 byte */
	long	dvi_adv;	/* DVI units to move reference point */
	Boolean	free_me;	/* if free(pos) should be called when */
				/* freeing space */
};

/*
 * The layout of a font information block.
 * There is one of these for every loaded font or magnification thereof.
 * Duplicates are eliminated:  this is necessary because of possible recursion
 * in virtual fonts.
 *
 * Also note the strange units.  The design size is in 1/2^20 point
 * units (also called micro-points), and the individual character widths
 * are in the TFM file in 1/2^20 ems units, i.e., relative to the design size.
 *
 * We then change the sizes to SPELL units (unshrunk pixel / 2^16).
 */

#define	NOMAGSTP (-29999)

typedef	void (*read_char_proc) ARGS((struct font *, wide_ubyte));

struct font {
	struct font *next;		/* link to next font info block */
	char *fontname;			/* name of font */
	float fsize;			/* size information (dots per inch) */
	int magstepval;			/* magstep number * two, or NOMAGSTP */
	FILE *file;			/* open font file or NULL */
	char *filename;			/* name of font file */
	long checksum;			/* checksum */
	unsigned short timestamp;	/* for LRU management of fonts */
	ubyte flags;			/* flags byte (see values below) */
	ubyte maxchar;			/* largest character code */
	double dimconv;			/* size conversion factor */
	set_char_proc set_char_p;	/* proc used to set char */
		/* these fields are used by (loaded) raster fonts */
	read_char_proc read_char;	/* function to read bitmap */
	struct glyph *glyph;
		/* these fields are used by (loaded) virtual fonts */
	struct font **vf_table;		/* list of fonts used by this vf */
	struct tn *vf_chain;		/* ditto, if TeXnumber >= VFTABLELEN */
	struct font *first_font;	/* first font defined */
	struct macro *macro;
		/* I suppose the above could be put into a union, but we */
		/* wouldn't save all that much space. */
};

#define	FONT_IN_USE	1	/* used for housekeeping */
#define	FONT_LOADED	2	/* if font file has been read */
#define	FONT_VIRTUAL	4	/* if font is virtual */

#define	TNTABLELEN	30	/* length of TeXnumber array (dvi file) */
#define	VFTABLELEN	5	/* length of TeXnumber array (virtual fonts) */

struct tn {
	struct tn *next;		/* link to next TeXnumber info block */
	int TeXnumber;			/* font number (in DVI file) */
	struct font *fontp;		/* pointer to the rest of the info */
};

EXTERN	struct font	*tn_table[TNTABLELEN];
EXTERN	struct font	*font_head	INIT(NULL);
EXTERN	struct tn	*tn_head	INIT(NULL);
EXTERN	ubyte		maxchar;
EXTERN	unsigned short	current_timestamp INIT(0);

/*
 *	Command line flags.
 */

extern	struct _resource {
#if TOOLKIT && CFGFILE
	_Xconst char	*progname;
#endif
#if TOOLKIT
	int		shrinkfactor;
	_Xconst char	*main_translations;
	_Xconst char	*wheel_translations;
	int		dvips_hang;
	int		dvips_fail_hang;
#endif
	int		wheel_unit;
	int		_density;
#ifdef	GREY
	float		_gamma;
#endif
	int		_pixels_per_inch;
	_Xconst	char	*sidemargin;
	_Xconst	char	*topmargin;
	_Xconst	char	*xoffset;
	_Xconst	char	*yoffset;
	_Xconst	char	*paper;
	_Xconst	char	*_alt_font;
#ifdef MKTEXPK
	Boolean		makepk;
#endif
	_Xconst	char	*mfmode;
	_Xconst char	*editor;
	_Xconst char	*src_pos;
	Boolean		src_fork;
	Boolean		_list_fonts;
	Boolean		reverse;
	Boolean		_warn_spec;
	Boolean		_hush_chars;
	Boolean		_hush_chk;
	Boolean		safer;
#if defined(VMS) || !defined(TOOLKIT)
	_Xconst	char	*fore_color;
	_Xconst	char	*back_color;
#endif
	Pixel		_fore_Pixel;
	Pixel		_back_Pixel;
#ifdef TOOLKIT
	Pixel		_brdr_Pixel;
	Pixel		_hl_Pixel;
	Pixel		_cr_Pixel;
#endif
	_Xconst	char	*icon_geometry;
	Boolean		keep_flag;
	Boolean		copy;
	Boolean		thorough;
#if PS
	/* default is to use DPS, then NEWS, then GhostScript;
	 * we will figure out later on which one we will use */
	Boolean		_postscript;
	Boolean		allow_shell;
#ifdef	PS_DPS
	Boolean		useDPS;
#endif
#ifdef	PS_NEWS
	Boolean		useNeWS;
#endif
#ifdef	PS_GS
	Boolean		useGS;
	Boolean		gs_safer;
	Boolean		gs_alpha;
	_Xconst	char	*gs_path;
	_Xconst	char	*gs_palette;
#endif
#endif	/* PS */
	Boolean		prescan;
	_Xconst	char	*debug_arg;
	Boolean		version_flag;
#if BUTTONS
	Boolean		expert;
	_Xconst char	*button_translations;
	int		shrinkbutton[9];
	Dimension	btn_side_spacing;
	Dimension	btn_top_spacing;
	Dimension	btn_between_spacing;
	Dimension	btn_between_extra;
	Dimension	btn_border_width;
#endif
	_Xconst	char	*mg_arg[5];
#if COLOR
	Boolean		_use_color;
#endif
#ifdef	GREY
	Boolean		_use_grey;
	Bool3		install;
#endif
#if TOOLKIT
	_Xconst char	*dvips_path;
#endif
} resource;

/* As a convenience, we define the field names without leading underscores
 * to point to the field of the above record.  Here are the global ones;
 * the local ones are defined in each module.  */

#define	density		resource._density
#define	pixels_per_inch	resource._pixels_per_inch
#define	alt_font	resource._alt_font
#define	list_fonts	resource._list_fonts
#define	warn_spec	resource._warn_spec
#define	hush_chars	resource._hush_chars
#define	hush_chk	resource._hush_chk
#if COLOR
#define	use_color	resource._use_color
#endif
#ifdef  GREY
#define	use_grey	resource._use_grey
#endif

#ifndef TOOLKIT
EXTERN	Pixel		brdr_Pixel;
#endif

#if GREY
EXTERN	Pixel		plane_masks[4];
#endif

#if GREY || COLOR
EXTERN	XColor		color_data[2];
#define	fore_color_data		color_data[0]
#define	back_color_data		color_data[1]
#endif

#if COLOR

struct rgb {
	unsigned short	r, g, b;
};

struct pagecolor {
	struct rgb	bg;
	unsigned int	stacksize;
	_Xconst struct rgb *colorstack;
};

/* Information on background color and initial color stack for each page.  */
EXTERN	struct pagecolor	*page_colors	INIT(NULL);

/* The initial color stack is gotten from the pagecolor record for a page.  */
EXTERN	_Xconst struct rgb	*color_bottom;
EXTERN	unsigned int		color_bot_size;	/* number of entries */

/* Additions to the runtime color stack on a given page are stored in a linked
   list.  "struct colorframe" is defined in special.c.  */
EXTERN	struct colorframe	*rcs_top;

/* Color states.  */
EXTERN	struct rgb	fg_initial;	/* Initial fg (from command line) */
EXTERN	struct rgb	bg_initial;	/* Initial bg */

/*
 * For each (foreground, background) color pair, we keep information (depending
 * on the color model).  It is organized as a linked list of linked lists,
 * with background color more significant.
 */

struct bgrec {
	struct bgrec	*next;
	struct rgb	color;
	struct fgrec	*fg_head;
	Boolean		pixel_good;	/* if the pixel entry is valid */
	Pixel		pixel;
};

struct fgrec {
	struct fgrec	*next;
	struct rgb	color;
	Boolean		pixel_good;	/* if the pixel entry is valid */
	Pixel		pixel;
#if GREY
	Boolean		palette_good;	/* if the palette entry is valid */
	Pixel		palette[16];	/* non-TrueColor only */
#endif
};

EXTERN	struct bgrec	*bg_head	INIT(NULL);	/* head of list */
EXTERN	struct bgrec	*bg_current	INIT(NULL);	/* current bg value */
EXTERN	struct fgrec	*fg_current;			/* current fg value */
EXTERN	struct fgrec	*fg_active	INIT(NULL);	/* where the GCs are */

/* List of allocated colors (to be deallocated upon document change) */
EXTERN	Pixel		*color_list;			/* list of colors */
EXTERN	unsigned int	color_list_len	INIT(0);	/* current len of list*/
EXTERN	unsigned int	color_list_max	INIT(0);	/* allocated size */

/* Whether the color situation has been warned about.  */
EXTERN	Boolean		color_warned	INIT(False);

/* Cursor color (for XRecolorCursor).  */
extern	XColor		cr_Color;

#endif /* COLOR */

extern	struct	mg_size_rec {
	int		w;
	int		h;
}
	mg_size[5];

EXTERN	int		debug		INIT(0);

#define	DBG_BITMAP	1
#define	DBG_DVI		2
#define	DBG_PK		4
#define	DBG_BATCH	8
#define	DBG_EVENT	16
#define	DBG_OPEN	32
#define	DBG_PS		64
#define	DBG_CLIENT	128
#define	DBG_ALL		(~DBG_BATCH)

EXTERN	int		offset_x, offset_y;
EXTERN	unsigned int	unshrunk_paper_w, unshrunk_paper_h;
EXTERN	unsigned int	unshrunk_page_w, unshrunk_page_h;

EXTERN	char		*dvi_name	INIT(NULL);	/* dvi file name */
EXTERN	FILE		*dvi_file;		/* user's file */
EXTERN	time_t		dvi_time;		/* last modification time */
EXTERN	ino_t		dvi_inode;		/* used for source specials */
EXTERN	unsigned char	*dvi_property;		/* for setting in window */
EXTERN	size_t		dvi_property_length;
#if TOOLKIT
EXTERN	Boolean		titles_are_stale INIT(True);
						/* replace icon/window titles */
#endif
EXTERN	_Xconst char	*prog;
EXTERN	int		bak_shrink;		/* last shrink factor != 1 */
EXTERN	Dimension	window_w, window_h;
EXTERN	XImage		*image;
EXTERN	int		backing_store;
EXTERN	int		home_x, home_y;

EXTERN	Display		*DISP;
EXTERN	Screen		*SCRN;
#if TOOLKIT
extern	XtActionsRec	Actions[];
extern	Cardinal	num_actions;
#endif
#if XAW
EXTERN	XtAccelerators	accels_cr, accels_cr_click;
#endif
#ifdef GREY
EXTERN	Visual		*our_visual;
EXTERN	unsigned int	our_depth;
EXTERN	Colormap	our_colormap;
#else
#define	our_depth	(unsigned int) DefaultDepthOfScreen(SCRN)
#define	our_visual	DefaultVisualOfScreen(SCRN)
#define	our_colormap	DefaultColormapOfScreen(SCRN)
#endif
EXTERN	GC		ruleGC;
EXTERN	GC		foreGC, highGC;
EXTERN	GC		foreGC2;
EXTERN	GC		copyGC;
EXTERN	Boolean		copy;

EXTERN	Cursor		redraw_cursor, ready_cursor, drag_cursor[3];

#if TOOLKIT
struct xdvi_action {
	struct xdvi_action *next;
	XtActionProc	proc;
	Cardinal	num_params;
	String		param;
};

struct wheel_acts {
	struct wheel_acts *next;
	Modifiers	mask;
	Modifiers	value;
	struct _LateBindings *late_bindings;
	unsigned int	button;
	struct xdvi_action *action;
};

EXTERN	struct wheel_acts	*wheel_actions;
#endif

#if MOTIF && BUTTONS
EXTERN	XtTranslations	wheel_trans_table	INIT(NULL);
#endif

#ifdef	GREY
EXTERN	Pixel		*pixeltbl;
EXTERN	Pixel		*pixeltbl_t;
#endif	/* GREY */

/*
 *	Flag values and masks for event_flags
 */

#define	EV_IDLE		(1<<0)	/* non-event */
#define	EV_CURSOR	(1<<1)	/* cursor needs to revert back to ready */
#define	EV_EXPOSE	(1<<2)	/* expose occurred somewhere */
#define	EV_MAG_MOVE	(1<<3)	/* magnifier moved */
#define	EV_MAG_GONE	(1<<4)	/* magnifier gone while being drawn */
#define	EV_ACK		(1<<5)	/* used internally */
#define	EV_SRC		(1<<6)	/* source special operation is pending */
#define	EV_NEWPAGE	(1<<7)	/* new page requested */
#define	EV_PS_TOGGLE	(1<<8)	/* PostScript toggled on or off */
#define	EV_NEWDOC	(1<<9)	/* new dvi file requested */
#define	EV_TERM		(1<<10)	/* quit */
#define	EV_MAXPLUS1	(1<<11)

#define	EV_GE_IDLE		(EV_MAXPLUS1 - EV_IDLE)
#define	EV_GT_IDLE		(EV_MAXPLUS1 - EV_CURSOR)
#define	EV_GE_CURSOR		(EV_MAXPLUS1 - EV_CURSOR)
#define	EV_GE_EXPOSE		(EV_MAXPLUS1 - EV_EXPOSE)
#define	EV_GE_MAG_MOVE		(EV_MAXPLUS1 - EV_MAG_MOVE)
#define	EV_GE_MAG_GONE		(EV_MAXPLUS1 - EV_MAG_GONE)
#define	EV_GE_ACK		(EV_MAXPLUS1 - EV_ACK)
#define	EV_GE_NEWPAGE		(EV_MAXPLUS1 - EV_NEWPAGE)
#define	EV_GE_PS_TOGGLE		(EV_MAXPLUS1 - EV_PS_TOGGLE)
#define	EV_GE_NEWDOC		(EV_MAXPLUS1 - EV_NEWDOC)
#define	EV_GE_TERM		(EV_MAXPLUS1 - EV_TERM)

#define	EV_NOWAIT		EV_GE_IDLE

EXTERN	unsigned int	ev_flags	INIT(EV_IDLE);
EXTERN	VOLATILE int	event_counter	INIT(0);
EXTERN	jmp_buf		canit_env;

struct	xchild {
	struct xchild	*next;		/* link to next in list */
	pid_t		pid;		/* pid of process, or 0 */
	Boolean		killable;	/* if can be killed with SIGKILL */
	void	(*proc) ARGS((int));	/* procedure to call */
};

struct	xio {
	struct xio	*next;		/* link to next in list */
	int		fd;		/* file descriptor */
	int		xio_events;	/* same as in struct pollfd (can't call
					   it events because poll.h on AIX
					   defines events to something else) */
#if HAVE_POLL
	struct pollfd	*pfd;
#endif
	void	(*read_proc) ARGS((void));	/* call to read */
	void	(*write_proc) ARGS((void));	/* call to write */
};

struct	xtimer {
	struct xtimer	*next;		/* link to next in chain */
	struct timeval	when;		/* when to call the routine */
	void	(*proc) ARGS((struct xtimer *));	/* procedure to call */
#if MOTIF_TIMERS
	XtTimerCallbackProc xt_proc;		/* additional data for Xm */
	XtPointer	closure;
#endif
};

#if MOTIF_TIMERS
# define TIMER_INIT(proc)	{NULL, {0, 0}, proc, NULL, NULL}
#else
# define TIMER_INIT(proc)	{NULL, {0, 0}, proc}
#endif

struct	WindowRec {
	Window		win;
	int		shrinkfactor;
	int		base_x, base_y;
	unsigned int	width, height;
	int	min_x, max_x, min_y, max_y;	/* for pending expose events */
};

extern	struct WindowRec mane, alt, currwin;
EXTERN	int		min_x, max_x, min_y, max_y;
EXTERN	Boolean		drawing_mag	INIT(False);

#define	shrink_factor	currwin.shrinkfactor

#if TOOLKIT
EXTERN	Widget		top_level	INIT(0);
EXTERN	Widget		vport_widget, draw_widget, clip_widget;
# if MOTIF
EXTERN	Widget		shrink_button[4];
EXTERN	Widget		x_bar, y_bar;	/* horizontal and vert. scroll bars */
# endif
# if BUTTONS
EXTERN	Widget		form_widget;
EXTERN	int		xtra_wid	INIT(0);
extern	_Xconst char	default_button_config[]; /* defined in events.c */
#  if XAW
EXTERN	Widget		panel_widget;
EXTERN	Cursor		panel_cursor	INIT(0);
#  endif
# endif
#else /* not TOOLKIT */
EXTERN	Window		top_level	INIT(0);

#define	BAR_WID		12	/* width of darkened area */
#define	BAR_THICK	15	/* gross amount removed */
#endif /* not TOOLKIT */

#if XAW
#define	WARN(t, s)	(void) warning_popup(s, "OK", NULL)
#define	WARN1(t, s, s1)	(void) warning_popup_long(s, "OK", NULL, s1)
#define	WARN2(t, s, s1, s2) (void) warning_popup_long(s, "OK", NULL, s1, s2)
#elif MOTIF
#define	WARN(t, s)	(void) warning_popup(s, t, NULL, NULL)
#define	WARN1(t, s, s1)	(void) warning_popup_long(s, t, NULL, NULL, s1)
#define	WARN2(t, s, s1, s2) (void) warning_popup_long(s, t, NULL, NULL, s1, s2)
#elif CC_K_AND_R
#define	WARN(t, s)	(void) fputs(s "\n", stderr)
#define	WARN1(t, s, s1)	(void) fprintf(stderr, s "\n", s1)
#else
#define	WARN(t, s)	(void) (fputs(s, stderr), putc('\n', stderr))
#define	WARN1(t, s, s1)	(void) (fprintf(stderr, s, s1), putc('\n', stderr))
#endif

/*
 * If a popup is popped up before the main window, then the main window is
 * likely to cover it.  So we have to postpone popping them up until after
 * realizing the main window.  It is not workable to pop them up immediately
 * and then raise them later, due to unpredictable window manager behavior.
 */

#if TOOLKIT
EXTERN	Boolean		postpone_popups		INIT(True);
EXTERN	size_t		n_init_popups		INIT(0);
EXTERN	Widget		*init_popups;
EXTERN	size_t		alloc_init_popups	INIT(0);
#endif

/*
 * Structure to use for status popups.
 */

#if TOOLKIT
struct status_popup {
	Widget	shell;
	Widget	label;
	int	expected_type;
	Boolean	popped;
	Boolean	spurious;
};
#endif

EXTERN	char	*ffline	INIT(NULL);	/* an array used by filefind to store */
					/* the file name being formed.  */
					/* It expands as needed. */
					/* Also used elsewhere.  */
EXTERN	size_t	ffline_len INIT(0);	/* current length of ffline[] */

/*
 *	Used by the geometry-scanning routines.
 *	It passes pointers to routines to be called at certain
 *	points in the dvi file, and other information.
 */

struct geom_info {
	void	(*geom_box)	ARGS((struct geom_info *,
				  long, long, long, long));
	void	(*geom_special)	ARGS((struct geom_info *, _Xconst char *));
	jmp_buf	done_env;
	void	*geom_data;
};

typedef	void	(*mouse_proc)	ARGS((XEvent *));
extern	void	null_mouse	ARGS((XEvent *));

EXTERN	mouse_proc	mouse_motion	INIT(null_mouse);
EXTERN	mouse_proc	mouse_release	INIT(null_mouse);

/* Used for source special lookup (forward search) and for window manager
   delete protocol (toolkit only).  */

#if XAW
EXTERN	Atom	atoms[5];
#elif MOTIF
EXTERN	Atom	atoms[4];
#else
EXTERN	Atom	atoms[3];
#endif

#define	ATOM_XDVI_WINDOWS	(atoms[0])
#define	ATOM_DVI_FILE		(atoms[1])
#define	ATOM_SRC_GOTO		(atoms[2])
#if TOOLKIT
#define	XA_WM_DELETE_WINDOW	(atoms[3])
#endif
#if XAW
#define	XA_WM_PROTOCOLS		(atoms[4])
#endif

#ifdef	SELFAUTO
EXTERN	_Xconst	char	*argv0;		/* argv[0] */
#endif

#if	PS

extern	struct psprocs	{
	void	(*toggle)	ARGS((void));
	void	(*destroy)	ARGS((void));
	void	(*interrupt)	ARGS((void));
	void	(*endpage)	ARGS((void));
	void	(*drawbegin)	ARGS((int, int, _Xconst char *));
	void	(*drawraw)	ARGS((_Xconst char *));
	void	(*drawfile)	ARGS((_Xconst char *, FILE *));
	void	(*drawend)	ARGS((_Xconst char *));
	void	(*beginheader)	ARGS((void));
	void	(*endheader)	ARGS((void));
	void	(*newdoc)	ARGS((void));
}	psp, no_ps_procs;

#endif	/* PS */

/********************************
 *	   Procedures		*
 *******************************/

_XFUNCPROTOBEGIN

extern	int	atopix ARGS((_Xconst char *, wide_bool));
#if TOOLKIT
extern	Bool	compile_action ARGS((_Xconst char *, struct xdvi_action **));
#endif
#if BUTTONS
extern	void	create_buttons ARGS((void));
#if XAW
extern	void	set_button_panel_height ARGS((XtArgVal));
#endif
#endif /* BUTTONS */
#if GREY
extern	void	init_plane_masks ARGS((void));
#endif
#if COLOR
extern	Pixel	alloc_color ARGS((_Xconst struct rgb *, Pixel));
extern	void	do_color_change ARGS((void));
#elif GREY
extern	void	init_pix ARGS((void));
#endif
extern	void	expose ARGS((struct WindowRec *, int, int,
		  unsigned int, unsigned int));
extern	void	home ARGS((wide_bool));
extern	void	reconfig ARGS((void));
#if TOOLKIT
extern	void	handle_resize ARGS((Widget, XtPointer, XEvent *, Boolean *));
extern	void	handle_expose ARGS((Widget, XtPointer, XEvent *, Boolean *));
extern	void	handle_property_change ARGS((Widget, XtPointer, XEvent *,
		  Boolean *));
#endif
#if XAW
extern	void	handle_messages ARGS((Widget, XtPointer, XEvent *, Boolean *));
#elif MOTIF
extern	void	handle_wm_delete ARGS((Widget, XtPointer, XtPointer));
#endif
extern	void	goto_page ARGS((int, home_proc));
#if MOTIF
extern	void	file_pulldown_callback ARGS((Widget, XtPointer, XtPointer));
extern	void	navigate_pulldown_callback ARGS((Widget, XtPointer, XtPointer));
extern	void	scale_pulldown_callback ARGS((Widget, XtPointer, XtPointer));
extern	void	set_shrink_factor ARGS((int));
extern	void	popdown_callback ARGS((Widget, XtPointer, XtPointer));
#endif
#if !TOOLKIT
extern	void	showmessage ARGS((_Xconst char *));
#endif
extern	void	set_chld ARGS((struct xchild *));
extern	void	clear_chld ARGS((struct xchild *));
extern	void	set_io ARGS((struct xio *));
extern	void	clear_io ARGS((struct xio *));
extern	void	set_timer ARGS((struct xtimer *, int));
extern	void	cancel_timer ARGS((struct xtimer *));
extern	unsigned int read_events ARGS((unsigned int));
extern	void	enable_intr ARGS((void));
extern	void	do_pages ARGS((void)) NORETURN;
#if XAW
extern	void	simple_popup ARGS((struct status_popup *, _Xconst char *,
		  XtCallbackProc));
extern	void	simple_popdown ARGS((struct status_popup *));
extern	void	do_popup ARGS((Widget));
extern	Widget	warning_popup ARGS((_Xconst char *, _Xconst char *,
		  XtCallbackProc));
extern	Widget	warning_popup_long VARGS((_Xconst char *, _Xconst char *,
		  XtCallbackProc, ...));
extern	void	Act_print ARGS((Widget, XEvent *, String *, Cardinal *));
extern	void	Act_open_dvi_file ARGS((Widget, XEvent *, String *,
		  Cardinal *));
#elif MOTIF
extern	void	simple_popup ARGS((struct status_popup *, _Xconst char *,
		  XtCallbackProc));
extern	void	simple_popdown ARGS((struct status_popup *));
extern	void	do_popup ARGS((Widget));
extern	Widget	warning_popup ARGS((_Xconst char *, int, _Xconst char *,
		  XtCallbackProc));
extern	Widget	warning_popup_long ARGS((_Xconst char *, int, _Xconst char *,
		  XtCallbackProc, ...));
extern	void	Act_print ARGS((Widget, XEvent *, String *, Cardinal *));
extern	void	Act_open_dvi_file ARGS((Widget, XEvent *, String *,
		  Cardinal *));
#endif
extern	void	reset_fonts ARGS((void));
#if COLOR
extern	void	reset_colors ARGS((void));
extern	void	full_reset_colors ARGS((void));
#endif
extern	void	realloc_font ARGS((struct font *, wide_ubyte));
extern	void	realloc_virtual_font ARGS((struct font *, wide_ubyte));
extern	Boolean	load_font ARGS((struct font *));
extern	struct font	*define_font ARGS((FILE *, wide_ubyte,
			struct font *, struct font **, unsigned int,
			struct tn **));
extern	void	init_page ARGS((void));
extern	Boolean	open_dvi_file ARGS((_Xconst char *));
extern	void	form_dvi_property ARGS((ino_t));
extern	void	init_dvi_file ARGS((void));
extern	void	set_dvi_property ARGS((void));
extern	Boolean	check_dvi_file ARGS((void));
extern	void	reload_dvi_file ARGS((void));
#ifndef	TEXXET
extern	long	set_char ARGS((wide_ubyte));
extern	long	load_n_set_char ARGS((wide_ubyte));
extern	long	set_vf_char ARGS((wide_ubyte));
#else
extern	void	set_char ARGS((wide_ubyte, wide_ubyte));
extern	void	load_n_set_char ARGS((wide_ubyte, wide_ubyte));
extern	void	set_vf_char ARGS((wide_ubyte, wide_ubyte));
#endif
extern	void	prescan ARGS((void));
extern	void	draw_page ARGS((void));
extern	void	source_reverse_search ARGS((int, int));
extern	void	source_special_show ARGS((wide_bool));
extern	void	source_forward_search ARGS((_Xconst char *));
#if	CFGFILE
extern	void	readconfig ARGS((void));
#endif
extern	void	init_font_open ARGS((void));
extern	FILE	*font_open ARGS((_Xconst char *, char **, double, int *, int,
			char **));
#if	PS
extern	void	ps_clear_cache ARGS((void));
extern	void	ps_destroy ARGS((void));
#endif
extern	void	init_prescan ARGS((void));
#if COLOR
extern	void	scan_color_eop ARGS((void));
extern	void	set_fg_color ARGS((_Xconst struct rgb *));
#endif
extern	void	applicationDoSpecial ARGS((char *));
extern	void	scan_special ARGS((char *));
extern	void	geom_do_special ARGS((struct geom_info *, char *, double));
extern	void	xdvi_exit ARGS((int)) NORETURN;
extern	void	oops VARGS((_Xconst char *, ...)) NORETURN;
#ifndef KPATHSEA
extern	void	*xmalloc ARGS((unsigned));
extern	void	*xrealloc ARGS((void *, unsigned));
extern	char	*xstrdup ARGS((_Xconst char *));
extern	char	*xmemdup ARGS((_Xconst char *, size_t));
#endif
#if TOOLKIT && !HAVE_STRERROR && !defined strerror
extern	char	*strerror ARGS((int));
#endif
extern	void	expandline ARGS((size_t));
extern	void	alloc_bitmap ARGS((struct bitmap *));
#ifndef KPATHSEA
extern	void	xputenv ARGS((_Xconst char *, _Xconst char *));
#endif
extern	int	memicmp ARGS((_Xconst char *, _Xconst char *, size_t));
extern	FILE	*xfopen ARGS((_Xconst char *, OPEN_MODE_ARGS));
#if XAW
extern	int	xopen ARGS((_Xconst char *, int));
#endif
extern	int	xpipe ARGS((int *));
extern	DIR	*xopendir ARGS((_Xconst char *));
extern	_Xconst	struct passwd *ff_getpw ARGS((_Xconst char **, _Xconst char *));
extern	unsigned long	num ARGS((FILE *, int));
extern	long	snum ARGS((FILE *, int));
extern	size_t	property_get_data ARGS((Window, Atom, unsigned char **,
		  int (*x_get_property) (Display *, Window, Atom, long,
		  long, Bool, Atom, Atom *, int *, unsigned long *,
		  unsigned long *, unsigned char **)));
#if PS
extern	int	xdvi_temp_fd ARGS((char **));
#endif
extern	void	prep_fd ARGS((int, wide_bool));
extern	void	read_PK_index ARGS((struct font *, wide_bool));
extern	void	read_GF_index ARGS((struct font *, wide_bool));
extern	void	read_VF_index ARGS((struct font *, wide_bool));

#if	PS
extern	void	ps_init_paths ARGS((void));
extern	void	drawbegin_none ARGS((int, int, _Xconst char *));
extern	void	draw_bbox ARGS((void));
extern	void	NullProc ARGS((void));
#ifdef	PS_DPS
extern	Boolean	initDPS ARGS((void));
#endif
#ifdef	PS_NEWS
extern	Boolean	initNeWS ARGS((void));
#endif
#ifdef	PS_GS
extern	Boolean	initGS ARGS((void));
extern	void	gs_resume_prescan ARGS((void));
#endif
#endif	/* PS */

_XFUNCPROTOEND

#define one(fp)		((unsigned char) getc(fp))
#define sone(fp)	((long) one(fp))
#define two(fp)		num (fp, 2)
#define stwo(fp)	snum(fp, 2)
#define four(fp)	num (fp, 4)
#define sfour(fp)	snum(fp, 4)

#endif	/* XDVI_H */
