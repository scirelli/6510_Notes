; Print PETSCII 0-9
CASSETTE_BUFFER = $033C
SYS_CHROUT = $FFD2

*= CASSETTE_BUFFER

DIGIT_MASK = %00110000
DIGIT_MASK1 = %11001111
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
    LDX #0
-   TXA
    ORA #DIGIT_MASK
    JSR SYS_CHROUT
    INX
    CPX #10
    BMI -
    RTS
