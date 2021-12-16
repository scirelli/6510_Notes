; ACME Syntax
!cpu 6510

;##################################
;######### Defines ################
;##################################
OS_LINPRT 			 = $BDCD	; Print ASCII decimal number. It converts the number whose high byte is in .A and whose's low byte is in .X
ADDR_PROCESSOR_PORT  = $0001
ADDR_BASIC_AREA		 = $0800	; 2048
ADDR_BASIC_ROM		 = $A000
ADDR_UPPER_RAM		 = $C000	; 49152
ADDR_CASSETTE_BUFFER = $033C	; 828
ADDR_CARTRIDGE_ROM   = $8000	; 32768

fp				= $02

SYS_CHROUT      = $FFD2
SYS_STOP        = $FFE1
SYS_GETIN       = $FFE4


*= ADDR_UPPER_RAM


; ############################################################
; ################### MACROS #################################
; ############################################################

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
; m_D2V: Convert value in A register (expected PETSCII digit)
;	to it's numeric value.
; params:
;	A: PETSCII char to convert to a number.
; Affects:
;	A
;   SR: N, Z
;------------------------------------------------------------
!macro m_D2V {
	AND #$0F	; Mask off high nible, which is $30 when it's a PETSCII digit.
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
	TSX
	STX .fp
	TXA
	SEC
	SBC #.count
	TAX
	TXS
}


!macro NOT .v {
	EOR #$FF
}


;########## Jump table ############
JMP setup
;##################################


!zone main {
	; variables
	.lineAddr !word input

setup:
main:
.end
}
