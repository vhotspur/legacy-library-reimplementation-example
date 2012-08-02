#include <delta.h>
#include <stdio.h>

typedef int (*alpha_func_t)(int);

void test_bravo(const char *msg) {
	char buffer[100];
	bravo_opt = (char *) msg;
	bravo(buffer, msg);
	printf("test_bravo(\"%s\") -> \"%s\", opt=\"%s\"\n", msg, buffer, bravo_opt);
}

void test_alpha(int param, int opt) {
	alpha_opt = opt;
	int result = alpha(param);
	printf("test_alpha(%d, %d) -> %d\n", param, opt, result);
}

void test_alpha_ptr(alpha_func_t func, int param, int opt) {
	alpha_opt = opt;
	int result = func(param);
	printf("test_alpha_ptr(%d, %d) -> %d\n", param, opt, result);
}

void test_some_data(some_data_t *data) {
	printf("some_data_t = { %d, %p }\n", data->alpha, data->next);
}

int main(int argc, char *argv[]) {
	test_alpha(20, 15);
	test_alpha(5, 4);

	alpha_func_t func = &alpha;
	test_alpha_ptr(func, 1, 7);
	test_alpha_ptr(func, 16, -2);

	test_bravo("Hello, World!");
	test_bravo("!");

	some_data_t data = {
		.alpha = 2,
		.next = NULL
	};
	test_some_data(&data);


	read_some_data(&data);
	test_some_data(&data);


	return 0;
}
