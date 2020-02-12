%option yylineno
%{

    #include "y.tab.h"
	#include <stdio.h>
	#include <string.h>
	#include <stdlib.h>
    	int st[100];
	int top;
	int count;
	void insertIntoSym(char *text,int nm,int scp);
	void display();

	
%}
	

%%

[ \t] ; 
\n	{printf("< NEW LINE, <=, %d >\n",yylineno);return nl;}
print {printf("< PRINT, print, %d >\n",yylineno);return print;}
while {printf("< WHILE, while, %d >\n",yylineno);return whl;}
for {printf("< FOR, for, %d >\n",yylineno);return fr;}
if {printf("< IF, if, %d >\n",yylineno);return f;}
else {printf("< ELSE, else, %d >\n",yylineno);return els;}
in {printf("< IN, in, %d >\n",yylineno);return in;}
len {printf("< LEN, len, %d >\n",yylineno);return length;}
"<=" {printf("< RELATIONAL OPERATOR, <=, %d >\n",yylineno);return LE;}
">=" {printf("< RELATIONAL OPERATOR, >=, %d >\n",yylineno);return GE;}
"==" {printf("< RELATIONAL OPERATOR, ==, %d >\n",yylineno);return EE;}
"!=" {printf("< RELATIONAL OPERATOR, !=, %d >\n",yylineno);return NE;}
"->" {printf("< RELATIONAL OPERATOR, ->, %d >\n",yylineno);return RA;}
"<-" {printf("< RELATIONAL OPERATOR, <-, %d >\n",yylineno);return LA;}
":" {printf("< RELATIONAL OPERATOR, :, %d >\n",yylineno);return colon;}
range {printf("< RANGE, range, %d >\n",yylineno);return rangeo;}
INDENT {printf("< INDENT, INDENT, %d >\n",yylineno);count=count+1;top=top+1;st[top]=count;return co;}
REDENT {printf("< REDENT, REDENT, %d >\n",yylineno);top=top-1;return cc;}
[0-9]+ {printf("< NUMBER, %s , %d >\n",yytext,yylineno);return num;}
TRUE {printf("< BOOL, TRUE, %d >\n",yylineno);return tru;}
FALSE {printf("< BOOL, FALSE, %d >\n",yylineno);return fals;}
"%" {printf("< MOD OPERATOR, %%, %d >\n",yylineno);return mod;}
\".*\" {printf("< CON CATENATION OPERATOR, ., %d >\n",yylineno);return str;}
\.[a-zA-Z_]([a-zA-Z0-9_.])*|[a-zA-Z]([a-zA-Z0-9_.])* {printf("< VARIABLE, %s, %d >\n",yytext,yylineno);insertIntoSym(yytext,yylineno,st[top]);return id;}

. {return yytext[0];}
%%
struct var
{
	char c[20];
	char l[100];
	int scope;
	int y;
};
struct scope
{
	struct var arr[20];
	int up;
};

struct scope symtab[100];


void insertIntoSym(char *text,int nm,int scp)
{
	int present=0;
	for(int i=0;i<=symtab[scp].up;i++)
	{
		if(strcmp(symtab[scp].arr[i].c,text)==0)
		{
			char buffer[20];
			sprintf(buffer,"%d",nm);
			present=1;
			strcat(symtab[scp].arr[i].l,",");
			strcat(symtab[scp].arr[i].l,buffer);	
			symtab[scp].arr[i].scope=scp;		
			break;
		}
	}
	if(present==0)
	{
		char buffer[20];
		sprintf(buffer,"%d",nm);
		symtab[scp].up++;
		int p=symtab[scp].up;
		strcpy(symtab[scp].arr[p].c,text);
		strcpy(symtab[scp].arr[p].l,"");
		strcat(symtab[scp].arr[p].l,buffer);
		symtab[scp].arr[p].scope=scp;
	}
	
}

void display()
{
	for(int i=0;i<=count;i++)
	{
		int h=symtab[i].up;
		for (int j=1;j<=h;j++)
		{
			printf("Symbol:%s \t Scope:%d \t Line number: %s\n",symtab[i].arr[j].c,symtab[i].arr[j].scope,symtab[i].arr[j].l);
		}
	}	
}

int yywrap()
{
return 1;
}
