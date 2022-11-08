%option noyywrap 
%{
	#include <string.h>
	#include <sintatico.tab.h>
	int n_linha = 1;
	int n_coluna = 1;

void warning() {
	int i=0;
	for(i = 0; i < strlen(yytext); i++){
		if(yytext[i]=='\n'){
			n_linha += 1; 
			n_coluna = 1;
		}else{
			n_coluna += 1;
		}
		if(yytext[i]=='/' && i < (strlen(yytext)-1) && i > 0){
			if(yytext[i+1]=='*' && yytext[i+2] != '/')	{
				printf("warning:%d:%d: \'/*\' within block comment\n", n_linha, n_coluna-1);
			}
		}	
	}	
}

%}

%% 
"void" 		{n_coluna += 4;return VOID_T; }
"int" 		{n_coluna += 3;return INT_T; }
"char" 		{n_coluna += 4;return CHAR_T; }
"return" 	{n_coluna += 6;return RETURN_T; }
"break" 	{n_coluna += 5;return BREAK_T; }
"switch" 	{n_coluna += 6;return SWITCH_T; }
"case" 		{n_coluna += 4;return CASE_T; }
"default" 	{n_coluna += 7;return DEFAULT_T;}
"do" 		{n_coluna += 2;return DO_T;}
"while" 	{n_coluna += 5;return WHILE_T;}
"for" 		{n_coluna += 3;return FOR_T; }
"if" 		{n_coluna += 2;return IF_T; }
"else" 		{n_coluna += 4;return ELSE_T; }
"typedef" 	{n_coluna += 7;return TYPEDEF_T; }
"struct" 	{n_coluna += 6;return STRUCT_T; }
"printf" 	{n_coluna += 6;return PRINTF_T; }
"scanf" 	{n_coluna += 5;return SCANF_T; }
"exit" 		{n_coluna += 4;return EXIT_T; }
"#" 		{n_coluna += 1;return NUMBER_SIGN_T; }
"define" 	{n_coluna += 6;return DEFINE_T; }

"+" {n_coluna += 1;return ADD_T; }
"-" {n_coluna += 1;return SUB_T; }
"*" { n_coluna += 1;return ASTERISK_T;}
"/" {n_coluna += 1;return DIV_T; }
"%" {n_coluna += 1;return MOD_T; }
"++" {n_coluna += 2;return INC_T; }
"--" {n_coluna += 2;return DEC_T; }
"&" {n_coluna += 1;return AMPERSAND_T; }
"|" {n_coluna += 1;return BIT_OR_T; }
"~" {n_coluna += 1;return BIT_NOT_T; }
"^" {n_coluna += 1;return BIT_XOR_T; }
"&&" {n_coluna += 2;return LOG_AND_T; }
"||" {n_coluna += 2;return LOG_OR_T; }
"!" {n_coluna += 1;return LOG_NOT_T; }
"==" {n_coluna += 2;return EQUALS_T; }
"!=" {n_coluna += 2;return NOT_EQUALS_T; }
"<" {n_coluna += 1;return LESS_T; }
">" {n_coluna += 1;return GREAT_T; }
"<=" {n_coluna += 2;return LEQ_T; }
">=" {n_coluna += 2;return GEQ_T; }
">>" {n_coluna += 2;return RSHIFT_T; }
"<<" {n_coluna += 2;return LSHIFT_T; }
"=" {n_coluna += 1;return ASSIGN_T; }
"+=" {n_coluna += 2;return ADD_ASSIGN_T; }
"-=" {n_coluna += 2;return SUB_ASSIGN_T; }
";" {n_coluna += 1;return SEMICOLON_T; }
"," {n_coluna += 1;return COMMA_T; }
":" {n_coluna += 1;return COLON_T; }
"(" {n_coluna += 1;return LPAREN_T; }
")" {n_coluna += 1;return RPAREN_T; }
"{" {n_coluna += 1;return LCBRACK_T; }
"}" {n_coluna += 1;return RCBRACK_T; }
"[" { n_coluna += 1; return LBRACK_T;}
"]" { n_coluna += 1; return RBRACK_T;}
"?" {n_coluna += 1; return QUEST_MARK_T; }
"->" {n_coluna += 2; return POINTER_DEFERENCE_T; }
[_a-zA-Z][_a-zA-Z0-9]* {if(strlen(yytext)>255){return IDENTIFIER_TOO_LONG_T;}else{n_coluna += strlen(yytext);return IDENTIFIER_T; }}
"0"[1-7][0-7]* {n_coluna += strlen(yytext);return NUM_OCTA_T; }
[0-9]+ { n_coluna += strlen(yytext);return NUM_INT_T;}
0[xX][0-9a-fA-F]+ {n_coluna += strlen(yytext);return NUM_HEXA_T; }
["]([^"\\\n]|\\.|\\\n)*["] {n_coluna += strlen(yytext);return STRING_T;}
"\'""\\"?."\'" {n_coluna += strlen(yytext); return CHARACTER_T;}
[\r\t \f] {n_coluna += 1;}
"//".*[\n] {n_linha += 1; n_coluna = 1;}
"//".* {return END_OF_FILE;}
("/*"([^*]|[\n]|("*"+([^*/]|[\n])))*"*/") {warning();}
("/*"([^*]|[\n]|("*"+([^*/]|[\n])))*)	{return  UNTERMINATED_COMMENT_T;}
[\n] {n_linha += 1; n_coluna = 1;}
<<EOF>> {return END_OF_FILE;}
. { n_coluna += strlen(yytext); return OTHER;}

%%
