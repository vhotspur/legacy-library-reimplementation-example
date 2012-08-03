#include "compute.h"

static inline int min2(int a, int b) {
	return a < b ? a : b;
}

int min3(int a, int b, int c) {
	return min2(a, min2(b, c));
}
