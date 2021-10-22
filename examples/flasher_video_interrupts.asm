; flasher - part II
;
; this program causes the border to flash 60 times per second
; the source of the interrupts is the video chip
;
EMPTY_RAM                    = $C000
CIA_INTERRUPT_CONTROL_REG    = $DC0D
CIA_INTERRUPT_VECTOR         = $0314      ; 1/60 sec
RASTER_INTERRUPT_CONTROL_REG = $D01A
SCREEN_CONTROL_REG           = $D011
RASTER_LINE_INTERRUPT_REG    = $D012
INTERRUPT_STATUS_REGISTER    = $D019
KERNAL_INTERRUPT_HANDLER     = $EA31
ADDR_CUR_BORDER_COLOR        = $D020

*= EMPTY_RAM

.setup:
    SEI                                  ; disable interrupts
    LDA #$7f                             ; turn off the cia interrupts. disables any interrupts caused by the CIA chip.
    STA CIA_INTERRUPT_CONTROL_REG
    LDA RASTER_INTERRUPT_CONTROL_REG     ; enable raster irq
    ORA #$01                             ; Location $d01a controls which sources may cause an interrupt (other than the normal CIA). There are 4 different possible sources: rasters, sprite to sprite collision, sprite to background collision, and the light pen. Bit #0 is the raster bit, and this piece of code activates it.
    STA RASTER_INTERRUPT_CONTROL_REG
    LDA SCREEN_CONTROL_REG              ; clear high bit of raster line
    AND #$7f                            ; This code clears bit #7 of location $d011. This location is used for many different things. Bit #7 represents the highest bit of the raster line (see segment below for more on the raster line #). More than 256 raster line numbers are possible (some are off screen, and some represent the upper and lower border areas).  This bit is the 9th bit. I set it to zero because all my code affects rasters only on the normal 25*40 line display, well within the 0-255 range. This decision was an arbitrary choice on my part, to make the code simpler.
    STA SCREEN_CONTROL_REG

    LDA #100                      ; line number to go off at
    STA RASTER_LINE_INTERRUPT_REG ; low byte of raster line. Location $d012 is the lower 8 bits of the raster line on which the interrupt is to be generated. The number 100 was another arbitrary choice. For changing border colours, the actual line number was not important. Later on, in the next example, it will become important.

    LDA #<.intcode                 ; get low byte of target routine
    STA CIA_INTERRUPT_VECTOR      ; put into interrupt vector
    LDA #>.intcode                 ; do the same with the high byte
    STA CIA_INTERRUPT_VECTOR+1
    CLI                           ; re-enable interrupts
    RTS                           ; return to caller

.intcode:
    INC ADDR_CUR_BORDER_COLOR     ; change border colour
    LDA INTERRUPT_STATUS_REGISTER ; clear source of interrupts
    STA INTERRUPT_STATUS_REGISTER ; These lines clear the bit in the interrupt register which tells the source of the interrupt
    LDA #100                      ; reset line number to go off at
    STA RASTER_LINE_INTERRUPT_REG
    JMP KERNAL_INTERRUPT_HANDLER  ; exit back to rom
