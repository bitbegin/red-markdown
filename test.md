# h1

para 1

## h2

para 2

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

### h3

para 3

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


#### h4

para 4

##### h5

para 5

###### h6

para 6
