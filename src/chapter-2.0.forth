####################################################################################################
# Opens the data file.
####################################################################################################

: OPEN-DATA-FILE ( -- )
    ." /home/bahman/workspace/stockperson/bjforth/data/chapter-2.0.csv ".
    FILE-OPEN
;

####################################################################################################

-1 VARIABLE INVOICE-DB.TOTAL-SALES

####################################################################################################

: !INVOICE-DB.TOTAL-SALES ( -- total-sales )
    0 INVOICE-DB.TOTAL-SALES !
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
        INVOICE-DB.TOTAL-SALES @          ( n i invoice-total total )
        + INVOICE-DB.TOTAL-SALES !        ( n i )
        1+                                ( n i )
    REPEAT
    2DROP R> DROP                         ( )
;

####################################################################################################

: INVOICE-DB.TOTAL-SALES-PRINT
    INVOICE-DB.TOTAL-SALES @ ." TOTAL SALES: %20.2f ". .< formatted(Object...)/1 >. PRINTLN
;

####################################################################################################

OPEN-DATA-FILE
DUP
3 SKIP-HEADER-LINES
ITERATE-LINES
!INVOICE-DB.TOTAL-SALES
INVOICE-DB.TOTAL-SALES-PRINT
BYE
