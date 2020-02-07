%{
  
%}

comment1   (['"])\1\1[\d\D]*?\1{3}
comment2    #.*\n
%%

{comment1}    ;
{comment2}    ;
.|\n        ECHO;

%%
main()
{
    yylex();
    return 0;
}

