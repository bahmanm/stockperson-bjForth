####################################################################################################
# Skips a given number of CSV header lines.
####################################################################################################

: SKIP-HEADER-LINES ( reader n -- )
    1                             ( reader n 1 )
    BEGIN
      2DUP                        ( reader n i n i )
      <=                          ( reader n i bool )
    WHILE
      ROT                         ( n i reader  )
      DUP                         ( n i reader reader )
      FILE-READ-LINE DROP         ( n i reader )
      -ROT                        ( reader n i )
      1+                          ( reader n i )
    REPEAT
    2DROP DROP                    ( )
;

####################################################################################################
# Splits a string by ","
####################################################################################################

: LINE-FIELDS ( s -- String[] )
    ." , ".
    SWAP
    .< split(String)/1 >.
;

####################################################################################################
# Converts an array to a List.
####################################################################################################

: ARRAY->LIST ( String[] -- List<String> )
    ,< Arrays/stream(String[])/1 >,
    ,< java.util.stream.Collectors/toList()/0 >,
    SWAP
    .< collect(java.util.stream.Collector)/1 >.
;

####################################################################################################
# Creates a invoice line from a given list of fields.
####################################################################################################

: INVOICE-LINE-FROM-CSV ( List -- invoice-line )
    @<INVOICE-LINE>@ >R                           ( List )

    5 OVER .< get(Integer)/1 >.                   ( List n )
    INVOICE-LINE.LINE-NO                          ( List n s )
    R> DUP >R                                     ( List n s invoice-line )
    INVOICE-LINE.!                                ( List )

    6 OVER .< get(Integer)/1 >.
    INVOICE-LINE.PRODUCT                          ( List n s )
    R> DUP >R                                     ( List n s invoice-line )
    INVOICE-LINE.!                                ( List )

    7 OVER .< get(Integer)/1 >.
    ,< Integer/valueOf(String)/1 >,
    INVOICE-LINE.QTY                              ( List n s )
    R> DUP >R                                     ( List n s invoice-line )
    INVOICE-LINE.!                                ( List )

    8 OVER .< get(Integer)/1 >.
    ,< Double/valueOf(String)/1 >,
    INVOICE-LINE.PRICE                            ( List n s )
    R> DUP >R                                     ( List n s invoice-line )
    INVOICE-LINE.!                                ( List )

    9 OVER .< get(Integer)/1 >.
    ,< Double/valueOf(String)/1 >,
    INVOICE-LINE.LINE-AMT                         ( List n s )
    R> DUP >R                                     ( List n s invoice-line )
    INVOICE-LINE.!                                ( List )
    DROP R>                                      ( invoice-line )
;

####################################################################################################
# Creates an invoicee from a given list of fields.
####################################################################################################

: INVOICE-FROM-CSV      ( List -- invoice)
    0 OVER .< get(Integer)/1 >.                  ( List docNo )
    INVOICE-DB.GET/NEW                           ( List invoice )
    >R

    1 OVER .< get(Integer)/1 >.                  ( List customer )
    INVOICE.CUSTOMER                             ( List customer s )
    R> DUP >R                                    ( List customer s invoice )
    INVOICE.!                                    ( List )

    2 OVER .< get(Integer)/1 >.                  ( List date )
    INVOICE.DATE                                 ( List date s )
    R> DUP >R                                    ( List date s invoice )
    INVOICE.!                                    ( List )

    3 OVER .< get(Integer)/1 >.                  ( List total )
    ,< Double/valueOf(String)/1 >,
    INVOICE.TOTAL                                ( List total s )
    R> DUP >R                                    ( List total s invoice )
    INVOICE.!                                    ( List )

    4 OVER .< get(Integer)/1 >.                  ( List discount )
    ,< Double/valueOf(String)/1 >,
    INVOICE.DISCOUNT                             ( List discount s )
    R> DUP >R                                    ( List discount s invoice )
    INVOICE.!                                    ( List )

    DROP R>                                      ( invoice )
;

####################################################################################################
# Iterates the lines of a CSV file, converting them to invoices (lines).
####################################################################################################

: ITERATE-LINES ( BufferedReader -- )
    >R
    BEGIN
        R> DUP >R                              ( reader )
        FILE-READ-LINE                         ( s )
        DUP ?NULL NOT                          ( s )
    WHILE
        DUP .< isEmpty()/0 >.                  ( s bool )
        ?FALSE IF                              ( s )
             LINE-FIELDS                       ( array )
             ARRAY->LIST                       ( List )
             DUP                               ( List List )
             INVOICE-LINE-FROM-CSV             ( List invoice-line )
             SWAP                              ( invoice-line List )
             INVOICE-FROM-CSV                  ( invoice-line invoice )
             INVOICE.ADD-LINE                  ( )
        ELSE
             DROP                              ( )
        THEN
    REPEAT
    R> 2DROP
;
