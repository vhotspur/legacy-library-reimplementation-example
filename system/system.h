#ifndef SYSTEM_H_
#define SYSTEM_H_

#include <stddef.h>

extern int alpha(int);
extern int alpha_opt;
extern const char *bravo_opt;
extern void bravo(char *, const char *, size_t);

typedef struct {
	int alpha;
} some_data_t;

extern some_data_t important_data;

#endif
