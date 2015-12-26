Red []

debug?: on
debug: func [data] [if debug? [print data]]

nochar: charset " ^-^/"
chars: complement nochar

commands: [
    lf
    | header-rule
    | code-rule
	| para-rule
    | skip
]

;parse markdown header
header-rule: [
      "######" some space keep ("<h6>") keep to [any [some space any "#"] lf] lf keep ("</h6>^/") 
    | "#####" some space keep ("<h5>") keep to [any [some space any "#"] lf] lf keep ("</h5>^/")
    | "####" some space keep ("<h4>") keep to [any [some space any "#"] lf] lf keep ("</h4>^/")
    | "###" some space keep ("<h3>") keep to [any [some space any "#"] lf] lf keep ("</h3>^/")
    | "##" some space keep ("<h2>") keep to [any [some space any "#"] lf] lf keep ("</h2>^/")
    | "#" some space keep ("<h1>") keep to [any [some space any "#"] lf] lf keep ("</h1>^/")
]

;parse markdown paragraph
para-rule: [copy para to 2 lf 2 lf keep ("<p>") keep (para) keep ("</p>^/")]

;parse markdown code
code-rule: [
	"```" copy lang to lf lf copy codes to "```^/" "```^/"
	keep (append (append {<code class="} lang) {">}) keep (codes) keep ("</code>^/")
]


str: read %test.md
res: parse str rules: [collect [any commands]]

write %out.html form res
