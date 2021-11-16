; Read number keys and print them to the screen.
CASSETTE_BUFFER = $033C
SYS_CHROUT = $FFD2
SYS_STOP = $FFE1
SYS_GETIN = $FFE4

*= CASSETTE_BUFFER

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
.start:
-   JSR SYS_STOP
    BEQ .end
    JSR SYS_GETIN
    CMP #$30
    BCC -
    CMP #$3A    ; One more than $39 (9)
    BCS -
    JSR SYS_CHROUT
    AND #$0F    ; Convert the key to binary digit.
    JMP -

.end:
    RTS
