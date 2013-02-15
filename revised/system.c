#include "system.h"
#include "err.h"
#include <stddef.h>
#include <string.h>

const char *bravo_opt = NULL;
some_data_t important_data = {
	.alpha = 69
};

int alpha(int param, int param2) {
	return param + param2;
}

void bravo(char *dest, const char *src, size_t n) {
	strncpy(dest, src, n);
	bravo_opt = src;
}

int delta(void)
{
	return ERR_NOTSUP;
}
