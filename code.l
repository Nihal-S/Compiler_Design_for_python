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
\n	{return nl;}
print return print;
while return whl;
for return fr;
if return f;
else return els;
in return in;
len return length;
"<=" return LE;
">=" return GE;
"==" return EE;
"!=" return NE;
"->" return RA;
"<-" return LA;
":" return colon;
range return rangeo;
INDENT {count=count+1;top=top+1;st[top]=count;return co;}
REDENT {top=top-1;return cc;}
[0-9]+ return num;
TRUE return tru;
FALSE return fals;
"%" return mod;
\".*\" return str;
\.[a-zA-Z_]([a-zA-Z0-9_.])*|[a-zA-Z]([a-zA-Z0-9_.])* {insertIntoSym(yytext,yylineno,st[top]);return id;}

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
