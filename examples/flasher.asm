; flasher
;
; this program causes the border to flash 60 times per second
;
EMPTY_RAM = $C000
CIA_INTERRUPT_VECTOR = $0314      ; 1/60 sec
KERNAL_INTERRUPT_HANDLER = $EA31
ADDR_CUR_BORDER_COLOR = $D020

*= EMPTY_RAM

.setup:
SEI                           ; disable interrupts, so that an interrupt doesn't happen while we're doing some work
LDA #<.intcode                ; get low byte of target routine
STA CIA_INTERRUPT_VECTOR      ; put into interrupt vector
LDA #>.intcode                ; do the same with the high byte
STA CIA_INTERRUPT_VECTOR+1
CLI                           ; re-enable interrupts
RTS                           ; return to caller

.intcode:
INC ADDR_CUR_BORDER_COLOR     ; change border colour
JMP KERNAL_INTERRUPT_HANDLER  ; exit back to rom
