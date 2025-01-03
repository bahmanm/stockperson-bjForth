." docNo ".      CONSTANT        INVOICE.DOC-NO
." customer ".   CONSTANT        INVOICE.CUSTOMER
." date ".       CONSTANT        INVOICE.DATE
." total ".      CONSTANT        INVOICE.TOTAL
." discount ".   CONSTANT        INVOICE.DISCOUNT
." lines ".      CONSTANT        INVOICE.LINES

####################################################################################################
# Creates a new invoice.
####################################################################################################

: @<INVOICE>@ ( -- HashMap )
    @< HashMap()/0 >@
;

####################################################################################################

: INVOICE.@ ( field invoice -- )
    .< get(Object)/1 >.
;

####################################################################################################

: INVOICE.! ( value field invoice -- )
    .< put(Object,Object)/2 >.
    DROP
;

####################################################################################################

: INVOICE.ADD-LINE ( line invioce -- )
    INVOICE.LINES SWAP                  ( line field invoice )
    INVOICE.@                           ( line lines )
    .< add(Object)/1 >. DROP            ( )
;

####################################################################################################


: INVOICE.PRINT ( invoice -- )
    ." +------------------------------------------------------------------------------+ ". PRINTLN

    ." | INVOICE#: %-40s ".                   ( invoice s )
    OVER                                      ( invoice s invoice )
    INVOICE.DOC-NO SWAP INVOICE.@             ( invoice s docNo )
    SWAP                                      ( invoice docNo s )
    .< formatted(Object...)/1 >.              ( invoice )
    PRINT

    ." DATE: %-20s | ".                       ( invoice s )
    OVER                                      ( invoice s invoice )
    INVOICE.DATE SWAP INVOICE.@               ( invoice s date )
    SWAP                                      ( invoice date s )
    .< formatted(Object...)/1 >.              ( invoice )
    PRINTLN

    ." | CUSTOMER: %-40s ".                   ( invoice s )
    OVER                                      ( invoice s invoice )
    INVOICE.CUSTOMER SWAP INVOICE.@           ( invoice s customer )
    SWAP                                      ( invoice customer s )
    .< formatted(Object...)/1 >.              ( invoice )
    PRINT

    ." DISCOUNT: %-16s | ".                   ( invoice s )
    OVER                                      ( invoice s invoice )
    INVOICE.DISCOUNT SWAP INVOICE.@           ( invoice s discount )
    SWAP                                      ( invoice discount s )
    .< formatted(Object...)/1 >.              ( invoice )
    PRINTLN
    ." +------------------------------------------------------------------------------+ ". PRINTLN
    ." | #   | PRODUCT                     | QTY      | PRICE      | AMOUNT           | ". PRINTLN
    ." +------------------------------------------------------------------------------+ ". PRINTLN

    DUP >R

    INVOICE.LINES SWAP INVOICE.@              ( lines )
    DUP .< size()/0 >.                        ( lines n )
    SWAP >R                                   ( n )
    0                                         ( n 0 )
    BEGIN
       2DUP                                   ( n i n i )
       <                                      ( n i )
    WHILE
       DUP                                    ( n i i )
       R> DUP >R                              ( n i i lines )
       .< get(Integer)/1 >.                   ( n i line )
       INVOICE-LINE.PRINT                     ( n i )
       1+
    REPEAT
    2DROP R> DROP

    ." +------------------------------------------------------------------------------+ ". PRINTLN

    R>
    ." |                                                    TOTAL: %18s | ".    ( invoice s )
    SWAP                                      ( s invoice )
    INVOICE.TOTAL SWAP INVOICE.@              ( s total )
    SWAP                                      ( total s )
    .< formatted(Object...)/1 >.              ( s )
    PRINTLN
   ." +------------------------------------------------------------------------------+ ". PRINTLN
   ." ". PRINTLN
;
