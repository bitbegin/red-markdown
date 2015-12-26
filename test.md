# h1 more

## h2 more


# h1

para 1

## h2

para 2

paragraph test line.
This is a "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum" test.

### h3

para 3


#### h4

para 4

>blockquote tests. 

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

