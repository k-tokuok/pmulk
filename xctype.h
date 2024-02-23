/*
	xc character type.
	$Id: mulk xctype.h 406 2020-04-19 Sun 11:29:54 kt $
*/

extern int sjis_trail_size(int ch);
extern int sjis_mblead_p(int ch);
extern int sjis_mbtrail_p(int ch);

extern int utf8_trail_size(int ch);
extern int utf8_mblead_p(int ch);
extern int utf8_mbtrail_p(int ch);
