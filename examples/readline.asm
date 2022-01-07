; Load a file from disk
; Readline
; Create disk image
; cc1541 -f 'test' -T SEQ -w ./test.txt test.d64
; # test.txt has "HELLO WORLD!" in it.
;
; BASIC to read it into a variable and print it.
; 10 OPEN 1, 8, 8, "T, SEQ, R"
; 20 INPUT#1,A$
; 30 CLOSE 1
; 40 PRINT A$

CASSETTE_BUFFER = $033C ;828
SYS_CHRIN   = $FFCF ; Get a character from the input channel
SYS_CLRCHN  = $FFCC ; Clear I/O channels
SYS_SETLFS  = $FFBA ; Set up a logical file.
SYS_SETNAM  = $FFBD ; Set file name
SYS_CHROUT  = $FFD2 ; Write a char to the screen
SYS_STOP    = $FFE1 ; Check if the stop key is being pressed
SYS_READST  = $FFB7 ; Read status register
SYS_CHKIN   = $FFC6 ; Open a channel for input
SYS_OPEN    = $FFC0 ; Open a logical file
SYS_CLOSE   = $FFC3 ; Close a logical file

ZP_LOAD_ADDR_HI = $AE
ZP_LOAD_ADDR_LO = $AF

DEVICE_RS_232C  = 2
DEVICE_SCREEN   = 3
DEVICE_DISK_1   = 8
DEVICE_DISK_2   = 9

NO_COMMAND = 255

FLAG_NO_ERROR            = 0
FLAG_ERROR_TIMEOUT_WRITE = 1
FLAG_ERROR_TIMEOUT_READ  = 2
FLAG_ERROR_EOL           = 64
FLAG_ERROR_EOF           = 64
FLAG_ERROR_NO_DEVICE     = 128

FILENO = 1

ADDR_LAST_USED_DEVICE   = $BA


*= CASSETTE_BUFFER

;########## Jump table ############
JMP main
;##################################


; ############ Global Data ##############
tmp !byte $00

fileName !pet "test"
emaNelif
; #######################################

!zone main {
main:
                                    ; This is an implementation of the BASIC statement: OPEN 1,8,"INPUT.BIN"
        LDA #FILENO                 ; Set logical file number
        LDX ADDR_LAST_USED_DEVICE   ; Get last used device number
        BNE .skip
        LDX #DEVICE_DISK_1          ; Set device number
.skip   LDY #DEVICE_RS_232C         ; Secondary address/command number  (not sure what this means)
        JSR SYS_SETLFS              ; How to Use:
                                    ; - Load the accumulator with the logical file number.
                                    ; - Load the X index register with the device number.
                                    ; - Load the Y index register with the command.

        LDA #emaNelif-fileName      ; Load A with number of characters in file name
        LDX #<fileName              ; Load X and Y with address of FILE .fileName
        LDY #>fileName
        JSR SYS_SETNAM              ; How to Use:
                                    ; - Load the accumulator with the length of the file name.
                                    ; - Load the X index register with the low order address of the file name.
                                    ; - Load the Y index register with the high order address.
                                    ; - Call this routine.


        JSR SYS_OPEN                ; How to Use:
                                    ; - Use the SETLFS routine.
                                    ; - Use the SETNAM routine.
                                    ; - Call this routine.
                                    ; Error returns: 1,2,4,5,6,240
        BCS .error                  ; If carry set, the file could not be opened

        ; check drive error channel here to test for
        ; FILE NOT FOUND error etc.

        LDX #FILENO
        JSR SYS_CHKIN               ; Use this file for input
                                    ; How to Use:
                                    ; - OPEN the logical file (if necessary; see description above).
                                    ; - Load the X register with number of the logical file to be used.
                                    ; - Call this routine (using a JSR command).
                                    ; If error returns with carry set and accumulator set to 5. Otherwise, it stores the serial device number in 99.

-       JSR SYS_READST              ; Read status byte
        BNE .eof                    ; Either EoF or read error
        JSR SYS_CHRIN               ; Get a byte from file
                                    ; How to Use:
                                    ; - Use the KERNAL OPEN and CHKIN routines.
                                    ; - Call this routine (using a JSR instruction).
                                    ; - Store the data.
                                    ; Error returns: 0,3,5,6 (See READST)
        JSR SYS_CHROUT              ; Write data to the output channel, default is screen.
        JMP -


.eof:
        AND #FLAG_ERROR_EOF         ; end of file?
        BEQ .readerror


.close:
        LDA #FILENO
        JSR SYS_CLOSE               ; How to Use:
                                    ; - Load the accumulator with the number of the logical file to be closed.
                                    ; - Call this routine.

        JSR SYS_CLRCHN
        JMP .end


.error:
        ; Accumulator contains BASIC error code
        ; most likely errors:
        ; A = $05 (DEVICE NOT PRESENT)
        ;... error handling for open errors ...
        JMP .close
.readerror:
        ; for further information, the drive error channel has to be read
        ;... error handling for read errors ...
        JMP .close


.end:
        RTS
}
