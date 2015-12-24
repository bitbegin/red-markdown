Red []

debug?: on
debug: func [data] [if debug? [print data]]


rules: [some commands]
commands: [
	;here: (debug ["---PARSE:" copy/part here find here lf])

    "######" text-line (debug ["###### H6" text])
    | "#####" text-line (debug ["##### H5" text])
    | "####" text-line (debug ["#### H4" text])
    | "###" text-line (debug ["### H3" text])
    | "##" text-line (debug ["## H2" text])
    | "#" text-line (debug ["# H1" text])
    | code (debug ["---lang:" lang lf "---codes:" lf codes lf])
    | tab-block (debug ["---blocks:" lf "   " tab-blocks lf])
    | paragraph (debug ["---PARA:" para])
    | lf (debug ["---newline"])
	| skip (debug "???WARN:  Unrecognized")
]

space: charset " ^-"
nochar: charset " ^-^/"
chars: complement nochar
spaces: [any space]
some-chars: [some space copy text some chars]
text-line:  [some space copy text thru lf]
tab-block: [some space copy tab-blocks to [lf chars]]
paragraph: [copy para some [chars thru lf]]
code: ["```" copy lang thru lf copy codes to "```^/" "```^/"]

str: read %test.md
parse str rules
