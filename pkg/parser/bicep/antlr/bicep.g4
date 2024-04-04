grammar bicep;

// program -> statement* EOF
program: statement* EOF;

statement: parameterDecl | variableDecl | resourceDecl | NL;

// parameterDecl -> decorator* "parameter" IDENTIFIER(name) typeExpression parameterDefaultValue? NL
// | decorator* "parameter" IDENTIFIER(name) "resource" interpString(type) parameterDefaultValue? NL
// |
parameterDecl:
	decorator* PARAM name = identifier (
		typeExpression parameterDefaultValue?
		| RESOURCE type = interpString parameterDefaultValue?
	) NL;

// parameterDefaultValue -> "=" expression
parameterDefaultValue: ASSIGN expression;

// variableDecl -> decorator* "variable" IDENTIFIER(name) "=" expression NL
variableDecl:
	decorator* VAR name = identifier ASSIGN expression NL;

// resourceDecl -> decorator* "resource" IDENTIFIER(name) interpString(type) "existing"? "=" (ifCondition | object | forExpression) NL
resourceDecl:
	decorator* RESOURCE name = identifier type = interpString ASSIGN (
		object
	) NL;

// interpString ->  stringLeftPiece ( expression stringMiddlePiece )* expression stringRightPiece | stringComplete
interpString:
	STRING_LEFT_PIECE (expression STRING_MIDDLE_PIECE)* expression STRING_RIGHT_PIECE
	| STRING_COMPLETE;

// expression -> expression "[" expression "]" | expression "." IDENTIFIER(property) | expression
// ":" IDENTIFIER(name)
expression:
	expression OBRACK expression CBRACK
	| expression DOT property = identifier
	| expression COL name = identifier
	| primaryExpression;

// primaryExpression -> literalValue | interpString | multilineString | array | object |
// parenthesizedExpression
primaryExpression:
	literalValue
	| functionCall
	| interpString
	| MULTILINE_STRING
	| array
	| object
	| parenthesizedExpression;

// parenthesizedExpression -> "(" expression ")"
parenthesizedExpression: OPAR NL? expression NL? CPAR;

// typeExpression -> singularTypeExpression ("|" singularTypeExpression)*
typeExpression: type = identifier;

// literalValue -> NUMBER | "true" | "false" | "null"
literalValue: NUMBER | TRUE | FALSE | NULL | identifier;

// object -> "{" ( NL+ ( objectProperty NL+ )* )? "}"
object: OBRACE (NL+ ( objectProperty NL+)*)? CBRACE;

// objectProperty -> ( IDENTIFIER(name) | interpString ) ":" expression
objectProperty: (name = identifier | interpString) COL expression;

// array -> "[" NL* arrayItem* "]"
array: OBRACK NL* arrayItem* CBRACK;

// arrayItem -> expression (NL+|COMMA)?
arrayItem: expression (NL+|COMMA)?;

// decorator -> "@" decoratorExpression NL
decorator: AT decoratorExpression NL;

// decoratorExpression -> functionCall | memberExpression "." functionCall
decoratorExpression: functionCall | expression DOT functionCall;

// functionCall -> IDENTIFIER "(" argumentList? ")"
functionCall: identifier OPAR (NL? argumentList)? NL? CPAR;

// argumentList -> expression ("," expression)*
argumentList: expression (COMMA NL? expression)*;

identifier:
	IDENTIFIER
	| PARAM
	| RESOURCE
	| VAR
	| TRUE
	| FALSE
	| NULL
	| STRING
	| INT
	| BOOL
	| OBJECT;

// multilineString -> "'''" + MULTILINESTRINGCHAR+ + "'''"
MULTILINE_STRING: '\'\'\'' .*? '\'\'\'';

AT: '@';

COMMA: ',';

OBRACK: '[';

CBRACK: ']';

OPAR: '(';

CPAR: ')';

DOT: '.';

PIPE: '|';

COL: ':';

ASSIGN: '=';

OBRACE: '{';

CBRACE: '}';

PARAM: 'param';

VAR: 'var';

TRUE: 'true';

FALSE: 'false';

NULL: 'null';

OBJECT: 'object';

RESOURCE: 'resource';

// stringLeftPiece -> "'" STRINGCHAR* "${"
STRING_LEFT_PIECE: '\'' STRINGCHAR* '${';

// stringMiddlePiece -> "}" STRINGCHAR* "${"
STRING_MIDDLE_PIECE: '}' STRINGCHAR* '${';

// stringRightPiece -> "}" STRINGCHAR* "'"
STRING_RIGHT_PIECE: '}' STRINGCHAR* '\'';

// stringComplete -> "'" STRINGCHAR* "'"
STRING_COMPLETE: '\'' STRINGCHAR* '\'';

STRING: 'string';

INT: 'int';

BOOL: 'bool';

IDENTIFIER: [a-zA-Z_] [a-zA-Z_0-9]*;

NUMBER: [0-9]+ ('.' [0-9]+)?;

// NL -> ("\n" | "\r")+
NL: [\r\n]+;

SPACES: [ \t]+ -> skip;

UNKNOWN: .;

fragment STRINGCHAR: ~[\\'\n\r\t$] | ESCAPE;

fragment ESCAPE: '\\' ([\\'nrt$] | 'u{' HEX+ '}');

fragment HEX: [0-9a-fA-F];