Red []

debug?: on
debug: func [data] [if debug? [print data]]

nochar: charset " ^-^/"
chars: complement nochar
digital: charset "0123456789"

context [;context begin

rules: [
      lf (last-rule-is-lf: true buffers: copy "")
    | header-rule
    | quote-rule
    | ulist-rule
    | olist-rule
    | lang-code-rule
    | block-code-rule
    | para-rule
    | skip
]

;parse header
header-rule: [
      "######" some space copy header-text to [any [some space any "#"] lf] lf keep ("<h6>") keep (inline-format copy header-text) keep ("</h6>^/") 
    | "#####" some space copy header-text to [any [some space any "#"] lf] lf keep ("<h5>") keep (inline-format copy header-text) keep ("</h5>^/") 
    | "####" some space copy header-text to [any [some space any "#"] lf] lf keep ("<h4>") keep (inline-format copy header-text) keep ("</h4>^/") 
    | "###" some space copy header-text to [any [some space any "#"] lf] lf keep ("<h3>") keep (inline-format copy header-text) keep ("</h3>^/") 
    | "##" some space copy header-text to [any [some space any "#"] lf] lf keep ("<h2>") keep (inline-format copy header-text) keep ("</h2>^/") 
    | "#" some space copy header-text to [any [some space any "#"] lf] lf keep ("<h1>") keep (inline-format copy header-text) keep ("</h1>^/") 
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
ulist-rule: [
      [["*" | "-" | "+"] some space copy list to lf lf next: [["*" | "-" | "+"] some space] :next (append buffers append (append copy "<li>" list) "</li>" debug ["continue list: " list]) ulist-rule]
    | [["*" | "-" | "+"] some space copy list to lf lf next: [lf | chars] :next keep (append buffers append (append copy "<li>" list) "</li>" debug ["final list: " list] append copy "<ul>" buffers) keep ("</ul>^/")]
]

;parse list
olist-rule: [
      [some digital "." some space copy list to lf lf next: [some digital "." some space] :next (append buffers append (append copy "<li>" list) "</li>" debug ["continue list: " list]) olist-rule]
    | [some digital "." some space copy list to lf lf next: [lf | chars] :next keep (append buffers append (append copy "<li>" list) "</li>" debug ["final list: " list] append copy "<ol>" buffers) keep ("</ol>^/")]
]

;parse inline
inline-format: function [buff [string!] return: [string!]][
    either parse buff code-inline [
        temp-buff
    ][
        buff
    ]
]

;parse code inline
code-inline: [
    copy code-header to "`" "`" copy code-text to "`" "`" copy code-end to end (debug ["code-header: " code-header "code-text: " code-text "code-end: " code-end] temp-buff: copy code-header temp-buff: append (append (append (append temp-buff "<code>") code-text) "</code>") code-end debug temp-buff)
]

set 'parse-markdown function [str [string!] return: [string!]] [
    parse str [collect [any rules]]
]

];context end


str: read %test.md
res: parse-markdown str

write %out.html form res
