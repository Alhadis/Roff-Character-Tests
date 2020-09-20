/*
	Print bytes by decimal value.
	
	I haven't yet figured out how to share files with a running
	SIMH session, so I'm limited to copy+pasting shell commands
	into my terminal that generate the files I need. There's no
	printf(1) command in Unix v7 either, and the awk(1) builtin
	lacks support for octal escape sequences (\000, \001, etc).
*/

#include <stdio.h>

int main(argc, argv)
	int argc;
	char **argv;
{
	int i;
	char *c;
	++argv;
	while(--argc > 0){
		c = *argv++;
		i = atoi(c);
		putchar(i);
	}
	return(0);
}
