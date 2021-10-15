#include "lab5_c.h"

void horizontal_flip(unsigned char* data, unsigned char* new_data, int x, int y, int n){
	for(int j = 0; j < y; j++){
		for(int i = 0; i < x; i++){
			for(int c = 0; c < n; c++){
				new_data[(x - i - 1)*n + (x*j*n) + c] = data[i*n + (x*j*n) + c];
			}
		}
	}
/*
	for(int j = 0; j < y; j++){
		for(int i = 0; i < x; i++){
			for(int c = 0; c < n; c++){
				new_data[(x - i - 1)*n + (x*j*n) + c] = data[i*n + (x*j*n) + 0];
			}
		}
	}
*/
}

void flip(const char* in, const char* out, const char* out_asm) {
	int x, y, n;
	unsigned char* data = stbi_load(in, &x, &y, &n, 0);
	if(data == NULL){
		printf("File not found\n");
		return;
	}
	unsigned char* new_data = malloc(x * y * n);
	unsigned char* new_data_asm = malloc(x * y * n);

	struct timespec t, t1, t2;

	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t1);
	horizontal_flip(data, new_data, x, y, n);
	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t2);
	t.tv_sec = t2.tv_sec - t1.tv_sec;
	if ((t.tv_nsec = t2.tv_nsec - t1.tv_nsec) < 0) {
		t.tv_sec--;
		t.tv_nsec += 1000000000;
	}
	printf("Horizontal flip on C: %ld.%09ld \n", t.tv_sec, t.tv_nsec);
	stbi_write_bmp(out, x, y, n, new_data);


	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t1);
	horizontal_flip_asm(data, new_data_asm, x, y, n);
	clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t2);
	t.tv_sec = t2.tv_sec - t1.tv_sec;
	if ((t.tv_nsec = t2.tv_nsec - t1.tv_nsec) < 0) {
		t.tv_sec--;
		t.tv_nsec += 1000000000;
	}
	printf("Horizontal flip on ASM: %ld.%09ld \n", t.tv_sec, t.tv_nsec);
	stbi_write_bmp(out_asm, x, y, n, new_data_asm);

	free(data);
	free(new_data);
	free(new_data_asm);
}

int main(int argc, const char* argv[]){
	if (argc == 1 || argc == 2){
		printf("\nNot enough arguments.\nUsage:\t./lab05 inputfilename outputfilename\n\n");
		return 0;
	}
	if (argc > 3){
		printf("\nToo many arguments.\nUsage:\t./lab05 inputfilename outputfilename\n\n");
		return 0;
	}

	const char* in = argv[1];
	const char* out = argv[2];
	const char* assm = "_asm";
	const char* format = ".bmp";
		char* new_out = calloc(strlen(out) + strlen(format) + 1, 1);
			strcat(new_out, out);
			strcat(new_out, format);
		char* out_asm = calloc(strlen(out) + strlen(assm) + strlen(format) + 1, 1);
			strcat(out_asm, out);
			strcat(out_asm, assm);
			strcat(out_asm, format);
	flip(in, new_out, out_asm);
	return 0;
}
