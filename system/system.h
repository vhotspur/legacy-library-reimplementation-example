#ifndef SYSTEM_H_
#define SYSTEM_H_

#include <stddef.h>

extern int alpha(int, int);
extern const char *bravo_opt;
extern void bravo(char *, const char *, size_t);

typedef struct {
	int alpha;
} some_data_t;

extern some_data_t important_data;

#endif
