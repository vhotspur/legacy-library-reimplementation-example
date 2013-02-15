#ifndef DELTA_H_
#define DELTA_H_

#ifndef __LEGACY__
#define __LEGACY__(x) x
#endif

typedef struct __LEGACY__(some_data) __LEGACY__(some_data_t);

struct __LEGACY__(some_data) {
	int alpha;
	__LEGACY__(some_data_t) *next;
};

extern int __LEGACY__(alpha)(int);
extern int __LEGACY__(alpha_opt);
extern char *__LEGACY__(bravo)(char *, const char *);
extern char *__LEGACY__(bravo_opt);

extern void __LEGACY__(read_some_data)(__LEGACY__(some_data_t) *);

extern int __LEGACY__(delta)(void);

#undef __LEGACY__

#endif
