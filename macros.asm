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
