/*
 * CodeCoverageSupport.c
 * 
 * Created by David Aspinall on 12-09-16. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#include <stdio.h>

/**
 http://stackoverflow.com/questions/8732393/code-coverage-with-xcode-4-2-missing-files/8733416#8733416
 
 You are expecting linker problem, profile_rt library uses fopen$UNIX2003 and fwrite$UNIX2003 functions instead of fopen and fwrite.
 
 This code just remaps the missing functions to standard ones.
 */

FILE *fopen$UNIX2003(const char *filename, const char *mode);
size_t fwrite$UNIX2003(const void *ptr, size_t size, size_t nitems, FILE *stream);


FILE *fopen$UNIX2003(const char *filename, const char *mode) {
    return fopen(filename, mode);
}

size_t fwrite$UNIX2003(const void *ptr, size_t size, size_t nitems, FILE *stream) {
    return fwrite(ptr, size, nitems, stream);
}
