EMPTY_RAM                    = $C000
CIA_INTERRUPT_CONTROL_REG    = $DC0D
CIA_INTERRUPT_VECTOR         = $0314      ; 1/60 sec
RASTER_INTERRUPT_CONTROL_REG = $D01A
SCREEN_CONTROL_REG           = $D011
RASTER_LINE_INTERRUPT_REG    = $D012
INTERRUPT_STATUS_REGISTER    = $D019
KERNAL_INTERRUPT_HANDLER     = $EA31
ADDR_CUR_BORDER_COLOR        = $D020


COLOUR1 = 0
COLOUR2 = 1
LINE1 = 20
LINE2 = 150

*= EMPTY_RAM

.setup:
    SEI                                        ; disable interrupts

    LDA #$7f                                   ; turn off the cia interrupts
    STA CIA_INTERRUPT_CONTROL_REG

    LDA RASTER_INTERRUPT_CONTROL_REG           ; enable raster irq
    ORA #$01
    STA RASTER_INTERRUPT_CONTROL_REG

    LDA SCREEN_CONTROL_REG                     ; clear high bit of raster line
    AND #$7f
    STA SCREEN_CONTROL_REG

    LDA #LINE1                                 ; line number to go off at
    STA RASTER_LINE_INTERRUPT_REG              ; low byte of raster line

    LDA #<.intcode                             ; get low byte of target routine
    STA CIA_INTERRUPT_VECTOR                   ; put into interrupt vector
    LDA #>.intcode                             ; do the same with the high byte
    STA CIA_INTERRUPT_VECTOR+1

    CLI                                        ; re-enable interrupts
    RTS                                        ; return to caller

.intcode:
    LDA .modeflag                              ; determine whether to do top or
                                               ; bottom of screen
    BEQ .mode1
    JMP .mode2

.mode1:
    LDA #$01                                   ; invert modeflag
    STA .modeflag

    LDA #COLOUR1                               ; set our colour
    STA ADDR_CUR_BORDER_COLOR

    LDA #LINE1                                 ; setup line for NEXT interrupt
    STA RASTER_LINE_INTERRUPT_REG              ; (which will activate MODE2)

    LDA INTERRUPT_STATUS_REGISTER
    STA INTERRUPT_STATUS_REGISTER

    JMP KERNAL_INTERRUPT_HANDLER               ; MODE1 exits to Rom

.mode2:
    LDA #$00                                   ; invert modeflag
    STA .modeflag

    LDA #COLOUR2                               ; set our colour
    STA ADDR_CUR_BORDER_COLOR

    LDA #LINE2                                 ; setup line for NEXT interrupt
    STA RASTER_LINE_INTERRUPT_REG              ; (which will activate MODE1)

    LDA INTERRUPT_STATUS_REGISTER
    STA INTERRUPT_STATUS_REGISTER

    PLA                                        ; we exit interrupt entirely.
    TAY                                        ; since happening 120 times per
    PLA                                        ; second, only 60 need to go to
    TAX                                        ; hardware Rom. The other 60 simply
    PLA                                        ; end
    RTI

.modeflag !byte 0
