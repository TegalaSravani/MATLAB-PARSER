D         [0-9]
L         [a-zA-Z_]



%{

#include "matlab.tab.h"

extern void POS_NUMBER();

extern int yyparse();
extern int yywrap();
extern FILE* yyin;

 int column = 0;
 int line = 1;

%}

%%
"%".*$    { ECHO; }
"!".*$    { ECHO; }
"...".*\n { POS_NUMBER(); }


"clear"   	{ POS_NUMBER();  return(CLEAR); }
"function" 	{ POS_NUMBER();    return(FUNCTION); }
"while"   	{ POS_NUMBER();    return(WHILE); }
"end"     	{ POS_NUMBER();    return(END); }
"else"    	{ POS_NUMBER();    return(ELSE); }
"elseif"  	{ POS_NUMBER();    return(ELSEIF); }
"for"     	{ POS_NUMBER();    return(FOR); }
"global"  	{ POS_NUMBER();    return(GLOBAL); }
"if"      	{ POS_NUMBER();    return(IF); }
"return"  	{ POS_NUMBER();    return(RETURN); }
"break"   	{ POS_NUMBER();    return(BREAK); }
"continue"      { POS_NUMBER();    return(CONTINUE); }

{L}({L}|{D})*           { POS_NUMBER();    return(IDENTIFIER); }
{D}+ 		{ POS_NUMBER();    return(CONSTANT); }
{D}*"."{D}+       { POS_NUMBER();    return(CONSTANT); }


'[^'\n]*'           { POS_NUMBER();  return(STRING); }
   

"./"      { POS_NUMBER();    return(DIVISON); }
".*"      { POS_NUMBER();    return(MULTIPLY); }
".^"      { POS_NUMBER();    return(POWER); }
".\\"     { POS_NUMBER();    return(RDIVISON); }
"<="      { POS_NUMBER();    return(LESS_EQ); }
">="      { POS_NUMBER();    return(GREATER_EQ); }
"=="      { POS_NUMBER();    return(EQ); }
"~="      { POS_NUMBER();    return(NOT_EQ); }
"~"       { POS_NUMBER();    return('~'); }
";"       { POS_NUMBER();    return(';'); }
","       { POS_NUMBER();    return(','); }
":"       { POS_NUMBER();    return(':'); }
"="       { POS_NUMBER();    return('='); }
"("       { POS_NUMBER();    return('('); }
")"       { POS_NUMBER();    return(')'); }
"["       { POS_NUMBER();    return('['); }
"]"       { POS_NUMBER();    return(']'); }
"&"       { POS_NUMBER();    return('&'); }
"-"       { POS_NUMBER();    return('-'); }
"+"       { POS_NUMBER();    return('+'); }
"*"       { POS_NUMBER();    return('*'); }
"/"       { POS_NUMBER();    return('/'); }
"\\"      { POS_NUMBER();    return('\\'); }
"<"       { POS_NUMBER();    return('<'); }
">"       { POS_NUMBER();    return('>'); }
"^"       { POS_NUMBER();    return('^'); }
"|"       { POS_NUMBER();    return('|'); }
"."	  { POS_NUMBER();    return('.'); }
\n        { POS_NUMBER();    line = line + 1; return(CR); }
[ \t\v\f] { POS_NUMBER();    }
.         { ECHO;   }

%%




void POS_NUMBER()
{
        int i;

        for (i = 0; yytext[i] != '\0'; i++)
  		if (yytext[i] == '\n')
          		column = 0;
  		else if (yytext[i] == '\t')
         		 column += 8 - (column % 8);
  		else
          		column++;

        ECHO;
}
             

int main()
{
yyin=fopen("MATLAB_code.m","r");
return(yyparse());
}

int yywrap()
{
	printf("CODE SUCCESSFULLY PARSED\n");
        return(1);
}

