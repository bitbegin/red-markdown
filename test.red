Red [
    Title: "markdown parser test"
    Author: "bitbegin"
]

do %markdown.red

str: read %test.md
res: parse-markdown str

write %out.html form res
