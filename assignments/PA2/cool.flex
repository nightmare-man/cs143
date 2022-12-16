/*
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");
#define CHECK_STR_LEN(len,e_msg) \
	if((len)>=MAX_STR_CONST){cool_yylval.error_msg=(e_msg);BEGIN(INITIAL);return ERROR;}else{len++;}
char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;
char *str_long_msg="string constant too long";
extern int curr_lineno;
extern int verbose_flag;
int str_len;
extern YYSTYPE cool_yylval;

/*
 *  Add Your own definitions here
 */
%}

/*
 * Define names for regular expressions here.
 */
DARROW          =>
ASSIGN          <-
%x COM STR
%%
 /*
  *  Nested comments
  */
\(\* {BEGIN(COM);}
<COM>"*"+")" {BEGIN(INITIAL);}
<COM><<EOF>> {cool_yylval.error_msg="an unclosed comment";BEGIN(INITIAL);return ERROR;}
<COM>\n {curr_lineno++;}
<COM>[^*\n]*
<COM>"*"+[^*)\n]*
--.*[\n<<EOF>>] {}
"*"+")" {cool_yylval.error_msg="unmatched *)";return ERROR;}
 /*
  *string
  */

\" {string_buf_ptr=string_buf;str_len=0;BEGIN(STR);}
<STR>\\b {CHECK_STR_LEN(str_len,str_long_msg) *string_buf_ptr++='\b';}
<STR>\\t {CHECK_STR_LEN(str_len,str_long_msg) *string_buf_ptr++='\t';}
<STR>\\n {CHECK_STR_LEN(str_len,str_long_msg) *string_buf_ptr++='\n';}
<STR>\\f {CHECK_STR_LEN(str_len,str_long_msg) *string_buf_ptr++='\f';}
<STR>\n {curr_lineno++;cool_yylval.error_msg="illegal newline";BEGIN(INITIAL);return ERROR;}
<STR><<EOF>> {cool_yylval.error_msg="an unclosed string";BEGIN(INITIAL);return ERROR;}
<STR>\0 {cool_yylval.error_msg="an unclosed string";BEGIN(INITIAL);return ERROR;}
<STR>\\(.|\n) {CHECK_STR_LEN(str_len,str_long_msg) *string_buf_ptr++=yytext[1];}
<STR>[^\\\n\"]+ {char *temp=yytext;while(*temp){CHECK_STR_LEN(str_len,str_long_msg) *string_buf_ptr++=*temp++;}}
<STR>\" { *string_buf_ptr='\0';BEGIN(INITIAL);cool_yylval.symbol=stringtable.add_string(string_buf);return STR_CONST;}
 /*
  * white space
  */
\n {curr_lineno++;}
(\040|\014|\015|\011|\013) {}
 /*
  * Keywords are case-insensitive except for the values true and false,
  * which must begin with a lower-case letter.
  */
(?i:class) {return CLASS;}
(?i:else) {return ELSE;}
(?i:fi) {return FI;}
(?i:if) {return IF;}
(?i:in) {return IN;}
(?i:INHERITS) {return INHERITS;}
(?i:let) {return LET;}
(?i:loop) {return LOOP;}
(?i:pool) {return POOL;}
(?i:then) {return THEN;}
(?i:while) {return WHILE;}
(?i:case) {return CASE;}
(?i:esac) {return ESAC;}
(?i:of) {return OF;}
{DARROW} {return (DARROW);}
{ASSIGN} {return (ASSIGN);}
(?i:new) {return NEW;}
(?i:isvoid) {return ISVOID;}
(?i:not) {return NOT;}
(?i:true) {cool_yylval.boolean=1;return BOOL_CONST;}
(?i:false) {cool_yylval.boolean=0;return BOOL_CONST;}
 /*
  *special notation
  */
";" {return ';';}
"{" {return '{';}
"}" {return '}';}
"(" {return '(';}
")" {return ')';}
":" {return ':';}
"."  {return '.';}
"," {return ',';}
"+" {return '+';}
"-" {return '-';}
"*" {return '*';}
"/" {return '/';}
"~" {return '~';}
"=" {return '=';}
"<" {return '<';}
 /*
  *identifier
  */
([a-z][a-zA-Z0-9_]*) {cool_yylval.symbol=idtable.add_string(yytext);return OBJECTID; }
([A-Z][a-zA-Z0-9_]*) {cool_yylval.symbol=idtable.add_string(yytext);return TYPEID;}
 /*
  *interger
  */
([0-9]+) {cool_yylval.symbol=inttable.add_string(yytext);return INT_CONST;}
 /*
  *unmatched characters
  */
. {cool_yylval.error_msg=yytext;return ERROR;} 

%%
