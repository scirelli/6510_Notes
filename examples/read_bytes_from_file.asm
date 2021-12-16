;Load a file from disk
; Create disk image
; cc1541 -f t -T SEQ -w ./t.txt t.d64
; BASIC to read it into a variable and print it.
; 10 OPEN 1, 8, 8, "T, SEQ, R"
; 20 INPUT#1,A$
; 30 CLOSE 1
; 40 PRINT A$

CASSETTE_BUFFER = $033C ;828
SYS_CHRIN   = $FFCF ; Get a character from the input channel
SYS_SETLFS  = $FFBA ; Set up a logical file.
SYS_SETNAM  = $FFBD ; Set file name
SYS_CHROUT  = $FFD2 ; Write a char to the screen
SYS_STOP    = $FFE1 ; Check if the stop key is being pressed
SYS_READST  = $FFB7 ; Read status register
SYS_CHKIN   = $FFC6 ; Open a channel for input
SYS_OPEN    = $FFC0 ; Open a logical file


DEVICE_SCREEN   = 3
DEVICE_DISK_1   = 8
DEVICE_DISK_2   = 9

NO_COMMAND = 255

ERROR_TIMEOUT_WRITE = 1
ERROR_TIMEOUT_READ  = 2
ERROR_EOL           = 64
ERROR_NO_DEVICE     = -128

FILENO = 1

*= CASSETTE_BUFFER

;########## Jump table ############
JMP main
;##################################

main:
                                ; This is an implementation of the BASIC statement: OPEN 1,8,"INPUT.BIN"
    LDA #FILENO                 ; Set logical file number
    LDX #DEVICE_DISK_1          ; Set device number
    LDY #NO_COMMAND
    JSR SYS_SETLFS

    LDA #.emaNelif-.fileName    ; Load A with number of characters in file name
    LDX #<.fileName             ; Load X and Y with address of FILE .fileName
    LDY #>.fileName
    JSR SYS_SETNAM

    JSR SYS_OPEN                ; Error returns: 1,2,4,5,6,240
    JSR SYS_READST
    AND #ERROR_NO_DEVICE        ; Error device no present
    BNE .error                  ; Handle error

    LDX #FILENO
    JSR SYS_CHKIN               ; Error returns: 0,3,5,6 (See READST)
    JSR SYS_READST
    AND #6
    BNE .error                  ; Handle error

    JSR SYS_CHRIN
    STA .tmp

    JSR SYS_CHROUT

                                ; Check for end of file during read
    JSR SYS_READST
    AND #ERROR_EOL              ; Check EOF bit (EOF=end of file)
    BNE .end                    ; Branch on EOF

.error
.end:
    RTS

; ############ Data ##############
.tmp !byte $00

.fileName !pet "input.bin"
.emaNelif
