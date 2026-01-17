grammar MiniGo;

/* =======================
   Parser rules
   ======================= */
program: (topLevelDecl)* EOF;

topLevelDecl: constDecl;
constDecl: 'const' ID '=' expr;

/* ---------- Expressions ---------- */
expr: comparisonExpr;

comparisonExpr: additiveExpr ( (LT | GT) additiveExpr )*;
additiveExpr: multiplicativeExpr ( (PLUS | MINUS) multiplicativeExpr )*;
multiplicativeExpr: primary ( (STAR | DIV) primary )*;

primary: literal | ID | '(' expr ')';


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
LT    : '<' ;
GT    : '>' ;

/* ---------- Whitespace & comments ---------- */

WS: [ \t\r\n]+ -> skip;
LINE_COMMENT: '//' ~[\r\n]* -> skip;
BLOCK_COMMENT: '/*' .*? '*/' -> skip;
