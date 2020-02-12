%{
#include <stdio.h>
#include <stdlib.h>
int valid=1;
int yylex();
int yyerror(const char *s);
extern int st[100];
extern int top;
extern int count;
extern void display();
	
%}

%define parse.error verbose
%start S
%token nl
%token print
%token whl
%token fr
%token f
%token in
%token els
%token length
%token tru
%token fals
%token mod
%token num
%token str
%token id
%token co cc
%token colon
%token rangeo

%left '<' '>' LE GE EE NE 
%right RA '=' LA


%%

S: 	WHILE S 
	| IF S 
	| FOR S 
	| EXP S 
	| print '('ITEM')' nl S
	| co N S cc nl S
	|
	;

WHILE :	whl '(' COND ')' colon nl co S cc N
		|whl COND colon nl co S cc N
	;

FOR :	fr ID in RANGE colon nl co S cc N
	;

IF :	f '(' COND ')' colon nl co S cc N 
	|f COND colon nl co S cc N 
	| f '(' COND ')' colon nl co S cc N E
	| f COND colon nl co S cc N E
	;


E :	els f '(' COND ')' colon nl co S cc N E 
	| els  f '(' COND ')' colon co S cc N 
	| els colon nl co S cc N
	|els f COND  colon nl co S cc N E 
	| els  f  COND  colon co S cc N 
	;

EXP :	K RELOP K nl
	| K ASSIGNOP K nl
	| K nl
	;

COND :	K RELOP K 
	| K ASSIGNOP K 
	| K 
	;

K: 	K '+' L 
	| K '-' L 
	| L
	;
	
L: 	L '*' M 
	| L '/' M 
	| M
	;

M: 	M mod O 
	| O
	;

O: 	ID 
	| NUM 
	|'('K')' 
	| ID'['INDEX']'
	;

INDEX: 	NUM','INDEX
	|ID','INDEX 
	|NUM 
	|ID
	;

RELOP:	'<'
	|'>'
	|EE
	|LE
	|GE
	|NE
	;

ASSIGNOP:'='
	|LA
	|RA
	; 

RANGE:	rangeo '(' NUM ',' NUM ')'
	|rangeo '(' NUM ')'
		;


ITEM: 	NUM 
	| BOOL 
	| STR 
	| ID
	;


N:	nl
	|
	;

NUM: 	num
	;

BOOL: 	tru 
	| fals
	;

STR: 	str
	;

ID: 	id
	;

%%

#include <ctype.h>
int yyerror(const char *s)
{
  	extern int yylineno;
  	valid =0;
	display();
  	printf("Line no: %d \n The error is: %s\n",yylineno,s);
}

int main()
{
	st[0]=0;
	top=0;
	count=0;
	yyparse();
	if(valid)
	{
  		printf("Parsing successful\n\n\n");
		display();
	}
	else
	{
  		printf("Parsing unsuccessful\n\n\n");
	}
	
	return 0;
}        


  
