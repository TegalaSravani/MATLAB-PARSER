all: a.out
	
matlab.tab.c: matlab.y
	bison -d matlab.y

lex.yy.c: matlab.l
	lex matlab.l

a.out: lex.yy.c matlab.tab.c
	cc lex.yy.c matlab.tab.c 



