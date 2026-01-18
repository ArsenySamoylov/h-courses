grammar MiniGo;

/* =======================
   Parser rules
   ======================= */
program: (topLevelDecl)* EOF;

topLevelDecl: constDecl | funcDecl;
// TODO: for now const can be only global
constDecl: 'const' ID '=' expr;

funcDecl: 'func' ID '(' ')' block;
block: '{' statement* '}';
statement: block | varDecl | assignStmt | ifStmt | forStmt | exprStmt;
ifStmt: 'if' expr block ('else' block)?;
forStmt: 'for' expr block;
varDecl: 'var' ID type ('=' expr)?;
assignStmt: ID '=' expr;
exprStmt: expr;

/* ---------- Types      ---------- */
type: 'int' | 'bool';

/* ---------- Expressions ---------- */
expr: comparisonExpr;

comparisonExpr: additiveExpr ( (LT | GT) additiveExpr )*;
additiveExpr: multiplicativeExpr ( (PLUS | MINUS) multiplicativeExpr )*;
multiplicativeExpr: primary ( (STAR | DIV | MOD) primary )*;

primary: literal | ID argList? | '(' expr ')';

argList: '(' (expr (',' expr)*)? ')';

/* ---------- Literals ---------- */

literal: INT | HEX | BOOL;

/* =======================
   Lexer rules
   ======================= */

BOOL: 'true' | 'false';
ID: [a-zA-Z_]+;
INT: [0-9]+;

HEX: '0x' [0-9a-fA-F]+;


/* --- Operators --- */

PLUS  : '+' ;
MINUS : '-' ;

STAR  : '*' ;
DIV   : '/' ;
MOD   : '%' ;

LT    : '<' ;
GT    : '>' ;

/* ---------- Whitespace & comments ---------- */

WS: [ \t\r\n]+ -> skip;
LINE_COMMENT: '//' ~[\r\n]* -> skip;
BLOCK_COMMENT: '/*' .*? '*/' -> skip;
