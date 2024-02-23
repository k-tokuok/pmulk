/*
	classic mac utility function.
	$Id: mulk cm.h 624 2020-12-31 Thu 22:00:44 kt $
*/

extern unsigned char *cm_cstr_to_pstr(char *s,unsigned char *cs);
extern uint32_t cm_mactime_to_posixtime(uint32_t mt);
extern char *cm_posixfn_to_macfn(char *fn,char *macfn);
