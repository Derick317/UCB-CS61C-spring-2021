/*
 * Include the provided hash table library.
 */
#include "hashtable.h"

/*
 * Include the header file.
 */
#include "philphix.h"

/*
 * Standard IO and file routines.
 */
#include <stdio.h>

/*
 * General utility routines (including malloc()).
 */
#include <stdlib.h>

/*
 * Character utility routines.
 */
#include <ctype.h>

/*
 * String utility routines.
 */
#include <string.h>

char * safe_malloc(int size);

char * safe_realloc(char *str, int size);

/*
 * This hash table stores the dictionary.
 */
HashTable *dictionary;

/*
 * The MAIN routine.  You can safely print debugging information
 * to standard error (stderr) as shown and it will be ignored in 
 * the grading process.
 */
int main(int argc, char **argv) {
  if (argc != 2) {
    fprintf(stderr, "Specify a dictionary\n");
    return 1;
  }
  /*
   * Allocate a hash table to store the dictionary.
   */
  fprintf(stderr, "Creating hashtable\n");
  dictionary = createHashTable(0x61C, &stringHash, &stringEquals);

  fprintf(stderr, "Loading dictionary %s\n", argv[1]);
  readDictionary(argv[1]);
  fprintf(stderr, "Dictionary loaded\n");

  fprintf(stderr, "Processing stdin\n");
  processInput();

  /*
   * The MAIN function in C should always return 0 as a way of telling
   * whatever program invoked this that everything went OK.
   */
  return 0;
}

char * safe_malloc(int size)
{
  char *str = (char *)malloc(sizeof(char) * size);
  if(NULL == str)
  {
    // free(str);
    fprintf(stderr, "Out of memory.\n");
    exit(1);
  }
  else
    return str;
}

char * safe_realloc(char *str, int size)
{
  str = realloc(str, size);
  if(NULL == str)
  {
    // free(str);
    fprintf(stderr, "Out of memory.\n");
    exit(1);
  }
  else
    return str;
}

char * add_char(char *s, int *s_size, int s_idx, char c)
{
  while(s_idx >= *s_size - 1)
  {
    if(*s_size <= 0)
      *s_size = 1;
    *s_size *= 2;
    s = safe_realloc(s, *s_size);
  }
  s[s_idx] = c;
  return s;
}

/*
 * This should hash a string to a bucket index.  Void *s can be safely cast
 * to a char * (null terminated string)
 */
unsigned int stringHash(void *s) {
  // -- TODO --
  const int BASE = 127; // 127 is a prime number
  /* 0 ~ 48, 9 ~ 57, A ~ 65, Z ~ 90, a ~ 97, z ~ 122 */
  char * str = (char *)s;
  unsigned int hashCode = 0;
  while(*str)
  {
    hashCode *= BASE;
    hashCode += (unsigned int)(*str);
    hashCode %= 0x61C;
    str++;
  }
  return hashCode;
  fprintf(stderr, "need to implement stringHash\n");

  /* To suppress compiler warning until you implement this function, */
  return 0;
}

/*
 * This should return a nonzero value if the two strings are identical 
 * (case sensitive comparison) and 0 otherwise.
 */
int stringEquals(void *s1, void *s2) {
  // -- TODO --
  if(strcmp((char *)s1, (char *)s2)) // the two strings are different
    return 0;
  else
    return 1;
  fprintf(stderr, "You need to implement stringEquals");
  /* To suppress compiler warning until you implement this function */
  return 0;
}

/*
 * This function should read in every word and replacement from the dictionary
 * and store it in the hash table.  You should first open the file specified,
 * then read the words one at a time and insert them into the dictionary.
 * Once the file is read in completely, return.  You will need to allocate
 * (using malloc()) space for each word.  As described in the spec, you
 * can initially assume that no word is longer than 60 characters.  However,
 * for the final bit of your grade, you cannot assumed that words have a bounded
 * length.  You CANNOT assume that the specified file exists.  If the file does
 * NOT exist, you should print some message to standard error and call exit(61)
 * to cleanly exit the program.
 */
