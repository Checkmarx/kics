grammar JSONFilter;

awsjsonfilter: dotnotation;
dotnotation: LCURLY filter_expr RCURLY;
filter_expr:
	LPAREN filter_expr RPAREN					# filter_expr_parenthesized
	| lhs = filter_expr AND rhs = filter_expr	# filter_expr_and
	| lhs = filter_expr OR rhs = filter_expr	# filter_expr_or
	| exp										# filter_expr_exp;
exp: selector operator (literal | qualifiedidentifier);
selector: SEL_START qualifiedidentifier;
qualifiedidentifier: member ( DOT member)*;
member: INDENTIFIER | INDENTIFIER (LBRACKET NUMBER RBRACKET)+;

operator: (EQUALS | NOT_EQUALS | IS | NOT | GT | LT | GE | LE);
literal:
	NUMBER (DOT (NUMBER | STAR))+
	| STRING
	| NUMBER
	| NULL
	| EXISTS
	| TRUE
	| FALSE
	| INDENTIFIER;
SEL_START: '$.';
STAR: '*';
LCURLY: '{';
RCURLY: '}';
LPAREN: '(';
RPAREN: ')';
LBRACKET: '[';
RBRACKET: ']';
DOT: '.';
AND: '&&';
OR: '||';
EQUALS: '=';
NOT_EQUALS: '!=';
GT: '>';
LT: '<';
GE: '>=';
LE: '<=';
IS: 'IS';
NOT: 'NOT';
// Case sensitive?
NULL: 'NULL';
EXISTS: 'EXISTS';
TRUE: 'TRUE';
FALSE: 'FALSE';
INDENTIFIER: [a-zA-Z][a-zA-Z0-9]*;
STRING: '"' (ESC | SAFECODEPOINT)* '"';
fragment ESC: '\\' (["\\/bfnrt] | UNICODE);
fragment UNICODE: 'u' HEX HEX HEX HEX;
fragment HEX: [0-9a-fA-F];
fragment SAFECODEPOINT: ~ ["\\\u0000-\u001F];
NUMBER: ('-' | '+')? INT ('.' [0-9]+)? EXP?;
fragment INT: '0' | [1-9] [0-9]*;
// no leading zeros
fragment EXP: [Ee] [+\-]? INT;
WS: [ \t\n\r]+ -> skip;
