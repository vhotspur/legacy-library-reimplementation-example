#include "system.h"
#include <stddef.h>
#include <string.h>

int alpha_opt = 10;
const char *bravo_opt = NULL;
some_data_t important_data = {
	.alpha = 69
};

int alpha(int param) {
	return alpha_opt + param;
}

void bravo(char *dest, const char *src, size_t n) {
	strncpy(dest, src, n);
	bravo_opt = src;
}
