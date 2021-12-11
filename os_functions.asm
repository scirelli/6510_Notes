LINPRT = $BDCD ; Output a number in ASCII Decimal Digits. This routine is used to output the line number for the routine above. It converts the number whose high byte is in .A and whose's low byte is in .X to a floating point number. It also calls the routine below which converts the floating point number to an ascii string
CHROUT = $FFD2 ; Print a character.
SETLFS = $FFBA ; Set up a logical file.
SETNAM = $FFBD ; Set file name
OPEN   = $FFC0 ; Open a logical file
CLOSE  = $FFC3 ; Close a logical file
CHKIN  = $FFC6 ; Open a channel for input
CHKOUT = $FFC9 ; Open a channel for output
CLRCHN = $FFCC ; Clear I/O channels
CHRIN  = $FFCF ; Get a character from the input channel
CHROUT = $FFD2 ; Output a character
READST = $FFB7 ; Read status word

