." docNo ".      CONSTANT        INVOICE.DOC-NO
." customer ".   CONSTANT        INVOICE.CUSTOMER
." date ".       CONSTANT        INVOICE.DATE
." total "  .    CONSTANT        INVOICE.TOTAL
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
    INVOICE.@                           ( line lines)
    .< add(Object)/1 >. DROP            ( )
;
