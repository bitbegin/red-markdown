# h1 `code` *emphasis*

## `h2 code` _emphasis_ **strong** __strong text__

inline test:   

__strong text__ **strong** 

**strong** __strong text__

*emphasis* _emphasis_ 

_emphasis_ *emphasis*

**strong** *emphasis* 

**strong** _emphasis_ `code` **strong** __strong text__ `code` `code`


link test:

This is an [my blog](http://www.bitbegin.com/).

This is an [my blog](http://www.bitbegin.com/ "bitbegin blog").

This is an image link ![alt text](http://c.hiphotos.baidu.com/baike/c0%3Dbaike92%2C5%2C5%2C92%2C30/sign=7c1a698b097b020818c437b303b099b6/d4628535e5dde71182f302d8a4efce1b9d1661fe.jpg "Title")

# h1

para 1 `code` *emphasis* __strong text__ **strong** 

## h2

para 2

paragraph test line.
This is a "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum" test.

### h3

para 3

1. list 1
2. list 2
3. list 3

3. list 1
2. list 2
1. list 3


* un order list 1
* un order list 2
* un order list 3

* un order list 1
* un order list 2
* un order list 3

#### h4

para 4

quote test:

> blockquote tests 1.
> blockquote tests 2.

test 2:

> blockquote tests. This is a "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum" test.

##### h5

para 5

```red
Red [title: "test" needs: 'view]
win: layout [area 400x400]
win/menu: [
    "subwin" subwin
]
win/actors: make object! [
    on-menu: func [face [object!] event [event!]][
        if event/picked = 'subwin [
            view subwin
        ]
    ]
]

subwin: layout [area 100x100]

view win
```

###### h6

para 6

    Red [title: "test" needs: 'view]
    win: layout [area 400x400]
    win/menu: [
        "subwin" subwin
    ]
    win/actors: make object! [
        on-menu: func [face [object!] event [event!]][
            if event/picked = 'subwin [
                view subwin
            ]
        ]
    ]

    subwin: layout [area 100x100]

    view win

