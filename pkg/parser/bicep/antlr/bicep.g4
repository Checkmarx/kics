grammar bicep;

// program -> statement* EOF
program: statement* EOF;

statement: parameterDecl | variableDecl | resourceDecl | outputDecl | NL;

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
		ifCondition
        | object
        | forExpression
	) NL;

outputDecl: 
	decorator* OUTPUT name = identifier (type1 = identifier | RESOURCE type2 = interpString) ASSIGN expression NL;

// ifCondition -> "if" parenthesizedExpression object
ifCondition
    : IF parenthesizedExpression object
    ;

// forExpression -> "[" "for" (IDENTIFIER(item) | forVariableBlock) "in" expression ":" forBody "]"
forExpression
    : OBRACK NL* FOR (item = identifier | forVariableBlock) IN expression COL forBody NL* CBRACK
    ;

// forVariableBlock -> "(" IDENTIFIER(item) "," IDENTIFIER(index) ")"
forVariableBlock
    : OPAR item = identifier COMMA index = identifier CPAR
    ;

// forBody -> expression(body) | ifCondition
forBody
    : body = expression
    | ifCondition
    ;

// interpString ->  stringLeftPiece ( expression stringMiddlePiece )* expression stringRightPiece | stringComplete
interpString:
	STRING_LEFT_PIECE (expression STRING_MIDDLE_PIECE)* expression STRING_RIGHT_PIECE
	| STRING_COMPLETE;

// expression -> expression "[" expression "]" | expression "." IDENTIFIER(property) | expression
// ":" IDENTIFIER(name)
expression:
	expression OBRACK expression CBRACK
	| expression QMARK expression COL expression
	| expression DOT property = identifier
	| expression COL name = identifier
	| expression COL COL name = identifier
	| expression logicCharacter expression
	| primaryExpression;

logicCharacter: (GT | GTE | LT | LTE | EQ | NEQ);

// primaryExpression -> literalValue | interpString | multilineString | array | object |
// parenthesizedExpression
primaryExpression:
	literalValue
	| functionCall
	| interpString
	| MULTILINE_STRING
	| array
	| object
	| forExpression
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

OUTPUT: 'output';

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

IF
    : 'if'
    ;

FOR
    : 'for'
    ;

IN
    : 'in'
    ;

QMARK
	: '?'
	;

GT
    : '>'
    ;

GTE
    : '>='
    ;

LT
    : '<'
    ;

LTE
    : '<='
    ;

EQ
    : '=='
    ;

NEQ
    : '!='
    ;

IDENTIFIER: [a-zA-Z_] [a-zA-Z_0-9]*;

NUMBER: [0-9]+ ('.' [0-9]+)?;

// NL -> ("\n" | "\r")+
NL: [\r\n]+;

SPACES: [ \t]+ -> skip;

UNKNOWN: .;

SINGLE_LINE_COMMENT: '//' ~[\r\n]* -> skip;

MULTI_LINE_COMMENT: '/*' .*? '*/' -> skip;

fragment STRINGCHAR: ~[\\'\n\r\t$] | ESCAPE;

fragment ESCAPE: '\\' ([\\'nrt$] | 'u{' HEX+ '}');

fragment HEX: [0-9a-fA-F];