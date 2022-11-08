%{
#include<stdio.h>
#include<string.h>
#include<stdarg.h>

extern char* yytext;
extern int yylex();

void yyerror(char *s);
FILE* input_file = NULL;

extern int n_coluna;
extern int n_linha;

void print_line(FILE* input, int n){
	int i = 1;
	char c;
	fseek(input, 0, SEEK_SET);
	while(i < n){
		c = fgetc(input);
		if(c == EOF){
            break;
        }
		else if(c == '\n'){
            i++;
        }
	}
	c = fgetc(input);
	while(c != '\n' && c != EOF){
		printf("%c", c);
		c = fgetc(input);
	}
	printf("\n");
}

%}

%token VOID_T
%token INT_T
%token CHAR_T
%token RETURN_T
%token DO_T
%token WHILE_T
%token FOR_T
%token IF_T
%token ELSE_T
%token ADD_T
%token SUB_T
%token ASTERISK_T
%token DIV_T
%token MOD_T
%token INC_T
%token DEC_T
%token AMPERSAND_T
%token BIT_OR_T
%token BIT_NOT_T
%token BIT_XOR_T
%token LOG_AND_T
%token LOG_OR_T
%token LOG_NOT_T
%token EQUALS_T
%token NOT_EQUALS_T
%token LESS_T
%token GREAT_T
%token LEQ_T
%token GEQ_T
%token RSHIFT_T
%token LSHIFT_T
%token ASSIGN_T
%token ADD_ASSIGN_T
%token SUB_ASSIGN_T
%token SEMICOLON_T
%token COMMA_T
%token COLON_T
%token LPAREN_T
%token RPAREN_T
%token LCBRACK_T
%token RCBRACK_T
%token LBRACK_T
%token RBRACK_T
%token QUEST_MARK_T
%token NUMBER_SIGN_T
%token DEFINE_T
%token PRINTF_T
%token SCANF_T
%token EXIT_T
%token NUM_HEXA_T
%token NUM_OCTA_T
%token NUM_INT_T
%token CHARACTER_T
%token STRING_T
%token IDENTIFIER_T
%token UNTERMINATED_COMMENT_T
%token IDENTIFIER_TOO_LONG_T
%token OTHER
%token END_OF_FILE


//não utilizados
%token BREAK_T
%token SWITCH_T
%token CASE_T
%token DEFAULT_T
%token TYPEDEF_T
%token STRUCT_T
%token POINTER_DEFERENCE_T

%start programa

%%

programa: program programa END_OF_FILE		{printf("SUCCESSFUL COMPILATION."); return 0;}
		| program END_OF_FILE		    	{printf("SUCCESSFUL COMPILATION."); return 0;}
;

program: declaracao {}
	   | funcao 	{}
;

declaracao: NUMBER_SIGN_T DEFINE_T IDENTIFIER_T expressao   {}
          | declaracao_var                              	{}
          | declaracao_prot                             	{}
;

funcao: tipo pointer IDENTIFIER_T parametros LCBRACK_T dec_var_func comandos RCBRACK_T	{}
;

dec_var_func: declaracao_var dec_var_func	{}
		    |              				    {}
;

declaracao_var: tipo dec_var SEMICOLON_T {}
;

dec_var: pointer IDENTIFIER_T array ASSIGN_T atribuicao dec_var_aux {}
       | pointer IDENTIFIER_T array dec_var_aux       				{}
;

dec_var_aux: COMMA_T dec_var {}
           |               	 {}
;

declaracao_prot: tipo pointer IDENTIFIER_T parametros SEMICOLON_T	{}
;

parametros: LPAREN_T param RPAREN_T	{}
	 	  | LPAREN_T RPAREN_T		{}
;

param: tipo pointer IDENTIFIER_T array param_aux	{}
;

param_aux: COMMA_T param	{}
		 |         			{}
;

array: LBRACK_T expressao RBRACK_T array	{}
	 |              						{}
;

tipo: INT_T		{}
	| CHAR_T	{}
	| VOID_T	{}
;

bloco: LCBRACK_T comandos RCBRACK_T	{}
;

comandos: lista_comandos comandos	{}
		| lista_comandos			{}
;

lista_comandos: DO_T bloco WHILE_T LPAREN_T expressao RPAREN_T SEMICOLON_T	                                	{}
			  | IF_T LPAREN_T expressao RPAREN_T bloco else_exp				                                	{}
			  | WHILE_T LPAREN_T expressao RPAREN_T bloco					                                	{}
			  | FOR_T LPAREN_T exp_opcional SEMICOLON_T exp_opcional SEMICOLON_T exp_opcional RPAREN_T bloco	{}
			  | PRINTF_T LPAREN_T STRING_T printf_exp RPAREN_T SEMICOLON_T		                                {}
			  | SCANF_T LPAREN_T STRING_T COMMA_T AMPERSAND_T IDENTIFIER_T RPAREN_T SEMICOLON_T		            {}
			  | EXIT_T LPAREN_T expressao RPAREN_T SEMICOLON_T				                                	{}
			  | RETURN_T exp_opcional SEMICOLON_T								                            	{}
			  | expressao SEMICOLON_T										                                	{}
			  | SEMICOLON_T												                                		{}
			  | bloco													                                		{}
