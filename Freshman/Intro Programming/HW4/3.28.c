#include<assert.h>
#include<stdio.h>

int hasSubstring(char *str, char *substr) {
if(!str || !substr) return 0;
if (substr[0]=='\0') return 1;
int i;
int j;
for (i = 0; str[i]; i++) {
for (j = 0; substr[j]; j++) {
if (str[i+j] != substr[j])break;
}
if (substr[j]=='\0') return 1;
}
return 0;
}

int main() {
assert (hasSubstring("Hello universe!", "lo"));
assert (hasSubstring("Hello universe!", "verse"));
assert (hasSubstring("Hello universe!", ""));
assert (hasSubstring("",""));
assert (hasSubstring("Hello universe!", "verses"));
assert (hasSubstring("Hello universe!", "loun" ));
assert (hasSubstring("Hello universe!", "erse!!"));
return 0;
} 
