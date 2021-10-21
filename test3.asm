EMPTY_RAM = $C000
BASOUT = $FFD2

CHAR_NULL = $00
CHAR_RETURN = 13
CHAR_CLEAR_SCREEN = $93
CHAR_ENABLE_SHIFT = $09
CHAR_LOW_UP_CHARSET = $0E
CHAR_EXCLMATION = $21
CHAR_UP_RIGHT_FILL = $7F
CHAR_CURSOR_RIGHT = $1D

*= EMPTY_RAM

.print_hello_world:
    LDX #$00
-   LDA .string, X
    JSR BASOUT
    INX
    CPX #num_chars
    BNE -
    RTS
    BRK

.string !pet CHAR_LOW_UP_CHARSET, "hello world!", CHAR_RETURN, 0
num_chars = *-.string

    BRK
.print_displayable_characters:
    LDA #CHAR_EXCLMATION
-   JSR BASOUT
    CLC
    ADC #$01
    CMP #CHAR_UP_RIGHT_FILL + 1
    BNE -
    LDA #CHAR_RETURN                   ; Printing $0d seems to prevent the screen clearing.
    JSR BASOUT
;    LDA #CHAR_NULL                    ; Printing $00 seems to prevent the screen clearing.
;    JSR BASOUT
    RTS
    BRK

    LDX #CHAR_EXCLMATION
-   TXA
    JSR BASOUT
    INX
    CPX #CHAR_UP_RIGHT_FILL + 1
    BNE -
    LDA #CHAR_RETURN
    JSR BASOUT
    RTS
    BRK
