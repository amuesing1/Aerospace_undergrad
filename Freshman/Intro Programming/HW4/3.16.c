#include<assert.h>
#include<stdlib.h>
#include<stdio.h>

int whisper(char *msgIn, char *msgOut) {
if (msgIn==NULL || msgOut==NULL)
return -1;
while (*msgIn !='\0') {
if ('A' <= *msgIn && *msgIn <='Z')
*msgOut=*msgIn + ('a'-'A');
else
*msgOut=*msgIn;
msgIn++;
msgOut++;
}
msgOut='\0';
return 0;
}

int main() {
char msg[]="Hi!";
char out[4];
int err=whisper(msg, out);
assert (!err);
printf("%s->%s\n", msg, out);
return 0;
}