;

printf_exp: COMMA_T expressao	{}
		  |             	{}
;

else_exp: ELSE_T bloco		{}
		|               	{}
;

exp_opcional: expressao		{}
	   		|            	{}
;

expressao: atribuicao                   {}
         | atribuicao COMMA_T expressao {}
;

atribuicao: exp_cond                         		 {}
          | exp_unaria atribuicao_aux atribuicao     {}
;

atribuicao_aux: ASSIGN_T 	 {}
			  | ADD_ASSIGN_T {}
			  | SUB_ASSIGN_T {}
;

exp_cond: exp_or_log                                         {}
        | exp_or_log QUEST_MARK_T expressao COLON_T exp_cond {}
;

exp_or_log: exp_and_log                      {}
          | exp_and_log LOG_OR_T exp_or_log  {}
;

exp_and_log: exp_or                 	   {}
           | exp_or LOG_AND_T exp_and_log  {}
;

exp_or: exp_xor                  {}
      | exp_xor BIT_OR_T exp_or  {}
;

exp_xor: exp_and                   {}
       | exp_and BIT_XOR_T exp_xor {}
;

exp_and: exp_igualdade                     {}
       | exp_igualdade AMPERSAND_T exp_and {}
;

exp_igualdade: exp_relacional                          			  {}
             | exp_relacional exp_igualdade_aux exp_igualdade     {}
;

exp_igualdade_aux: EQUALS_T 	{}
				 | NOT_EQUALS_T {}
;

exp_relacional: exp_shift					    			  {}
		      | exp_shift exp_relacional_aux exp_relacional   {}
;

exp_relacional_aux: LESS_T  {}
				  | LEQ_T   {}
				  | GEQ_T   {}
				  | GREAT_T {}
;

exp_shift: exp_add							{}
		 | exp_add exp_shift_aux exp_shift	{}
;

exp_shift_aux: LSHIFT_T {}
			 | RSHIFT_T {}
;

exp_add: exp_mult						{}
	   | exp_mult exp_add_aux exp_add	{}
;

exp_add_aux: ADD_T {}
		   | SUB_T {}
;

exp_mult: exp_cast							{}
		| exp_cast exp_mult_aux exp_mult	{}
;

exp_mult_aux: ASTERISK_T {}
			| DIV_T	     {}
			| MOD_T	     {}
;

exp_cast: exp_unaria							    {}
		| LPAREN_T tipo pointer RPAREN_T exp_cast	{}
;

exp_unaria: exp_posfixa				{}
		  | INC_T exp_unaria		{}
		  | DEC_T exp_unaria		{}
		  | exp_un_aux exp_cast		{}
;

exp_un_aux: AMPERSAND_T     {}
		  | ADD_T			{}
		  | SUB_T			{}
		  | BIT_NOT_T		{}
		  | LOG_NOT_T		{}
;

exp_posfixa: exp_prim				                            	{}
		   | exp_posfixa INC_T		                            	{}
		   | exp_posfixa DEC_T		                            	{}
		   | exp_posfixa LBRACK_T expressao RBRACK_T			    {}
		   | exp_posfixa LPAREN_T RPAREN_T						    {}
		   | exp_posfixa LPAREN_T atribuicao exp_pf_aux RPAREN_T	{}
;

exp_pf_aux: COMMA_T atribuicao exp_pf_aux	{}
		  |       					    	{}
;

exp_prim: IDENTIFIER_T	            	{}
		| num               			{}
		| CHARACTER_T		            {}
		| STRING_T		            	{}
		| LPAREN_T expressao RPAREN_T	{}
;

num: NUM_INT_T	{}
   | NUM_HEXA_T	{}
   | NUM_OCTA_T	{}
;

pointer: ASTERISK_T pointer {}
       |         		    {}
;

%%

void yyerror(char *s){
	int i = 1;
	switch(yychar){
		case IDENTIFIER_TOO_LONG_T:
			printf("error:lexical:%d:%d: identifier too long", n_linha, n_coluna);
			break;

		case UNTERMINATED_COMMENT_T:
			printf("error:lexical:%d:%d: unterminated comment", n_linha, n_coluna);
			break;
		case OTHER:
			n_coluna -= strlen(yytext);
			printf("error:lexical:%d:%d: %s", n_linha, n_coluna, yytext);
			break;
		case END_OF_FILE:
			printf("error:syntax:%d:%d: expected declaration or statement at end of input\n", n_linha, n_coluna);
			print_line(input_file, n_linha);
			for(i; i < n_coluna; i++){ 
                printf(" "); 
            }
			printf("^");
			break;
		default:
			n_coluna -= strlen(yytext);
			printf("error:syntax:%d:%d: %s\n", n_linha, n_coluna, yytext);
			print_line(input_file, n_linha);
			for(i; i < n_coluna; i++){ 
                printf(" "); 
            }
			printf("^");
			break;
	}
}

int main(int argc, char **argv){
	input_file = stdin;
	yyparse();
    return 0;
}
