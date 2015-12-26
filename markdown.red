Red []

debug?: on
debug: func [data] [if debug? [print data]]


commands: [
    header-rule
    | skip
]

header-rule: [
    "######" some space keep ("<h6>") keep to [any [some space any "#"] next: lf] keep ("</h6>^/") :next lf
    | "#####" some space keep ("<h5>") keep to [any [some space any "#"] next: lf] keep ("</h5>^/") :next lf
    | "####" some space keep ("<h4>") keep to [any [some space any "#"] next: lf] keep ("</h4>^/") :next lf
    | "###" some space keep ("<h3>") keep to [any [some space any "#"] next: lf] keep ("</h3>^/") :next lf
    | "##" some space keep ("<h2>") keep to [any [some space any "#"] next: lf] keep ("</h2>^/") :next lf
    | "#" some space keep ("<h1>") keep to [any [some space any "#"] next: lf] keep ("</h1>^/") :next lf
]


str: read %test.md
res: parse str rules: [collect [any commands]]
