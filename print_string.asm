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

.test_print_string:
    LDA #>.string       ; Push the address of the string on the stack
    PHA
    TSX                 ; stack is empty (points to next empty spot) so back up this location where the address will be
    LDA #<.string       ; get high byte
    PHA
    TXA                 ; subroute expects the first byte of the address to pull the address of the value
    JSR .print_string
    PLA
    PLA
    RTS
    BRK

.print_string
    TAX             ; back up A to X, A is the address of the address of the string on the stack
    LDA $02         ; Back up what's at $02-$05
    PHA             ;
    LDA $03         ;
    PHA             ;
    LDA $04         ;
    PHA             ;
    LDA $05         ;
    PHA             ;
    STX $02         ; Store the stack pointer to the .string into zeropage vector table
    LDX #$01        ; It's a stack address so it high byte is $01
    STX $03
    LDY #$00
    LDA ($02), Y
    STA $04
    INY
    LDA ($02), Y
    STA $05
    LDY #$00
-   LDA ($04), Y
    JSR BASOUT
    INY
    CMP #$00
    BNE -
    PLA         ; Restore $02-$03
    STA $05
    PLA
    STA $04
    PLA
    STA $03
    PLA
    STA $02
    RTS

.string !pet "hello world! you poopy faced poopsicle", CHAR_RETURN, 0
num_chars = *-.string
