####################################################################################################
# Opens the data file.
####################################################################################################

: OPEN-DATA-FILE ( -- )
    ." /home/bahman/workspace/stockperson/bjforth/data/chapter-2.0.csv ".
    FILE-OPEN
;

####################################################################################################

-1      VARIABLE        TOTAL-SALES
-2      VARIABLE        MOST-EXPENSIVE-INVOICE
-3      VARIABLE        MOST-EXPENSIVE-LINE

####################################################################################################
# Calculates the total sales of the invoices in DB.
####################################################################################################

: !TOTAL-SALES ( -- )
    0 TOTAL-SALES !
    INVOICE-DB .< keySet()/0 >.           ( docNos )
    @< ArrayList(Collection)/1 >@         ( docNos )
    DUP .< size()/0 >.                    ( docNos n )
    SWAP >R                               ( n )
    0                                     ( n 0  )
    BEGIN
        2DUP <                            ( n i )
    WHILE
        DUP                               ( n i i )
        R> DUP >R                         ( n i i invoices )
        .< get(Integer)/1 >.              ( n i docNo )
        INVOICE-DB.GET/NEW                ( n i invoice )
        INVOICE.TOTAL SWAP INVOICE.@      ( n i invoice-total )
        TOTAL-SALES @          ( n i invoice-total total )
        + TOTAL-SALES !        ( n i )
        1+                                ( n i )
    REPEAT
    2DROP R> DROP                         ( )
;

####################################################################################################
# Prints the total sales.
####################################################################################################

: TOTAL-SALES-PRINT
    TOTAL-SALES @ ." TOTAL SALES: %20.2f ". .< formatted(Object...)/1 >. PRINTLN
;

####################################################################################################
# Finds the most expensive invoice and sets the variable.
####################################################################################################

: !MOST-EXPENSIVE-INVOICE      ( -- )
    NULL MOST-EXPENSIVE-INVOICE !            ( )
    INVOICE-DB .< keySet()/0 >.                 	( docNos )
    @< ArrayList(Collection)/1 >@               	( docNos )
    DUP .< size()/0 >.                          	( docNos n )
    SWAP >R                               		( n )
    0                                     		( n 0  )
    BEGIN
        2DUP <                            		( n i )
    WHILE
        DUP                               		( n i i )
        R> DUP >R                         		( n i i docNo )
        .< get(Integer)/1 >. DUP             		( n i docNo invoice )
        INVOICE-DB.GET/NEW                		( n i docNo invoice )
        INVOICE.TOTAL SWAP INVOICE.@      		( n i docNo invoice-total )
        MOST-EXPENSIVE-INVOICE @     	( n i docNo invoice-total most-expensive-docNo )
        INVOICE-DB.GET/NEW                      	( n i docNo invoice-total most-expensive-invoice )
        INVOICE.TOTAL SWAP INVOICE.@            	( n i docNo invoice-total most-expensive-total)
        DUP ?NULL IF
            2DROP                               	( n i docNo )
            MOST-EXPENSIVE-INVOICE ! 	( n i )
        ELSE
            < IF
                MOST-EXPENSIVE-INVOICE !     ( n i )
            ELSE
                DROP
            THEN
        THEN
        1+                                              ( n i )
    REPEAT
    2DROP RDROP                                         ( )
;

####################################################################################################
# Creates a dummy value for the variable MOST-EXPENSIVE-LINE.
####################################################################################################

: @<MOST-EXPENSIVE-LINE>@    ( line )
    @< HashMap()/0 >@
    DUP                                 ( line line )
    INVOICE-LINE.PRICE                  ( line line field )
    0 SWAP                              ( line line 0 field )
    ROT                                 ( line 0 field line )
    .< put(Object,Object)/2 >.          ( line )
    DROP
;

####################################################################################################

@<MOST-EXPENSIVE-LINE>@ MOST-EXPENSIVE-LINE !

####################################################################################################

: !MOST-EXPENSIVE-LINE   ( invoice -- )
    DUP ?NULL IF
        DROP
        EXIT
    THEN

    INVOICE.LINES SWAP INVOICE.@                        				( lines )
    DUP .< size()/0 >.                                  				( lines n )
    0                                                   				( lines n 0 )
    BEGIN
        2DUP <                                          				( n i )
    WHILE
        ROT 2DUP                                        				( n i lines i lines )
        .< get(Integer)/1 >.                            				( n i lines line )
        DUP                                             				( n i lines line line )
        INVOICE-LINE.PRICE SWAP INVOICE-LINE.@          				( n i lines line price )
        MOST-EXPENSIVE-LINE @                                                           ( n i lines line price most-expensive-line )
        INVOICE-LINE.PRICE SWAP INVOICE-LINE.@                                       	( n i lines line price most-expensive )
        DUP ?NULL IF
            DROP
        ELSE
            < IF                                            				( n i lines line )
                DUP INVOICE-LINE.PRICE SWAP INVOICE-LINE.@  				( n i lines line price )
                MOST-EXPENSIVE-LINE @ INVOICE-LINE.PRICE SWAP INVOICE-LINE.!       	( n i lines line )
                INVOICE-LINE.PRODUCT SWAP INVOICE-LINE.@                           	( n i lines product )
                MOST-EXPENSIVE-LINE @ INVOICE-LINE.PRODUCT SWAP INVOICE-LINE.!     	( n i lines )
            ELSE
                DROP                                                                    ( n i lines)
            THEN
        THEN
        -ROT                                                                            ( lines n i )
        1+
    REPEAT
    2DROP DROP
;

####################################################################################################

: !MOST-EXPENSIVE-LINE     ( -- )
    INVOICE-DB .< keySet()/0 >.         ( docNos )
    @< ArrayList(Collection)/1 >@       ( docNos )
    DUP .< size()/0 >.                  ( docNos n )
    0                                   ( docNos n 0 )
    BEGIN
        2DUP <                          ( docNos n i )
    WHILE
        ROT                             ( n i docNos )
        2DUP                            ( n i docNos i docNos)
        .< get(Integer)/1 >.            ( n i docNos docNo )
        INVOICE-DB.GET/NEW              ( n i docNos invoice )
        !MOST-EXPENSIVE-LINE            ( n i docNos )
        -ROT                            ( docNos n i )
        1+
    REPEAT
;

####################################################################################################

OPEN-DATA-FILE
DUP
3 SKIP-HEADER-LINES
ITERATE-LINES

!TOTAL-SALES
TOTAL-SALES-PRINT

!MOST-EXPENSIVE-INVOICE
." MOST EXPENSIVE INVOICE: ". PRINTLN
MOST-EXPENSIVE-INVOICE @ .S INVOICE-DB.GET/NEW INVOICE.PRINT

!MOST-EXPENSIVE-LINE
." MOST EXPENSIVE PRODUCT:  ". PRINT
:ANON
    MOST-EXPENSIVE-LINE @ INVOICE-LINE.PRODUCT SWAP INVOICE-LINE.@
; EXECUTE PRINTLN

BYE
