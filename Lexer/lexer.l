%option noyywrap

%{
#include <stdio.h>
#include <string.h>

#define YY_DECL int yylex()

int words = 0;
int chars = 0;
int lines = 0;

%}

letter      [a-zA-Z]
digit       [0-9]
ID          {letter}({letter}|{digit})*
CHAR		'.'
delim       [ \t\n]
NUMBER      {digit}+(\.{digit}+)?(E[+\-]?(digit)+)?
ws          {delim}+

%%
"/*"    				{
							int c;
							while((c = input()) != 0) {
								if(c == '*') {
									if((c = input()) == '/')
										break;
									else
										unput(c);
								}
							}
						}
						
"int"	{words++; chars += strlen(yytext);
		 printf("%s : TYPE_INT\n", yytext);
		}

"float" {words++; chars += strlen(yytext);
		 printf("%s : TYPE_FLOAT\n", yytext);
		}

"char"	{words++; chars += strlen(yytext);
		 printf("%s : TYPE_CHAR\n", yytext);
		}
		
"write"	{words++; chars += strlen(yytext);
		 printf("%s : KEYWORD_WRITE\n", yytext);
		}

"if" 	{words++; chars += strlen(yytext);
		 printf("%s : KEYWORD_IF\n", yytext);
		}

"else" 	{words++; chars += strlen(yytext);
		 printf("%s : KEYWORD_ELSE\n", yytext);
		}

"while" 	{words++; chars += strlen(yytext);
			 printf("%s : KEYWORD_WHILE\n", yytext);
			}
		
{ID}	{words++; chars += strlen(yytext);
		 printf("%s : IDENTIFIER\n",yytext);
		}
			
{NUMBER}	{words++; chars += strlen(yytext);
			  printf("%s : NUMBER\n",yytext);
			}

{CHAR}	{words++; chars += strlen(yytext);
			  printf("%s : CHAR\n",yytext);
		}
			
";"		{chars++;
		 printf("%s : SEMICOLON\n", yytext);
		}
		
"="		{chars++;
		 printf("%s : ASSIGNMENT\n", yytext);
		}

"*"		{chars++;
		 printf("%s : MULTIPLY\n", yytext);
		}

"/"		{chars++;
		 printf("%s : DIVIDE\n", yytext);
		}
		
"%"		{chars++;
		 printf("%s : MOD\n", yytext);
		}

"+"		{chars++;
		 printf("%s : PLUS\n", yytext);
		}

"-"		{chars++;
		 printf("%s : SUB\n", yytext);
		}

"<"		{chars++;
		 printf("%s : LESS\n", yytext);
		}
		
"<="	{chars++;
		 printf("%s : LESS_EQ\n", yytext);
		}

">"		{chars++;
		 printf("%s : GREATER\n", yytext);
		}

">="	{chars++;
		 printf("%s : GREATER_EQ\n", yytext);
		}

"=="	{chars++;
		 printf("%s : EQ\n", yytext);
		}

"+="	{chars++;
		 printf("%s : PLUS_EQ\n", yytext);
		}

"-="	{chars++;
		 printf("%s : MINUS_EQ\n", yytext);
		}
		
"!="	{chars++;
		 printf("%s : NOT_EQ\n", yytext);
		}

"!"		{chars++;
		 printf("%s : NOT\n", yytext);
		}

"&&"	{chars++;
		 printf("%s : AND\n", yytext);
		}

"||"	{chars++;
		 printf("%s : OR\n", yytext);
		}

"("		{chars++;
		 printf("%s : LEFT_PAREN\n", yytext);
		}

")"		{chars++;
		 printf("%s : RIGHT_PAREN\n", yytext);
		}

"{"		{chars++;
		 printf("%s : LEFT_CURLY\n", yytext);
		}

"}"	{chars++;
		 printf("%s : RIGHT_CURLY\n", yytext);
		}

","	{chars++;
		 printf("%s : COMMA\n", yytext);
		}

\n		{lines++; chars=0;}
[ \t]	{chars++;}
.		{chars++;
         printf("%s : Unrecognized symbol at line %d char %d\n", yytext,lines + 1,chars);
		}
		


%%
int main(int argc, char**argv)
{
	#ifdef YYDEBUG
		yydebug = 1;
	#endif

	printf("Compiler started. \n\n");

	if (argc > 1){
	  if(!(yyin = fopen(argv[1], "r")))
          {
		perror(argv[1]);
		return(1);
	  }
	}
	yylex();
}