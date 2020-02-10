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
%token library
%token nl
%token print
%token whl
%token fr
%token f
%token in
%token els
%token by
%token lengthout
%token pasteo
%token tru
%token fals
%token mod
%token mmod
%token num
%token str
%token id
%token copen
%token seqopen
%token co cc

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

WHILE :	whl N '(' N COND N')' N co N S cc nl
	;

FOR :	fr N '(' N ID in RANGE  N ')' N co N  S cc nl
	;

IF :	f  N '(' N  COND  N ')' N co N S cc nl 
	| f N '('  N COND N  ')' N  co N  S cc nl E
	;


E :	els N  f N '(' N COND N ')' N co N S cc nl E 
	| els N  f N '(' N COND N ')' N co N S cc nl 
	| els N co N S cc nl
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
	| M mmod O 
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

RANGE:	NUM':'NUM
	| copen VECTOR')'
	|seqopen NUM ',' NUM EXTRA')'
	|ID
	;

EXTRA:	',' by'='NUM 
	| ','lengthout'='NUM 
	|
	;

VECTOR:	ITEM ',' VECTOR 
	| ITEM
	;
	
ITEM: 	NUM 
	| BOOL 
	| STR 
	| PASTE 
	| ID
	;

PASTE: 	pasteo'('PASTEIN')'
	;


PASTEIN: STR ',' PASTEIN 
	| ID','PASTEIN  
	| ;

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


  
