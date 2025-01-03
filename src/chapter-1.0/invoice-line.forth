." lineNo ".    CONSTANT        INVOICE-LINE.LINE-NO
." product ".   CONSTANT        INVOICE-LINE.PRODUCT
." qty ".       CONSTANT        INVOICE-LINE.QTY
." price ".     CONSTANT        INVOICE-LINE.PRICE
." lineAmt ".   CONSTANT        INVOICE-LINE.LINE-AMT

####################################################################################################
# Creates a new invoice line.
####################################################################################################

: @<INVOICE-LINE>@ ( -- HashMap )
  @< HashMap()/0 >@
;

####################################################################################################

: INVOICE-LINE.@ ( field invoice-line -- )
  .< get(Object)/1 >.
;

####################################################################################################

: INVOICE-LINE.! ( value field invoice-line -- )
  .< put(Object,Object)/2 >.
  DROP
;

####################################################################################################

: INVOICE-LINE.PRINT ( invoice-line -- )
    DUP INVOICE-LINE.LINE-AMT SWAP INVOICE-LINE.@ SWAP
    DUP INVOICE-LINE.PRICE    SWAP INVOICE-LINE.@ SWAP
    DUP INVOICE-LINE.QTY      SWAP INVOICE-LINE.@ SWAP
    DUP INVOICE-LINE.PRODUCT  SWAP INVOICE-LINE.@ SWAP
        INVOICE-LINE.LINE-NO  SWAP INVOICE-LINE.@
    ." | %4s %-29s %-11s %-11.2f %-17.2f | ".               ( invoice-line s lineAmt price qty product lineNo  )
    .< formatted(Object...)/5 >.
    PRINTLN
;
