CASSETTE_BUFFER = $033C
SYS_CHROUT = $FFD2

*= CASSETTE_BUFFER

.start:
    LDX #53               ; Print 543210
-   TXA
    JSR SYS_CHROUT
    DEX
    CPX #53 - 5
    BCS -
    RTS
