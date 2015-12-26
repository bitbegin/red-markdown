Red []

debug?: on
debug: func [data] [if debug? [print data]]

nochar: charset " ^-^/"
chars: complement nochar

commands: [
      lf (last-rule-is-lf: true buffers: copy "")
    | header-rule
    | quote-rule
    | list-rule
    | lang-code-rule
    | block-code-rule
    | para-rule
    | skip
]

;parse header
header-rule: [
      "######" some space keep ("<h6>") keep to [any [some space any "#"] lf] lf keep ("</h6>^/") 
    | "#####" some space keep ("<h5>") keep to [any [some space any "#"] lf] lf keep ("</h5>^/")
    | "####" some space keep ("<h4>") keep to [any [some space any "#"] lf] lf keep ("</h4>^/")
    | "###" some space keep ("<h3>") keep to [any [some space any "#"] lf] lf keep ("</h3>^/")
    | "##" some space keep ("<h2>") keep to [any [some space any "#"] lf] lf keep ("</h2>^/")
    | "#" some space keep ("<h1>") keep to [any [some space any "#"] lf] lf keep ("</h1>^/")
]

;parse paragraph
para-rule: [copy para to 2 lf 2 lf keep ("<p>") keep (para) keep ("</p>^/")]

;parse lang code
lang-code-rule: [
    "```" copy lang to lf lf copy codes to "```^/" "```^/" (debug ["lang:" lang])
    keep (append (append {<pre><code class="} lang) {">^/}) keep (codes) keep ("</code></pre>^/")
]

;parse code block
block-code-rule: [
    copy indent some [space | tab] copy codes to [lf [chars | lf]] lf (debug ["codes:^/" codes])
    keep (append (append copy "<pre><code>^/" indent) codes) keep ("</code></pre>^/")
]

;parse quote
quote-rule: [
      [">" some space copy quote to lf lf next: [">" some space] :next (append buffers quote debug ["continue quote: " quote]) quote-rule]
    | [">" some space copy quote to lf lf next: [lf | chars] :next keep (append buffers quote debug ["final quote: " quote] append copy "<blockquote>" buffers) keep ("</blockquote>^/")]
]

;parse list
list-rule: [
      [["*" | "-" | "+"] some space copy list to lf lf next: [["*" | "-" | "+"] some space] :next (append buffers append (append copy "<li>" list) "</li>" debug ["continue list: " list]) list-rule]
    | [["*" | "-" | "+"] some space copy list to lf lf next: [lf | chars] :next keep (append buffers append (append copy "<li>" list) "</li>" debug ["final list: " list] append copy "<ol>" buffers) keep ("</ol>^/")]
]

str: read %test.md
res: parse str rules: [collect [any commands]]

write %out.html form res
