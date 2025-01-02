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
    DUP INVOICE.DOC-NO    SWAP INVOICE.@ PRINT ." ,  ". PRINT
    DUP INVOICE.CUSTOMER  SWAP INVOICE.@ PRINT ." ,  ". PRINT
    DUP INVOICE.DATE      SWAP INVOICE.@ PRINT ." ,  ". PRINT
    DUP INVOICE.TOTAL     SWAP INVOICE.@ PRINT ." ,  ". PRINT
    DUP INVOICE.DISCOUNT  SWAP INVOICE.@ PRINT ." ,  ". PRINT   ( invoice )

    INVOICE.LINES SWAP INVOICE.@              ( lines )
    DUP .< size()/0 >.                        ( lines n )
    SWAP >R
    1                                         ( n 1 )
    BEGIN
       2DUP >                                 ( n i )
    WHILE
       R> DUP >R                              ( n i line )
       INVOICE-LINE.PRINT
    REPEAT
    2DROP R> DROP
;
