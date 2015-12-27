Red [
    Title: "markdown parser in red"
    Version: 0.1.0
    Author: "bitbegin"
    Purpose: {
        A very small markdown parser written in red.
    }
]

context [;context begin

debug?: off
debug: func [data] [if debug? [print data]]
nochar: charset " ^-^/"
chars: complement nochar
digital: charset "0123456789"

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
para-rule: [copy para to 2 lf 2 lf keep ("<p>") keep (inline-format copy para) keep ("</p>^/")]

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
      [copy tag ["*" | "-" | "+"] some space copy list to lf lf next: [tag some space] :next (append buffers append (append copy "<li>" list) "</li>" debug ["continue list: " list]) ulist-rule]
    | [copy tag ["*" | "-" | "+"] some space copy list to lf lf next: [lf | chars] :next keep (append buffers append (append copy "<li>" list) "</li>" debug ["final list: " list] append copy "<ul>" buffers) keep ("</ul>^/")]
]

;parse list
olist-rule: [
      [some digital "." some space copy list to lf lf next: [some digital "." some space] :next (append buffers append (append copy "<li>" list) "</li>" debug ["continue list: " list]) olist-rule]
    | [some digital "." some space copy list to lf lf next: [lf | chars] :next keep (append buffers append (append copy "<li>" list) "</li>" debug ["final list: " list] append copy "<ol>" buffers) keep ("</ol>^/")]
]

;inline format
inline-format: function [buff [string!] return: [string!]][
    code-format buff
    ;debug ["code-format:" lf buff]
    strong-format buff
    ;debug ["strong-format:" lf buff]
    emphasis-format buff
    ;debug ["emphasis-format:" lf buff]
    link-format buff
    ;debug ["link-format:" lf buff]
    buff
]

;parse code inline
code-format: function [buff [string!] return: [string!]][
    parse buff [any code-inline-rule]
]

;code inline rule
code-inline-rule: [
    to copy tag "`" start: tag to tag tag :start
    remove tag insert "<code>" to tag remove tag insert "</code>"
]

;parse emphasis inline
emphasis-format: function [buff [string!] return: [string!]][
    parse buff [any emphasis-inline-rule]
]

;emphasis inline rule
emphasis-inline-rule: [
    to copy tag ["*" | "_"] start: tag to tag tag :start
    remove tag insert "<em>" to tag remove tag insert "</em>"
]

;parse strong inline
strong-format: function [buff [string!] return: [string!]][
    parse buff [any strong-inline-rule]
]

;strong inline rule
strong-inline-rule: [
    to copy tag ["**" | "__"] start: tag to tag tag :start
    remove tag insert "<strong>" to tag remove tag insert "</strong>"
]


;parse link inline
link-format: function [buff [string!] return: [string!]][
    parse buff [any link-inline-rule]
]

;link inline rule
link-inline-rule: [
      to "![" stop: "![" copy text to "](" "](" copy link to ")" ")" (remove/part stop (2 + 2 + 1 + (length? text) + (length? link))  
        links: copy "" 
        either find/tail link space [
            title: copy find/tail link space
            link: copy/part link find link space
            append (append (append (append (append (append (append links {<img src="}) link) {" alt="}) text) {" title=}) title) { />}
        ][
            append (append (append (append (append links {<img src="}) link) {" alt="}) text) {" />}
        ]
        stop: insert stop links) :stop    
    | to "[" stop: "[" copy text to "](" "](" copy link to ")" ")" (remove/part stop (1 + 2 + 1 + (length? text) + (length? link))  
        links: copy "" 
        either find/tail link space [
            title: copy find/tail link space
            link: copy/part link find link space
            append (append (append (append (append (append (append links {<a href="}) link) {" title=}) title) {>}) text) {</a>}
        ][
            append (append (append (append (append links {<a href="}) link) {">}) text) {</a>}
        ]
        stop: insert stop links) :stop    
]

set 'parse-markdown function [str [string!] return: [string!]] [
    parse str [collect [any rules]]
]

];context end

