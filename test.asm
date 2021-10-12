; Entry Point, where to place program
CASSETTE_BUFFER = $033C
EMPTY_RAM = $C000
SYS_CHROUT = $FFD2
REG_BORDER_COLOR = $D020
REG_BK_COLOR = $D021
REG_TEXT_COLOR = $0286
BLACK = $00
WHITE = $01
* = CASSETTE_BUFFER
start:
    LDA #BLACK             ;                           2 bytes
    STA REG_BORDER_COLOR   ;                           3 bytes
    STA REG_BK_COLOR       ;                           3 bytes
    lDA #WHITE             ;                           2 bytes
    STA REG_TEXT_COLOR     ;                           3 bytes

add_byte:
    LDX #$02               ;                           2 bytes
    STX EMPTY_RAM          ;                           3 bytes
    CLC                    ;                           1 byte
    LDA #$02               ;                           2 bytes
    ADC EMPTY_RAM          ;                           3 bytes
    STA EMPTY_RAM          ;                           3 bytes

add_two_bytes:
    LDX #%00000000      ; 0000 0000 high byte 1        2 bytes
    STX EMPTY_RAM       ;                              3 bytes
    LDX #%11111111      ; 1111 1111 low byte 1         2 bytes
    STX EMPTY_RAM+1     ;                              3 bytes

    LDX #%00000000     ;                               2 bytes
    STX EMPTY_RAM+2    ; 0000 0000 high byte 2         3 bytes
    LDX #%00000001     ;                               2 bytes
    STX EMPTY_RAM+3    ; 0000 0001 low byte 2          3 bytes

    CLC                ; Add the two words             1 bytes
    LDA EMPTY_RAM+1    ;                               3 bytes
    ADC EMPTY_RAM+3    ;                               3 bytes
    STA EMPTY_RAM+5    ;                               3 bytes
    LDA EMPTY_RAM+0    ;                               2 bytes
    ADC EMPTY_RAM+2    ;                               3 bytes
    STA EMPTY_RAM+4    ;                               3 bytes

sub_byte:               ; Minuend - Subtrahend = Difference
    LDX #%00000101      ; Subtrahend                   2 bytes
    STX EMPTY_RAM       ;                              3 bytes
    LDA #%00001000      ; Minuend                      2 bytes
    SEC                 ;                              1 bytes
    SBC EMPTY_RAM
    STA EMPTY_RAM       ; Difference
                        ;                          0 11111  
sub_two_bytes:          ;                   00001001 00000001              2305
    LDX #%00001001      ;                   00000000 00001000 -               8 -
    STX EMPTY_RAM       ; High byte         -----------------              ----
    LDX #%00000001      ;                   00001000 11111001              2297
    STX EMPTY_RAM+1     ; Low byte

    LDX #%00000000
    STX EMPTY_RAM+2     ; High byte
    LDX #%00001000
    STX EMPTY_RAM+3     ; Low Byte

    SEC
    LDA EMPTY_RAM+1
    SBC EMPTY_RAM+3
    STA EMPTY_RAM+5     ; Difference low byte
    LDA EMPTY_RAM
    SBC EMPTY_RAM+2
    STA EMPTY_RAM+4     ; Difference high byte

multiply:               ; 3 * 7 = 21; $15
    LDA #$07
    ASL
    ADC #$07
    STA EMPTY_RAM

end:
    BRK