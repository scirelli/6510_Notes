;------------------------------------------------------------------
; Note: This program does not use raster interrupts
;------------------------------------------------------------------

EMPTY_RAM                    = $C000
CIA_INTERRUPT_CONTROL_REG    = $DC0D
CIA_INTERRUPT_VECTOR         = $0314      ; 1/60 sec
RASTER_INTERRUPT_CONTROL_REG = $D01A
SCREEN_CONTROL_REG           = $D011
RASTER_LINE_INTERRUPT_REG    = $D012
INTERRUPT_STATUS_REGISTER    = $D019
KERNAL_INTERRUPT_HANDLER     = $EA31
ADDR_CUR_BORDER_COLOR        = $D020

CHAR_CLR_SCREEN = $93
CHAR_HOME = $13

LINPRT = $BDCD ; Output a number in ASCII Decimal Digits. This routine is used to output the line number for the routine above. It converts the number whose high byte is in .A and whose's low byte is in .X to a floating point number. It also calls the routine below which converts the floating point number to an ascii string
CHROUT = $FFD2

RASTER_LINE = 51

*= EMPTY_RAM

.main:
        LDA CHAR_CLR_SCREEN
        JSR CHROUT

.loop:
        LDA #RASTER_LINE                    ; Raster line 100
-       CMP RASTER_LINE_INTERRUPT_REG       ; Compare raster line number to 100
        BNE -                               ; Busy loop

        INC ADDR_CUR_BORDER_COLOR           ; Change the border color so you can see how long (in the boarder) The frame tames

                                            ; Do operations here
        CLC
        LDA score
        ADC #$01
        STA score
        LDA score+1
        ADC #$00
        STA score+1

        LDA #CHAR_HOME                      ; Move cursor to beginning of the line
        JSR CHROUT

        ;print score
        LDX score
        LDA score + 1
        JSR LINPRT

        DEC ADDR_CUR_BORDER_COLOR           ; Change the border color back, ending the visual cue of frame time.
        JMP .loop

score !byte 0, 0
