/*
	instruction.
	$Id: mulk inst.h 406 2020-04-19 Sun 11:29:54 kt $
*/

/* basic instructions */
#define BASIC_INST 0
#define 	PUSH_INSTANCE_VAR_INST 0 /* n */
#define 	PUSH_CONTEXT_VAR_INST 1 /* n */
#define		PUSH_TEMP_VAR_INST 2 /* n */
#define 	PUSH_LITERAL_INST 3 /* n */
#define 	SET_INSTANCE_VAR_INST 4 /* n */
#define 	SET_CONTEXT_VAR_INST 5 /* n */
#define		SET_TEMP_VAR_INST 6 /* n */
#define 	BRANCH_BACKWARD_INST 7 /* off */
#define 	DROP_INST 8
#define 	END_INST 9
#define 	RETURN_INST 10
#define		DUP_INST 11

#define SEND_INST 1 /* 1_narg,selector */
#define SEND_SUPER_INST 2 /* 2_narg,selector */
#define BLOCK_INST 3 /* 3_narg,size */

/* extend instructions */
#define EXT_INST 4
#define		BRANCH_FORWARD_INST 0 /* off */
#define		BRANCH_TRUE_FORWARD_INST 1 /* off */
#define 	BRANCH_FALSE_FORWARD_INST 2 /* off */
#define		START_TIMES_DO_INST 3
#define		TIMES_DO_INST 4 /* vn off */

#define PUSH_INSTANCE_VAR_SHORT_INST 5 /* 5_n */
#define PUSH_CONTEXT_VAR_SHORT_INST 6 /* 6_n */
#define PUSH_TEMP_VAR_SHORT_INST 7 /* 7_n */
#define PUSH_LITERAL_SHORT_INST 8 /* 8_n */
#define SET_INSTANCE_VAR_SHORT_INST 9 /* 9_n */
#define SET_CONTEXT_VAR_SHORT_INST 10 /* 10_n */
#define SET_TEMP_VAR_SHORT_INST 11 /* 11_n */
#define SEND_0_SHORT_INST 12 /* 12_n */
#define SEND_1_SHORT_INST 13 /* 13_n */
#define SEND_COMMON_INST 14 /* 14_n */
	/* _0 = */
	/* _1 + */
	/* _2 < */
	/* _3 nil? */
	/* _4 notNil? */
	/* _5 _inc */
	/* _6 at: */
	/* _7 value: */
	/* _8 at:put: */
	/* _9 byteAt: */
#define PUSH_COMMON_LITERAL_INST 15 /* 15_n */
	/* _0 0 */
	/* _1 1 */
	/* _2 2 */
	/* _3 -1 */
	/* _4 nil */
	/* _5 true */
	/* _6 false */
