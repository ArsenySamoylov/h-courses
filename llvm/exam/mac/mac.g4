grammar mac;

mac
    : HEXPAIR ':' HEXPAIR ':' HEXPAIR ':'
      HEXPAIR ':' HEXPAIR ':' HEXPAIR EOF
    ;

HEXPAIR
    : HEX HEX
    ;

fragment HEX
    : [0-9A-F]
    ;

WS
    : [ \t\r\n]+ -> skip
    ;