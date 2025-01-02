." lineNo ".    CONSTANT        INVOICE-LINE.LINE-NO
." product ".   CONSTANT        INVOICE-LINE.PRODUCT
." qty ".       CONSTANT        INVOICE-LINE.QTY
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
    DUP INVOICE-LINE.LINE-NO  SWAP INVOICE-LINE.@ PRINT ."  |  ". PRINT
    DUP INVOICE-LINE.PRODUCT  SWAP INVOICE-LINE.@ PRINT ."  |  ". PRINT
    DUP INVOICE-LINE.QTY      SWAP INVOICE-LINE.@ PRINT ."  |  ". PRINT
        INVOICE-LINE.LINE-AMT SWAP INVOICE-LINE.@ PRINTLN
;
