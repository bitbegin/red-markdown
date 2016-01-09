Red [
    Title: "markdown parser in red"
    Version: 0.3.0
    Author: "bitbegin"
    Purpose: {
        A very small markdown parser written in red.
    }
]

context [

    debug?: off
    debug-print: func [data] [if debug? [print data]]
    nochar: charset " ^-^/"
    chars: complement nochar
    digit: charset [#"0" - #"9"]
    hex-char: charset [#"a" - #"f"]
    hex-digit: union digit hex-char
    space: charset " ^-"

    md-buffer: make string! 1000

    main-rules: [
          lf
        | header-rule
        | quote-rule
        | ulist-rule
        | olist-rule
        | code-lang-rule
        | code-block-rule
        | para-rule
        | skip thru lf
    ]

    header-rule: [
          ["#" some space copy text to copy tag [any [some space any "#"] lf] tag (parse text inline-rule emit-h1 text)]
        | ["##" some space copy text to copy tag [any [some space any "#"] lf] tag (parse text inline-rule emit-h2 text)]
        | ["###" some space copy text to copy tag [any [some space any "#"] lf] tag (parse text inline-rule emit-h3 text)]
        | ["####" some space copy text to copy tag [any [some space any "#"] lf] tag (parse text inline-rule emit-h4 text)]
        | ["#####" some space copy text to copy tag [any [some space any "#"] lf] tag (parse text inline-rule emit-h5 text)]
        | ["######" some space copy text to copy tag [any [some space any "#"] lf] tag (parse text inline-rule emit-h6 text)]
    ]

    para-rule: [copy text to 2 lf (parse text inline-rule emit-para text)]

    code-lang-rule: [
          ["```" any space lf copy text to copy tag "```^/" tag (emit-code text)]
        | ["```" copy lang to [any space lf] copy text to copy tag "```^/" tag (emit-code-lang text lang)]
    ]

    code-block-rule: [
        copy indent some space (emit "<pre><code>^/") some [copy text thru lf [
              [lf (emit text emit "</code></pre>^/") break]
            | [indent (emit text)]
            | (emit text)]]
    ]

    quote-rule: [
        copy indent [">" some space] (emit "<blockquote>") some [copy text to lf [
              [lf lf (emit text emit "</blockquote>^/") break]
            | [lf indent (emit text)]
            | lf (emit text)]]
    ]

    ulist-rule: [
        copy indent [["*" | "-" | "+"] some space] (emit "<ul><li>") some [copy text to lf [
              [lf lf (emit text emit "</li></ul>^/") break]
            | [lf indent (emit text emit "</li><li>")]
            | lf (emit text)]]
    ]

    olist-rule: [
        digit "." some space (emit "<ol><li>") some [copy text to lf [
              [lf lf (emit text emit "</li></ol>^/") break]
            | [lf digit "." some space (emit text emit "</li><li>")]
            | lf (emit text)]]
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
          to "![" remove ["![" copy link-text to "](" "](" copy link to ")" ")" (
            title: none 
            if find/tail link space [
                title: copy find/tail link space
                link: copy/part link find link space])
            if (title)][insert {<img src="} insert (link) insert {" alt="} insert (link-text) insert {" title=} insert (title) insert { />}]
        | to "![" remove ["![" copy link-text to "](" "](" copy link to ")" ")" (
            title: none 
            if find/tail link space [
                title: copy find/tail link space
                link: copy/part link find link space])
            if (not title)][insert {<img src="} insert (link) insert {" alt="} insert (link-text) insert {" />}]
        | to "[" remove ["[" copy link-text to "](" "](" copy link to ")" ")" (
            title: none 
            if find/tail link space [
                title: copy find/tail link space
                link: copy/part link find link space])
            if (not title)][insert {<a href="} insert (link) insert {">} insert (link-text) insert {</a>}]
        | to "[" remove ["[" copy link-text to "](" "](" copy link to ")" ")" (
            title: none 
            if find/tail link space [
                title: copy find/tail link space
                link: copy/part link find link space])
            if (title)][insert {<a href="} insert (link) insert {" title=} insert (title) insert {>} insert (link-text) insert {</a>}] 
    ]

    inline-rule: [ahead any code-inline-rule ahead any strong-inline-rule ahead any emphasis-inline-rule any link-inline-rule]


    emit: func [value][
        append md-buffer value
    ]

    emit-para: func [value][
        debug-print "====emit-para"
        append md-buffer "<p>"
        append md-buffer value
        append md-buffer "</p>^/"
    ]

    emit-h1: func [value][
        debug-print "====emit-h1"
        append md-buffer "<h1>"
        append md-buffer value
        append md-buffer "</h1>^/"
    ]

    emit-h2: func [value][
        debug-print "====emit-h2"
        append md-buffer "<h2>"
        append md-buffer value
        append md-buffer "</h2>^/"
    ]

    emit-h3: func [value][
        debug-print "====emit-h3"
        append md-buffer "<h3>"
        append md-buffer value
        append md-buffer "</h3>^/"
    ]

    emit-h4: func [value][
        debug-print "====emit-h4"
        append md-buffer "<h4>"
        append md-buffer value
        append md-buffer "</h4>^/"
    ]

    emit-h5: func [value][
        debug-print "====emit-h5"
        append md-buffer "<h5>"
        append md-buffer value
        append md-buffer "</h5>^/"
    ]

    emit-h6: func [value][
        debug-print "====emit-h6"
        append md-buffer "<h6>"
        append md-buffer value
        append md-buffer "</h6>^/"
    ]

    emit-code: func [value][
        debug-print "====emit-code"
        append md-buffer "<pre><code>^/"
        append md-buffer value
        append md-buffer "</code></pre>^/"
    ]

    emit-code-lang: func [value lang][
        debug-print "====emit-code-lang"
        append md-buffer {<pre><code class="}
        append md-buffer lang
        append md-buffer {">^/}
        append md-buffer value
        append md-buffer "</code></pre>^/"
    ]


    set 'parse-markdown function [str [string!] return: [string!]] [
        parse str [any main-rules]
        md-buffer
    ]    
]