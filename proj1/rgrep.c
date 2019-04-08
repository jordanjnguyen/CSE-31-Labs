#include <stdio.h>
#define MAXSIZE 4096

/**
 * You can use this recommended helper function 
 * Returns true if partial_line matches pattern, starting from
 * the first char of partial_line.
 */
int matches_leading(char *partial_line, char *pattern) {
  // Implement if desire 
  // matches pattern with beginning of string, then checks from the next char, and so on
	int count = 0;
	while(pattern[count] != '\0' && pattern[count] != '\n') {
		if(partial_line[count] == '\0') {
			return 0;
		}
		if(pattern[count] == '\\') { // bSlash (escapes following character)
			pattern++;
			if(pattern[count+1] == '+') { // if plus sign after slash something
				char lastChar = partial_line[count];
				if(partial_line[count] != pattern[count] && pattern[count] != '.') { // if they dont match
					return 0;
				}
				while(partial_line[count] == lastChar) { // while same character repeats
					partial_line++;
					if(matches_leading(&partial_line[count], &pattern[count + 2])) { //recursion
						return 1;
					}
				}
				pattern = pattern + 2;
			}
			else if(pattern[count+1] == '?') { // if qMark after, do qMark wildcard
				if(pattern[count] == partial_line[count]) { 
					if(matches_leading(&partial_line[count+1], &pattern[count + 2])) { // recursion
						return 1;
					}
				}
				pattern+=2;
			}
			else if(pattern[count] != partial_line[count]) { // if they dont match return 0
				return 0;
			}
			else {
				count++;
			}
		}
		else if(pattern[count+1] == '+') { //plus wildcard (preceding character repeats)
			char lastChar = partial_line[count];
			if(partial_line[count] != pattern[count] && pattern[count] != '.') { // if they dont match, return 0
				return 0;
			}
			while(partial_line[count] == lastChar) {
				partial_line++;
				if(matches_leading(&partial_line[count], &pattern[count + 2])) { // recursion, while it is equal, pass in next part
					return 1;
				}
			}
			pattern = pattern + 2;
		}
		else if(pattern[count+1] == '?') { // qMark wildcard (preceding char may or may not appear)
			if(pattern[count] == partial_line[count] || pattern[count] == '.') { //if they match
				if(matches_leading(&partial_line[count+1], &pattern[count + 2])) { // recursion for second half
					return 1;
				}
			}
			pattern+=2;
		}
		else if(pattern[count] == '.') { // period wildcard (matches any character)
			count++;
		}
		else if(pattern[count] != partial_line[count]) { //regular substring check. compares chars
			return 0;
		}
		else {
			count++;
		}
	}
	return 1;
}

/**
 * You may assume that all strings are properly null terminated 
 * and will not overrun the buffer set by MAXSIZE 
 *
 * Implementation of the rgrep matcher function
 */
/*int pLengthCount(char *pattern) { //make sure ? doesnt countribute to length
	int pLength = 0;
	int i = 0;
	while(pattern[i] != '\0') {
		//printf("char %c\n", pattern[i]);
		//printf("The integer is %d\n", pLength);
		if(pattern[i] == '?') {
			pLength--; //maybe -2
		}
		else if(pattern[i] == '\\') {
			if(pattern[i+1] != '?') {
				pLength--;
			}
		}
		pLength++;
		i++;
	}
	//printf("The intput is %d\n", pLength);
	return pLength;
} */
int rgrep_matches(char *line, char *pattern) {
	// string, input
	
	//check if pattern is longer than line	
	/*int lLength = 0;
	while(line[lLength] != '\0') {
		lLength ++;
	} */
	//lLength = lLength;
	//printf("The Length is %d\n", lLength);
	/*if(lLength < pLengthCount(pattern)) { 
		return 0;
	}*/
	
	//send line and pattern to helper function
	int count = 0;
	while(line[count] != '\0' && line[count] != '\n') { // while not null or newline
		//check for pattern
		if (matches_leading(&line[count], pattern) == 1) { // send to matches_leading 
			return 1;
		}
		count++;
	}
    return 0;
}

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <PATTERN>\n", argv[0]);
        return 2;
    }

    /* we're not going to worry about long lines */
    char buf[MAXSIZE]; // array of characters. buf is 1 string.

    while (!feof(stdin) && !ferror(stdin)) {
        if (!fgets(buf, sizeof(buf), stdin)) {
            break;
        }
        if (rgrep_matches(buf, argv[1])) {
            fputs(buf, stdout);
            fflush(stdout);
        }
    }

    if (ferror(stdin)) {
        perror(argv[0]);
        return 1;
    }

    return 0;
}
