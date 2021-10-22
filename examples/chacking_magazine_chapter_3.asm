; In this edition we take a look at reading and writing commands to the disk
; drive, including reading the disk directory and error channel. This article
; parallels the discussion of the C=128 and C=64 KERNAL jump tables of available
; routines. Written by Craig Taylor.
EMPTY_RAM = $C000
setnam = $FFBD
setlfs = $FFBA
open   = $FFC0
close  = $FFC3
chkin  = $FFC6
chrin  = $FFCF
bsout  = $FFD2
clrch  = $FFCC
print_BCD = $BDCD

temp   = 253     ; Temp is set up to just be a temporary location in zero-page. Location 253 is unused.
charret = $0d    ; Charret stands for the carriage return character and is the equivlent of a chr$(13).
space = $20      ; Space stands for the code for a space (a chr$(32))

*= EMPTY_RAM

start:
    JSR read_dir     ; Initial jump table -- Note: Will read error after
    JMP read_err     ;     showing directory.

read_dir:
; Opens and reads directory as a basic program.
;==
; Basic programs are read in as follows:
;                  [Ptr to Next Line]:2 [Line #]:2 [Text]:.... [$00 byte]
;                  ^^^^^^^^^^^REPEATS^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
; The end of a program is signifed by the $00 byte signifying end of text
;    and the ptr's also being = $00.
;==
                              ; Begin by opening up the directory file ("$").
        LDA #$01              ;   length is 1
        LDX #<.dir            ;   lo byte pointer to file name.
        LDY #>.dir            ;   hi byte pointer to file name.
        JSR setnam            ; - call setnam
        LDA #$01              ;   file # 1
        LDX #$08              ;   device # 8
        LDY #$00              ;   channel # 0
        JSR setlfs            ; - call setlfs
        JSR open              ; - call open
        LDX #$01              ;   file #1
        JSR chkin             ; - call chkin to set input file
        JSR chrin             ; - ignore starting address (2 bytes)
        JSR chrin
        JSR chrin
.bck1:  JSR chrin
.line:  JSR chrin             ; - get line # lo.
        STA temp              ; - store lo of line # @ temp
        JSR chrin             ; - get hi of line #

        LDX temp
        JSR $bdcd
        LDA #space
        JSR bsout             ; - print space

.gtasc: JSR chrin             ; - start printing filename until end of line.
        BEQ .chck             ;   (Zero signifies eol).
        JSR bsout             ; - Print character
        SEC
        BCS .gtasc            ;   and jump back.
.chck:  LDA #charret          ; - Else we need to start the next line
        JSR bsout             ;   Print a carriage return.
        JSR chrin             ; - And get the next pointer
        BNE .bck1
        JSR chrin             ; - Else check 2nd byte of pointer
        BNE .line             ; if both 0 then = end of directory.
                              ; had 3 0's in a row so end of prog
                              ;now close the file.
                              ;
        LDA #$01              ;   file # to close
        JSR close             ; - so close it
        JSR clrch             ; - clear all channels
        RTS                   ; - and return to basic

.dir !pet "$"

;;-----------------------------------------------------------------------

read_err:

; This routine simply grabs bytes from a channel 15 it opens up until
;   a car/ret byte is found. Then it closes and returns.
        LDA #$00              ;   length is 0
        JSR setnam            ; - call setname

        LDA #$0f              ;   file # (15)
        LDX #$08              ;   device # (08)
        LDY #$0f              ;   channel # (15)
        JSR setlfs            ; - set logical file #. Do the equivlent of open 15,8,15.

        JSR open              ; - and open it.

                              ;specify file as input
        LDX #$0f              ;   file 15 is input
        JSR chkin             ; - so specify it.  Now set up file # 15 as input so we can start getting, displaying etc until a car/ret is found.

                              ; now read in file
.loop:  JSR chrin             ; - read char
        JSR bsout             ; - print char
        CMP #charret          ;   is it return?
        BNE .loop             ; - if not jmp back. Read in and display the characters from the error channel until a char/ret is found.

                              ;now close the file
        LDA #$0f              ;   file #
        JSR close             ; - close the file
        JSR clrch             ;   restore i/o. And once it is, we close the file and restore the default i/o settings.
                              ; now return to basic
        RTS                   ; And return to our caller, in this case - basic.
