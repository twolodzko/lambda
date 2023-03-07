%{
open Term
%}

%token <string> ID
%token LPAREN "("
%token RPAREN ")"
%token LAMBDA "λ"
%token DOT "."
%token EQ "="
%token END
%token EOF

%start <Term.term option> prog
%%

let prog :=
  | EOF; { None }
  | END; p = prog; { p }
  | t = term; line_end; { Some t }
  | e = equals; line_end; { Some e }

let line_end := END | EOF

let equals :=
  | x = term; "="; y = term; { Def (x, y) }

let variable :=
  | x = ID; { Var x }

let element :=
  | variable
  | "("; x = term; ")"; { x }

let application :=
  | element
  | t = application; u = element; { App (t, u) }

let abstraction :=
  | "λ"; x = ID; u = body; { Abs (x, u) }

let body :=
  | "."; u = term; { u }
  | x = ID; u = body; { Abs (x, u) }

let term :=
  | application
  | abstraction
