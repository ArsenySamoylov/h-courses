bb0
    XOR x2 x2 x2
    B bb1
bb1
    MUL x3 x2 5
    XOR x8 x8 x8
    B bb15
bb8
    FLUSH
    XOR x2 x2 x2
    B bb1
bb10
    ADD x2 x2 1
    CMP x11 x2 51
    BR_COND x11 bb8 bb1
bb15
    RAND_COLOR x9
    MUL x10 x8 5
    PUT_CELL x10 x3 x9
    
    ADD x10 x10 1
    PUT_CELL x10 x3 x9
    
    ADD x10 x10 1
    PUT_CELL x10 x3 x9
    
    ADD x10 x10 1
    PUT_CELL x10 x3 x9

    ADD x10 x10 1
    PUT_CELL x10 x3 x9

    ADD x8 x8 1
    CMP x11 x8 102
    BR_COND x11 bb10 bb15