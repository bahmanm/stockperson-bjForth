####################################################################################################

: @<INVOICE-DB>@
  @< HashMap()/0 >@
;

####################################################################################################

@<INVOICE-DB>@          CONSTANT        INVOICE-DB

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
      -ROT                                            ( invoice invoice docNo )
      INVOICE-DB                                      ( invoice invoice docNo invoice-db )
      .< put(Object,Object)/2 >. DROP                 ( invoice )
      @< ArrayList()/0 >@                             ( invoice List )
      OVER                                            ( invoice List invoice )
      INVOICE.LINES SWAP                              ( invoice List field invoice )
      INVOICE.!                                       ( invoice )
    ELSE
      INVOICE-DB                                      ( docNo invoice-db )
      .< get(Object)/1 >.                             ( invoice )
    THEN
;
