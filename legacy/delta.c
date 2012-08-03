#define __LEGACY__(x) legacy_##x
#include "delta.h"
#include "../revised/system.h"
#include <string.h>

int legacy_alpha_opt = 52;
char *legacy_bravo_opt;

int legacy_alpha(int param) {
	return alpha(param, legacy_alpha_opt);
}

char *legacy_bravo(char *dest, const char *src) {
	int len = strlen(src);
	if (len < 5) {
		strcpy(dest, "XXX");
		legacy_bravo_opt = "YYY";
	} else {
		bravo(dest, src + 3, strlen(src) + 3);
		legacy_bravo_opt = (char *) bravo_opt;
	}
	return dest;
}

