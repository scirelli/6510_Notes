;------------------------------------------------------------
; m_DINC: Increase 16-bit counters
; params:
;	.target: Address of value to increment
; Affects:
;   SR: N, Z
;------------------------------------------------------------
!macro m_DINC .target {
	INC .target
	BNE +				; "bne * + 5" would not work in zp
	INC .target + 1
+
}


;------------------------------------------------------------
; m_allocateStack: Allocate space on the stack.
; params:
;	.fp: Address where to store the frame pointer.
;	.count: Amount of bytes to allocate.
; Affects:
;   SR: N, Z, V, C
; Notes: References to local variables will be negative
;	offsets to the frame pointer.
;------------------------------------------------------------
!macro m_allocateStack .fp, .count {
	LDX $#01
	STX .fp + 1
	TSX
	STX .fp
	TXA
	SEC
	SBC #.count
	TAX
	TXS
}



;------------------------------------------------------------
; m_NOT: Bitwise NOT operator polyfill.
;------------------------------------------------------------
!macro m_NOT .v {
	EOR #$FF
}

;------------------------------------------------------------
; RAM Patching: Turning on and off RAM sections
;------------------------------------------------------------
!macro m_patchOutBasic {
	DEC $01
}
!macro m_patchInBasic {
	INC $01
}

!macro m_patchOutKernal {
	DEC $01
	DEC $01
}
!macro m_patchInKernal {
	INC $01
	INC $01
}

!macro m_patchOutIO {
	DEC $01
	DEC $01
	DEC $01
}
!macro m_patchInIO {
	INC $01
	INC $01
	INC $01
}

; Set Overflow
!macro SEV {
    PHA             ;3
    SEC             ;2
    ADC #$FF        ;2
    PLA             ;4
}

;------------------------------------------------------------
; m_PZP: Writes an address stored in A (low byte) and X
;   (high byte) to a zero page location. Backs up zp value
;   to the stack.
;   In memory address would look liek this [A, X]
;   params:
;       A: low byte
;       X: high byte
;       .zp: zero page address
;   Affects:
;       Y: destroys Y, used as swap
;       Uses two bytes on stack. Make sure to call m_PLZ to
;       restore the zero page from the stack.
;------------------------------------------------------------
!macro m_PZP .zp {
    TAY							;Back up zero-page to stack, and store line address to zero-page
    LDA .zp
    PHA
    STY .zp
    LDA .zp + 1
    PHA
    STX .zp + 1
}

;------------------------------------------------------------
; m_PLZ: Writes an address stored on the stack by m_PZP
;   back to a zero page location.
;   Assumes the stack is setup so top value is the zero page
;   value that was pushed on with m_PZP
;   params:
;       .zp: zero page address to restore to
;   Affects:
;       Y: destroys Y, used as swap
;       Z, N
;------------------------------------------------------------
!macro m_PLZ .zp {
    TAY
    PLA
    STA .zp + 1
    PLA
    STA .zp
    TYA
}
