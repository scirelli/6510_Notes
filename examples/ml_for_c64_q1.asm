; Here's another question. Suppose I asked you to write aprogram to move
; the contents of five locations, $0380 to $0384, in an "end-around"
; fashion, so that the contents of $0380 moved to $0381, $0381 to
; $0382, and so on, with the contents of $0384 moved to $0380. At
; first glance, we seem to have a problem: we don't have five data registers,
; we have only three (A, X, and Y). Can you think of away of doing the job?
EMPTY_RAM = $C000

*= EMPTY_RAM
START = $0380
END = $0384
BYTE_COUNT = END - START


main:
    JSR .setup
    JSR .ror_bytes
    RTS


.setup:                     ; Write some byte markers to mem
    LDA #$D1
    STA START+0
    LDA #$D2
    STA START+1

    LDA #$D3
    STA START+2
    LDA #$D4
    STA START+3

    LDA #$D5
    STA START+4
    RTS

.ror_bytes:
    LDX #BYTE_COUNT
    LDY END             ; tmp store the last byte
-   DEX
    LDA START, X
    INX
    STA START, X
    DEX
    BNE -
    STY START
    RTS
