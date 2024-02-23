/*
	unsigned 64 bit integer.
	$Id: mulk u64.h 622 2020-12-29 Tue 21:26:07 kt $
*/

typedef struct {
	uint16_t u16[4];
} u64_t;

extern void u64_init(u64_t *u64,uint32_t h32,uint32_t l32);
extern int u64_val(u64_t *u64,uint32_t *valp);
extern double u64_double(u64_t *u64);

extern int u64_equal(u64_t *x,u64_t *y);
extern int u64_lt(u64_t *x,u64_t *y);
extern int u64_add(u64_t *x,u64_t *y,u64_t *z);
extern void u64_subtract(u64_t *x,u64_t *y,u64_t *z);
extern int u64_multiply(u64_t *x,u64_t *y,u64_t *z);
extern int u64_divide(u64_t *x,u64_t *y,u64_t *quot,u64_t *rem);
extern void u64_and(u64_t *x,u64_t *y,u64_t *z);
extern void u64_or(u64_t *x,u64_t *y,u64_t *z);
extern void u64_xor(u64_t *x,u64_t *y,u64_t *z);
extern int u64_shift(u64_t *x,int y,u64_t *z);

