####################################################################################################

: @<INVOICE-DB>@
  @< HashMap()/0 >@
;

####################################################################################################

@<INVOICE-DB>@          CONSTANT        INVOICE-DB

####################################################################################################
# Gets an existing invoice or creates a new one with a given document no.
####################################################################################################

: INVOICE-DB.GET/NEW  ( docNo -- invoice )
    DUP DUP INVOICE-DB .< containsKey(Object)/1 >.    ( docNo docNo bool )
    ?FALSE IF
        @< HashMap()/0 >@                               ( docNo docNo invoice )
        DUP >R                                          ( docNo docNo invoice )
        INVOICE.DOC-NO                                  ( docNo docNo invoice field )
        SWAP                                            ( docNo docNo field invoice )
        INVOICE.!                                       ( docNo )
        R> DUP                                          ( docNo invoice invoice )
        ROT                                             ( invoice invoice docNo )
        INVOICE-DB                                      ( invoice invoice docNo invoice-db )
        .< put(Object,Object)/2 >. DROP                 ( invoice )
        @< ArrayList()/0 >@                             ( invoice List )
        OVER                                            ( invoice List invoice )
        INVOICE.LINES SWAP                              ( invoice List field invoice )
        INVOICE.!                                       ( invoice )
    ELSE
        DROP
        INVOICE-DB                                      ( docNo invoice-db )
        .< get(Object)/1 >.                             ( invoice )

    THEN
;

####################################################################################################
# Prints the invoices.
####################################################################################################

: INVOICE-DB.PRINT ( -- )
    INVOICE-DB .< keySet()/0 >.           ( docNos )
    @< ArrayList(Collection)/1 >@         ( docNos )
    DUP .< size()/0 >.                    ( docNos n )
    SWAP >R                               ( n )
    0                                     ( n 1 )
    BEGIN
        2DUP <                            ( n i )
    WHILE
        DUP                               ( n i i )
        R> DUP >R                         ( n i i invoices )
        .< get(Integer)/1 >.              ( n i docNo )
        INVOICE-DB.GET/NEW                ( n i invoice )
        INVOICE.PRINT                     ( n i )
        1+
    REPEAT
    2DROP R> DROP                         ( )
;

####################################################################################################

-1      VARIABLE        INVOICE-DB.TOTAL-SALES

####################################################################################################
# Calculates the total sales of the invoices in DB.
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
# Prints the total sales.
####################################################################################################

: INVOICE-DB.TOTAL-SALES-PRINT
    INVOICE-DB.TOTAL-SALES @ ." TOTAL SALES: %20.2f ". .< formatted(Object...)/1 >. PRINTLN
;
