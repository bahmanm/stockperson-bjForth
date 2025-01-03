####################################################################################################
# Opens the data file.
####################################################################################################

: OPEN-DATA-FILE ( -- )
    ." /home/bahman/workspace/stockperson/bjforth/data/chapter-2.0.csv ".
    FILE-OPEN
;

####################################################################################################

OPEN-DATA-FILE
DUP
3 SKIP-HEADER-LINES
ITERATE-LINES
!INVOICE-DB.TOTAL-SALES
INVOICE-DB.TOTAL-SALES-PRINT
BYE
