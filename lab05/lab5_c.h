#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define STB_IMAGE_WRITE_IMPLEMENTATION
#define STB_IMAGE_IMPLEMENTATION
#define STBI_NO_LINEAR
#define STBI_NO_HDR

#include "stb_image.h"
#include "stb_image_write.h"

#ifndef LAB5_C
#define LAB5_C

void flip(const char* in, const char* out, const char* out_asm);
void horizontal_flip(unsigned char* data, unsigned char* new_data, int x, int y, int n);
void horizontal_flip_asm(unsigned char* data, unsigned char* blurred_image, int x, int y, int n);

#endif
