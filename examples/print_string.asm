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

.jump_table:
    JMP .test_Println               ; 3 bytes each
    JMP .test_print_string
    JMP .test_Println_long_string
    JMP .test_Printlnl_long_string

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

.test_Println:
    LDA $02             ; Back up call params
    PHA
    LDA $03
    PHA
    LDA #>.string       ; Push the address of the string on the stack
    STA $03
    LDA #<.string       ; get high byte
    STA $02
    JSR .Println

    PLA                 ; Restore params
    STA $02
    PLA
    STA $03
    RTS

.test_Println_long_string:
    LDA $02             ; Back up call params
    PHA
    LDA $03
    PHA
    LDA #>.string2
    STA $03
    LDA #<.string2
    STA $02
    JSR .Println

    PLA                 ; Restore params
    STA $02
    PLA
    STA $03
    RTS

.test_Printlnl_long_string:
    LDA $02             ; Back up call params
    PHA
    LDA $03
    PHA
    LDA #>.string2
    STA $03
    LDA #<.string2
    STA $02
    JSR .Printlnl

    PLA                 ; Restore params
    STA $02
    PLA
    STA $03
    RTS

;############################################
.print_string:
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

;#############################################
; Println - Print a string to the screen.
; This is an attempt to standardize function calls.
; This function uses the convention $02 stores the address to params, $04 stores the address to the return value.
; Param 1: Address to first character of the string to print. Strings should end in $00 value.
; Return: nothing
.Println:
    LDY #$00
-   LDA ($02), Y
    BEQ +
    JSR BASOUT
    INY
    JMP -
+   RTS

;#############################################
; Printlnl - Print a string to the screen, allows for strings longer than 255 characters.
; This is an attempt to standardize function calls.
; This function uses the convention $02 stores the address to params, $04 stores the address to the return value.
; Param 1: Address to first character of the string to print. Strings should end in $00 value.
; Return: nothing
.Printlnl:
    LDA $02
    PHA
    LDA $03
    PHA

    LDY #$00
-   LDA ($02), Y
    BEQ .end_printlnl
    JSR BASOUT
    INY
    BEQ +               ; Y > $FF; Y rolls over setting the zero flag
    JMP -

+   CLC
    LDA $02
    ADC #$FF
    STA $02
    LDA $03
    ADC #$00
    STA $03
    JMP -

.end_printlnl
    PLA
    STA $03
    PLA
    STA $02
    RTS

;================ Data =======================
.string !pet "hello world! you poopy faced poopsicle", CHAR_RETURN, 0
num_chars = *-.string

.string2 !pet CHAR_RETURN, "lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", CHAR_RETURN, 0
num_chars2 = *-.string2
