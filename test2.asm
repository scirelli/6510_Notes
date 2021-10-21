
EMPTY_RAM = $C000
USER_PROGRAM_SPACE = $0800

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