#define __LEGACY__(x) legacy_##x
#include "delta.h"
#include "../system/system.h"
#include <string.h>

void legacy_read_some_data(legacy_some_data_t *data) {
	data->alpha = important_data.alpha;
	data->next = NULL;
}
