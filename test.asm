; Entry Point, where to place program
CASSETTE_BUFFER = $033C
EMPTY_RAM = $C000
USER_PROGRAM_SPACE = $0800
REG_BORDER_COLOR = $D020
SYS_CHROUT = $FFD2
REG_BK_COLOR = $D021
REG_TEXT_COLOR = $0286

BLACK = $00
WHITE = $01

*= CASSETTE_BUFFER
.temp_w  !word USER_PROGRAM_SPACE
.temp2_w !word USER_PROGRAM_SPACE+2


.start:
    LDA #BLACK             ;                           2 bytes
    STA REG_BORDER_COLOR   ;                           3 bytes
    STA REG_BK_COLOR       ;                           3 bytes
    lDA #WHITE             ;                           2 bytes
    STA REG_TEXT_COLOR     ;                           3 bytes

.add_byte:
    LDX #$02               ;                           2 bytes
    STX EMPTY_RAM          ;                           3 bytes
    CLC                    ;                           1 byte
    LDA #$02               ;                           2 bytes
    ADC EMPTY_RAM          ;                           3 bytes
    STA EMPTY_RAM          ;                           3 bytes

.add_two_bytes:
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

.sub_byte:               ; Minuend - Subtrahend = Difference
    LDX #%00000101      ; Subtrahend                   2 bytes
    STX EMPTY_RAM       ;                              3 bytes
    LDA #%00001000      ; Minuend                      2 bytes
    SEC                 ;                              1 bytes
    SBC EMPTY_RAM
    STA EMPTY_RAM       ; Difference
                        ;                          0 11111
.sub_two_bytes:          ;                   00001001 00000001              2305
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

.multiply:               ; 3 * 7 = 21; $15
    LDA #$07
    ASL
    ADC #$07
    STA EMPTY_RAM

.zeroPageIndexing:            ; The assembler stores the .word in the correct order (low high), so just use it. No need to worry about order here.
.indexedIndirect:
	LDX .temp_w   ; Load the first byte from .temp_w
	STX $14                   ; Store the upper byte of empty ram location into the zero page
	LDX .temp_w+1 ; Load the next byte from .temp_w+1
	STX $15                   ; Store the lower byte into empty
	LDA #$DA
	LDY #$00
	STA ($14), Y
	LDA #$D0
	INY
	STA ($14), Y
.indirectIndexed
	LDX .temp2_w   ; Load the first byte from .temp2_w
	STX $16                   ; Store the upper byte of empty ram location into the zero page
	LDX .temp2_w+1 ; Load the next byte from .temp2_w+1
	STX $17                   ; Store the lower byte into empty
	LDA #$DE
	LDX #$02
	STA ($14,X)
	LDA #$D0
	STA ($14, X)
	JMP USER_PROGRAM_SPACE + 4

.end:
    BRK
    BRK

*= USER_PROGRAM_SPACE + 4

; Test
; Indirect addressing modes do not handle page boundary crossing at all.
; When the parameter's low byte is $FF, the effective address wraps around and the CPU fetches high byte from $xx00 instead of $xx00+$0100.
; E.g.
; JMP ($01FF) fetches PCL from $01FF and PCH from $0100 (instead of $0200)
; and LDA ($FF),Y fetches the base address from $FF and $00.
; Zero page $0000
; Processor port data direction register.
; Bits:
; *  Bit #x:
;    0 = Bit #x in processor port can only be read;
;    1 = Bit #x in processor port can be read and written.
; Default: $2F, %00101111.
;          ^ LDA $0000 just gives $2F
.test_load_cross_page_boundary:
	LDA $00FF		; Back up values in zeropage
	PHA
	LDA #$DA	; Put some marker data on the stack
	PHA
	LDA #$D0
	PHA

	TSX  	 	; Let's grab the stack pointer $01xx
	TXA
	CLC
	ADC #$01  	; Location of value on stack
	STA $FF  	; Store it at the top of zeropage
    LDY #$00
	LDA ($FF), Y	; This would cause memory location $2f<stack pointer value>
					; This is because $00 is a processor port (data direction register) which defaults to $2F
					; AR has garbage data in it.

	PLA		; Unwind the stack
	PLA
	PLA
	STA $FF

	BRK