void readDictionary(char *dictName) {
  // -- TODO --
  FILE *fp = fopen(dictName, "r");
  if(NULL == fp)
  {
    fprintf(stderr, "%s: No such file or directory", dictName);
    exit(61);
  }

  char *keystr, *datastr;
  int strsize = 8, stridx = 0;
  int iskey = 1;
  keystr = safe_malloc(8);
  while(!feof(fp))
  { 
    if (iskey)
    {
      keystr = add_char(keystr, &strsize, stridx, getc(fp));
      if(' ' == keystr[stridx++])
      {
        keystr[stridx - 1] = '\0';
        strsize = 8;
        stridx = 0;
        datastr = safe_malloc(8);
        iskey = 0;
      }
    }
    else
    {
      datastr = add_char(datastr, &strsize, stridx, getc(fp));
      if('\n' == datastr[stridx++])
      {
        datastr[stridx - 1] = '\0';
        insertData(dictionary, keystr, datastr);
        // free(datastr);
        // free(keystr);
        strsize = 8;
        stridx = 0;
        keystr = safe_malloc(8);
        iskey = 1;
      }
    }
  }
  return;
  fprintf(stderr, "You need to implement readDictionary\n");
}

/*
 * This should process standard input (stdin) and perform replacements as 
 * described by the replacement set then print either the original text or 
 * the replacement to standard output (stdout) as specified in the spec (e.g., 
 * if a replacement set of `taest test\n` was used and the string "this is 
 * a taest of  this-proGram" was given to stdin, the output to stdout should be 
 * "this is a test of  this-proGram").  All words should be checked
 * against the replacement set as they are input, then with all but the first
 * letter converted to lowercase, and finally with all letters converted
 * to lowercase.  Only if all 3 cases are not in the replacement set shoud 
 * it report the original word.
 *
 * Since we care about preserving whitespace and pass through all non alphabet
 * characters untouched, scanf() is probably insufficent (since it only considers
 * whitespace as breaking strings), meaning you will probably have
 * to get characters from stdin one at a time.
 *
 * Do note that even under the initial assumption that no word is longer than 60
 * characters, you may still encounter strings of non-alphabetic characters (e.g.,
 * numbers and punctuation) which are longer than 60 characters. Again, for the 
 * final bit of your grade, you cannot assume words have a bounded length.
 */
void processInput() {
  // -- TODO --
  char *keystr, *line, *correct_word, new_char;
  int strsize = 8, stridx = 0, linesize = 8, lineidx = 0;
  keystr = safe_malloc(strsize);
  line = safe_malloc(linesize);
  while((new_char = getc(stdin)) != EOF)
  {
    fprintf(stderr, "%c", new_char);
    if(isalnum(new_char))
      keystr = add_char(keystr, &strsize, stridx++, new_char);
    else if(0 == stridx)
      fprintf(stdout, "%c", new_char);
    else // The key is completely input
    {
      keystr[stridx++] = '\0';
      char *modified_word = safe_malloc(stridx);
      strcpy(modified_word, keystr);
      correct_word = findData(dictionary, keystr);
      if(!correct_word)
      {
        for(char *tmpc = modified_word + 1; *tmpc; tmpc++)
          if(*tmpc >= 65 && *tmpc <= 90)
            *tmpc += 32;
        correct_word = findData(dictionary, modified_word);
        if(!correct_word)
        {
          if(modified_word[0] >= 65 && modified_word[0] <= 90)
            modified_word[0] += 32;
          correct_word = findData(dictionary, modified_word);
          if(!correct_word)
            correct_word = keystr;
        }
      }
      fprintf(stdout, "%s%c", correct_word, new_char);
      free(keystr);
      keystr = safe_malloc(8);
      strsize = 8;
      stridx = 0;
      free(modified_word);
    }
  }
  return;
  fprintf(stderr, "You need to implement processInput\n");
}
