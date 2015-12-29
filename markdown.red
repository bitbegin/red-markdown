Red [
    Title: "markdown parser in red"
    Version: 0.2.0
    Author: "bitbegin"
    Purpose: {
        A very small markdown parser written in red.
    }
]

context [

debug?: off
debug: func [data] [if debug? [print data]]
nochar: charset " ^-^/"
chars: complement nochar
digital: charset "0123456789"

main-rules: [
      lf
    | header-rule
    | quote-rule
    | ulist-rule
    | olist-rule
    | lang-code-rule
    | block-code-rule
    | para-rule
    | skip thru lf
]

header-rule: [
      remove ["#" some space] insert ("<h1>") to copy tag [any [some space any "#"] lf] remove tag insert "</h1>^/"
    | remove ["##" some space] insert ("<h2>") to copy tag [any [some space any "#"] lf] remove tag insert "</h2>^/"
    | remove ["###" some space] insert ("<h3>") to copy tag [any [some space any "#"] lf] remove tag insert "</h3>^/"
    | remove ["####" some space] insert ("<h4>") to copy tag [any [some space any "#"] lf] remove tag insert "</h4>^/"
    | remove ["#####" some space] insert ("<h5>") to copy tag [any [some space any "#"] lf] remove tag insert "</h5>^/"
    | remove ["######" some space] insert ("<h6>") to copy tag [any [some space any "#"] lf] remove tag insert "</h6>^/"
]

para-rule: [ahead [to lf] insert "<p>" to 2 lf remove 2 lf insert "</p>^/"]

lang-code-rule: [
      [remove ["```" any space lf] insert {<pre><code>^/"} to copy tag "```^/" remove tag insert "</code></pre>^/"]
    | [remove ["```" copy lang to [any space lf]] insert {<pre><code class="} insert (lang) insert {">^/} to copy tag "```^/" remove tag insert "</code></pre>^/"]
]

block-code-rule: [
    remove [copy indent some [space | tab]] insert "<pre><code>^/" some [to lf [
          [lf remove lf insert "</code></pre>^/" break]
        | [lf remove indent]
        | lf]]
]

quote-rule: [
    remove [copy indent [">" some space]] insert "<blockquote>" some [to lf [
          [remove [lf lf] insert "</blockquote>^/" break]
        | [remove [lf indent]]
        | lf]]
]

ulist-rule: [
    remove [copy indent [["*" | "-" | "+"] some space]] insert "<ul><li>" some [to lf [
          [remove [lf lf] insert "</li></ul>^/" break]
        | [remove [lf indent] insert "</li><li>"]
        | lf]]
]

olist-rule: [
    remove [digital "." some space] insert "<ol><li>" some [to lf [
          [remove [lf lf] insert "</li></ol>^/" break]
        | [remove [lf digital "." some space] insert "</li><li>"]
        | lf]]
]

code-inline-rule: [
    to copy tag "`" start: tag to tag :start
    remove tag insert "<code>" to tag remove tag insert "</code>"
]

emphasis-inline-rule: [
    to copy tag ["*" | "_"] start: tag to tag :start
    remove tag insert "<em>" to tag remove tag insert "</em>"
]

strong-inline-rule: [
    to copy tag ["**" | "__"] start: tag to tag :start
    remove tag insert "<strong>" to tag remove tag insert "</strong>"
]

link-inline-rule: [
      to "![" remove ["![" copy text to "](" "](" copy link to ")" ")" (
        title: none 
        if find/tail link space [
            title: copy find/tail link space
            link: copy/part link find link space])
        if (title)][insert {<img src="} insert (link) insert {" alt="} insert (text) insert {" title=} insert (title) insert { />}]
    | to "![" remove ["![" copy text to "](" "](" copy link to ")" ")" (
        title: none 
        if find/tail link space [
            title: copy find/tail link space
            link: copy/part link find link space])
        if (not title)][insert {<img src="} insert (link) insert {" alt="} insert (text) insert {" />}]
    | to "[" remove ["[" copy text to "](" "](" copy link to ")" ")" (
        title: none 
        if find/tail link space [
            title: copy find/tail link space
            link: copy/part link find link space])
        if (not title)][insert {<a href="} insert (link) insert {">} insert (text) insert {</a>}]
    | to "[" remove ["[" copy text to "](" "](" copy link to ")" ")" (
        title: none 
        if find/tail link space [
            title: copy find/tail link space
            link: copy/part link find link space])
        if (title)][insert {<a href="} insert (link) insert {" title=} insert (title) insert {>} insert (text) insert {</a>}] 
]

parse-code-inline: [
    thru copy btag ["<p>" | "<h1>" | "<h2>" | "<h3>" | "<h4>" | "<h5>" | "<h6>"] (btag: head insert next btag "/") copy inline-text start: to btag 
        :start remove to btag
            insert (parse inline-text [ahead any code-inline-rule ahead any strong-inline-rule ahead any emphasis-inline-rule any link-inline-rule] inline-text)]


set 'parse-markdown function [str [string!] return: [string!]] [
    parse str [any main-rules]
    parse str [any parse-code-inline]
    str
]

]

