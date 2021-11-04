; ACME Syntax
!cpu 6510


SPRITE_DEF_SIZE = 64        ; 64 bytes in size
SPRITE_SIZE     = 62        ; bytes 21*24 = 63 = 0 -> 62

!addr {
    CLRSCN       = $E544	; Clear Screen
    FREE_RAM     = $0800    ; Free RAM to place program in
    VIC_MEM_ADDR = $D000	; VIC Base (53248). VIC-II video display memory

    SPRINT2_X    = VIC_MEM_ADDR + 4   ; 1 byte x, 1 byte y = 2 bytes * 2 (sprite number 2) = 4
    SPRINT2_Y    = VIC_MEM_ADDR + 5   ; The next byte is the y coordinate
    X_MSB        = VIC_MEM_ADDR + 16  ; Most significant bit. The byte after the 7th sprint coordinates is the 8th x coordinate bit. Sprite #0-#7 X-coordinates (bit #8). Bits: Bit #x: Sprite #x X-coordinate bit #8.


    SPRITE_ENABLE_REG  = VIC_MEM_ADDR + $0015 ; register Sprite Enable 53269
    SPRITES_POINTER    = $07F8                ; Memory area for sprite pointers. Base 2040
    SPRITE_POINTER_0   = SPRITES_POINTER + 0
    SPRITE_POINTER_1   = SPRITES_POINTER + 1
    SPRITE_POINTER_2   = SPRITES_POINTER + 2
    SPRITE_POINTER_3   = SPRITES_POINTER + 3
    SPRITE_POINTER_4   = SPRITES_POINTER + 4
    SPRITE_POINTER_5   = SPRITES_POINTER + 5
    SPRITE_POINTER_6   = SPRITES_POINTER + 6
    SPRITE_POINTER_7   = SPRITES_POINTER + 7

    MEM_SP2 = $0340                ; begin memory area sprite2
}



*= FREE_RAM

; encode SYS 2064 ($0810) line in BASIC program space
	;dc $00 ,$0c, $08, $0a, $00, $9e, $20, $32
	;dc $30, $36, $34, $00, $00, $00, $00, $00
	!byte $00 ,$0c, $08, $0a, $00, $9e, $20, $32
	!byte $30, $36, $34, $00, $00, $00, $00, $00


init:
    LDA #%00000100	        ; Sprite 2
	STA SPRITE_ENABLE_REG	; Sprite enable register

	LDA #MEM_SP2/SPRITE_DEF_SIZE    ; Store start address of Pointer 2
	STA SPRITE_POINTER_2	        ; to Sprite pointer register

	LDX #SPRITE_SIZE
x0	LDA spr0, X	        ; load sprite byte
	STA MEM_SP2, X      ; store to sprite memory
	DEX		            ; x--
	BNE x0		        ; last byte?
    LDA spr0, X	        ; load sprite byte
	STA MEM_SP2, X      ; store to sprite memory

	DEX		            ; x--
	STX SPRINT2_X	    ; set Sprite position x to zero minus one
	STX SPRINT2_Y	    ; set Sprite position y to zero minus one

	JSR CLRSCN	        ; C64 ROM Clear Screen

y0	INC SPRINT2_X	    ; Sprite position x++
	INC SPRINT2_Y	    ; Sprite position y++


	                ; Delay for sprite move
	LDX #$05	        ; set prescaler outer loop
y11	LDY #$ff	        ; set prescaler inner loop
y1	DEY		            ; y--
	BNE y1		        ; no reached of zero
	DEX		            ; x--
	BNE y11		        ;

	LDA SPRINT2_X	    ; Sprite position x
	CMP #$c8	        ; Sprite position x are 200?
	BNE y0		        ; no, next position

	RTS


;spr0    !byte 0 , 127, 0  , 1  , 255, 192, 3  , 255, 224, 3  , 231, 224
;        !byte 7 , 217, 240, 7  , 223, 240, 2  , 217, 240, 3  , 231, 224
;        !byte 3 , 255, 224, 3  , 255, 224, 2  , 255, 160, 1  , 127, 64
;        !byte 1 , 62 , 64 , 0  , 156, 128, 0  , 156, 128, 0  , 73 , 0
;        !byte 0 , 73 , 0  , 0  , 62 , 0  , 0  , 62 , 0  , 0  , 62 , 0
;        !byte 0 , 28 , 0

spr0 !byte %00000000, %01111111, %00000000
     !byte %00000001, %11111111, %11000000
     !byte %00000011, %11111111, %11100000
     !byte %00000011, %11100111, %11100000
     !byte %00000111, %11011001, %11110000
     !byte %00000111, %11011111, %11110000
     !byte %00000011, %11011001, %11110000
     !byte %00000011, %11100111, %11100000
     !byte %00000011, %11111111, %11100000
     !byte %00000011, %11111111, %11100000
     !byte %00000010, %11111111, %10100000
     !byte %00000001, %01111111, %01000000
     !byte %00000001, %00111110, %01000000
     !byte %00000000, %10011100, %10000000
     !byte %00000000, %10011100, %10000000
     !byte %00000000, %01001001, %00000000
     !byte %00000000, %01001001, %00000000
     !byte %00000000, %00111110, %00000000
     !byte %00000000, %00111110, %00000000
     !byte %00000000, %00111110, %00000000
     !byte %00000000, %00011100, %00000000
