; Read number keys and print them to the screen.
CASSETTE_BUFFER = $033C ;828
SYS_CHROUT      = $FFD2
SYS_STOP        = $FFE1
SYS_GETIN       = $FFE4

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
;
; A        %0100 0001  $41
; B        %0100 0010  $42
; ...
; Z        %0101 1010  $5A
.start:
.read:
    JSR SYS_STOP
    BEQ .end
    JSR SYS_GETIN
                ; Numbers
    CMP #$30
    BCC .read   ; <
    CMP #$3A    ; One more than $39 (9)
    BCS .read   ; >=
    AND #$FE
    JSR SYS_CHROUT
    AND #$0F    ; Convert the key to binary digit.
    JMP .read

.end:
    RTS
