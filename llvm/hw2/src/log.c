#include <stdio.h>

void callLogger(char *user, char *uses) {
  static FILE* file = NULL;

  if (!file) 
    file = fopen("trace.log", "w");
  
  fprintf(file, "%s <- %s\n", user, uses);
}
