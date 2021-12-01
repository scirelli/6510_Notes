; Read number keys and add single digits.
CASSETTE_BUFFER = $033C ;828
SYS_CHROUT      = $FFD2
SYS_STOP        = $FFE1
SYS_GETIN       = $FFE4

CHAR_PLUS       = $2B
CHAR_EQUAL      = $3D
CHAR_STOP       = $03

*= CASSETTE_BUFFER

;########## Jump table ############
JMP main
;##################################

; Data
.tmp !byte $00

; PETSCII  Codes
; 0        %0011 0000  $30
; 1        %0011 0001  $31
; 2        %0011 0010  $32
; 3        %0011 0011  $33
; 4        %0011 0100  $34
; 5        %0011 0101  $35
; 6        %0011 0110  $36
; 7        %0011 0111  $37
; 8        %0011 1000  $38
; 9        %0011 1001  $39
main:
    JSR .readNumber
    CMP #CHAR_STOP
    BEQ .end
    JSR SYS_CHROUT
    AND #$0F         ; Convert the key to binary digit.
    STA .tmp
    LDA #CHAR_PLUS
    JSR SYS_CHROUT

    JSR .readNumber
    CMP #CHAR_STOP
    BEQ .end
    JSR SYS_CHROUT
    AND #$0F         ; Convert the key to binary digit.
    TAX
    LDA #CHAR_EQUAL
    JSR SYS_CHROUT
    TXA
    CLC
    ADC .tmp
    ORA #$30        ; Convert to PETSCII
    JSR SYS_CHROUT

.end:
    RTS


;-------------------------
; .readNumber
;   params:
;
;   return:
;     A: char code of number that was read
;   Affected registers:
;     A, Z, C
;-------------------------
.readNumber:
    JSR SYS_STOP
    BEQ +
    JSR SYS_GETIN
    JSR .isNumber
    BNE .readNumber
+   RTS

;-------------------------
; isNumber()
;   params:
;     A: Value to check
;   return:
;     Z: set Z if numeric
;   Affected registers:
;     Z, C
;-------------------------
.isNumber:
    CMP #$30
    BCC +       ; <
    CMP #$3A    ; One more than $39 (9)
    BCS +       ; >=
    BCC ++
+   LDX #$01
    RTS
++  LDX #$00
    RTS
