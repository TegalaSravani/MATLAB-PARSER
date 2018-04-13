%token IDENTIFIER CONSTANT STRING
%token MULTIPLY POWER DIVISON RDIVISON 
%token LESS_EQ GREATER_EQ EQ NOT_EQ

%token IF ELSE ELSEIF WHILE FOR BREAK RETURN END CONTINUE
%token FUNCTION CR GLOBAL CLEAR



%start start_grammar
%{

#include <stdio.h>

extern char yytext[];
extern int column;
extern int line;
extern int yylex(); 
extern void yyerror(char *s);
%}

%%

start_grammar
 : start_grammar statement_extension
 | start_grammar FUNCTION func_declaration line_end func_extension
	| statement_extension
 | FUNCTION func_declaration line_end func_extension
 ;

simple_statement
 : IDENTIFIER    
 | CONSTANT    
 | STRING 
 | '(' expression ')'
 | '[' ']'
 | '[' array ']'
 | array_statement 
 | simple_statement '.' IDENTIFIER 
 ;

range_operator
 : ':'
 | expression
 ;

range_statement
 : range_operator
 | range_statement ',' range_operator
 ;

array_statement
 : IDENTIFIER '(' range_statement ')'
 ;

single_statement
 : simple_statement
 | single_operator simple_statement
 ;

single_operator
 : '+'
 | '-'
 | '~'
 ;

multiplication
 : single_statement
 | multiplication '*' single_statement
 | multiplication '/' single_statement
 | multiplication '\\' single_statement
 | multiplication '^' single_statement
 | multiplication MULTIPLY single_statement
 | multiplication DIVISON single_statement
 | multiplication RDIVISON single_statement
 | multiplication POWER single_statement
 ;

addition
 : multiplication
 | addition '+' multiplication
 | addition '-' multiplication
 ;

logical_statement
 : addition
 | logical_statement '<' addition
 | logical_statement '>' addition
 | logical_statement LESS_EQ	 addition
 | logical_statement GREATER_EQ addition
 ;

equivalance
 : logical_statement
 | equivalance EQ logical_statement
 | equivalance NOT_EQ logical_statement
 ;

and_operator
 : equivalance
 | and_operator '&' equivalance
 | and_operator '&' '&' equivalance
 ;

or_operator
 : and_operator
 | or_operator '|' and_operator
 | or_operator '|' '|' and_operator
 ;

expression
 : or_operator
 | expression ':' or_operator
 ;

assigning_statement
 : simple_statement '=' expression
 ;

line_end
 :  ','
 |  ';'
 | CR
 ;

statement
 : global_statement
 | clear_statement
 | assigning_extension
 | expression_statement
 | selection_statement
 | loop
 ;

statement_extension
 : statement
 | statement_extension statement
 ;
	
identifier_extension
 : IDENTIFIER
 | identifier_extension IDENTIFIER
 ;

global_statement
 : GLOBAL identifier_extension line_end
 ;

clear_statement
 : CLEAR identifier_extension line_end
 | CLEAR ';'
 ;

expression_statement
 : line_end
 | expression line_end
 ;

assigning_extension
 : assigning_statement line_end
 ;

array_element
 : expression
 | expression_statement 
 ;

array
 : array_element
 | array array_element
 ;
 
selection_statement
 : IF expression statement_extension END CR
 | IF expression statement_extension ELSE statement_extension END CR
 | IF expression statement_extension elseif_statement END CR
 | IF expression statement_extension elseif_statement
   ELSE statement_extension END CR
 ;

elseif_statement
 : ELSEIF expression statement_extension
  | elseif_statement ELSEIF expression statement_extension
 ;
	
loop
 : WHILE expression CR loop_extension END CR
 | FOR IDENTIFIER '=' expression CR loop_extension END CR
 | FOR '(' IDENTIFIER '=' expression ')' CR loop_extension END CR 
 ;

break_statement
 : BREAK CR
 | CONTINUE ';'
 |	
 ;

loop_extension
	: loop_extension statement_extension break_statement
	|break_statement
	|statement_extension
	;
 
return_statement
 : RETURN CR
 | 
 ;

func_extension
	: func_extension statement_extension return_statement
	|return_statement
	|statement_extension
	;


func_identifier
 : IDENTIFIER
 | func_identifier ',' IDENTIFIER
 ;

func_return
 : IDENTIFIER
 | '[' func_identifier ']'
 ;

func_parameter
 : IDENTIFIER
 | IDENTIFIER '(' ')'
 | IDENTIFIER '(' func_identifier ')'
 ;

func_declaration
 : func_parameter
 | func_return '=' func_parameter
 ;
      
%%



void yyerror(char *s)
{
	
 fflush(stdout);
 printf("\n%*s\n%*s",column,"^",column,s);
	printf(" at line %d, column %d\n",line,column);

}


